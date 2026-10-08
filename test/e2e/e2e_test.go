//go:build e2e
// +build e2e

/*
Copyright 2026.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package e2e

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"github.com/unboxd-cloud/kubecontainer/test/utils"
)

const namespace = "kubecontainer-system"
const serviceAccountName = "kubecontainer-controller-manager"
const metricsServiceName = "kubecontainer-controller-manager-metrics-service"
const metricsRoleBindingName = "kubecontainer-metrics-binding"

var _ = Describe("Manager", Ordered, func() {
	var controllerPodName string

	BeforeAll(func() {
		By("creating manager namespace")
		_, err := utils.Run(exec.Command("kubectl", "create", "ns", namespace))
		Expect(err).NotTo(HaveOccurred(), "Failed to create namespace")

		By("labeling the namespace to enforce the restricted security policy")
		_, err = utils.Run(exec.Command("kubectl", "label", "--overwrite", "ns", namespace,
			"pod-security.kubernetes.io/enforce=restricted"))
		Expect(err).NotTo(HaveOccurred(), "Failed to label namespace with restricted policy")

		By("installing CRDs")
		_, err = utils.Run(exec.Command("make", "install"))
		Expect(err).NotTo(HaveOccurred(), "Failed to install CRDs")

		By("deploying the controller-manager")
		_, err = utils.Run(exec.Command("make", "deploy", fmt.Sprintf("IMG=%s", managerImage)))
		Expect(err).NotTo(HaveOccurred(), "Failed to deploy the controller-manager")
	})

	AfterAll(func() {
		_, _ = utils.Run(exec.Command("kubectl", "delete", "pod", "curl-metrics", "-n", namespace, "--ignore-not-found"))
		_, _ = utils.Run(exec.Command("make", "undeploy"))
		_, _ = utils.Run(exec.Command("make", "uninstall"))
		_, _ = utils.Run(exec.Command("kubectl", "delete", "ns", namespace, "--ignore-not-found"))
	})

	AfterEach(func() {
		if !CurrentSpecReport().Failed() {
			return
		}

		if controllerPodName != "" {
			By("Fetching controller manager pod logs")
			if controllerLogs, err := utils.Run(exec.Command("kubectl", "logs", controllerPodName, "-n", namespace)); err == nil {
				_, _ = fmt.Fprintf(GinkgoWriter, "Controller logs:\n%s", controllerLogs)
			}

			By("Fetching controller manager pod description")
			if podDescription, err := utils.Run(exec.Command("kubectl", "describe", "pod", controllerPodName, "-n", namespace)); err == nil {
				_, _ = fmt.Fprintf(GinkgoWriter, "Pod description:\n%s", podDescription)
			}
		}

		By("Fetching Kubernetes events")
		if eventsOutput, err := utils.Run(exec.Command("kubectl", "get", "events", "-A", "--sort-by=.lastTimestamp")); err == nil {
			_, _ = fmt.Fprintf(GinkgoWriter, "Kubernetes events:\n%s", eventsOutput)
		}

		By("Fetching curl-metrics logs")
		if metricsOutput, err := utils.Run(exec.Command("kubectl", "logs", "curl-metrics", "-n", namespace)); err == nil {
			_, _ = fmt.Fprintf(GinkgoWriter, "Metrics logs:\n%s", metricsOutput)
		}
	})

	SetDefaultEventuallyTimeout(2 * time.Minute)
	SetDefaultEventuallyPollingInterval(time.Second)

	Context("Manager", func() {
		It("should run successfully", func() {
			verifyControllerUp := func(g Gomega) {
				By("getting the name of the controller-manager pod")
				cmd := exec.Command("kubectl", "get",
					"pods", "-l", "control-plane=controller-manager",
					"-o", "go-template={{ range .items }}{{ if not .metadata.deletionTimestamp }}{{ .metadata.name }}{{ \"\\n\" }}{{ end }}{{ end }}",
					"-n", namespace)
				podOutput, err := utils.Run(cmd)
				g.Expect(err).NotTo(HaveOccurred(), "Failed to retrieve controller-manager pod information")
				podNames := utils.GetNonEmptyLines(podOutput)
				g.Expect(podNames).To(HaveLen(1), "expected 1 controller pod running")
				controllerPodName = podNames[0]
				g.Expect(controllerPodName).To(ContainSubstring("controller-manager"))

				By("validating the pod's status")
				output, err := utils.Run(exec.Command("kubectl", "get", "pods", controllerPodName,
					"-o", "jsonpath={.status.phase}", "-n", namespace))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(Equal("Running"), "Incorrect controller-manager pod status")
			}
			Eventually(verifyControllerUp).Should(Succeed())
		})

		It("should ensure the metrics endpoint is serving metrics", func() {
			By("creating a ClusterRoleBinding for the service account to allow access to metrics")
			_, err := utils.Run(exec.Command("kubectl", "create", "clusterrolebinding", metricsRoleBindingName,
				"--clusterrole=kubecontainer-metrics-reader",
				fmt.Sprintf("--serviceaccount=%s:%s", namespace, serviceAccountName)))
			Expect(err).NotTo(HaveOccurred(), "Failed to create ClusterRoleBinding")

			By("validating that the metrics service is available")
			_, err = utils.Run(exec.Command("kubectl", "get", "service", metricsServiceName, "-n", namespace))
			Expect(err).NotTo(HaveOccurred(), "Metrics service should exist")

			By("getting the service account token")
			token, err := serviceAccountToken()
			Expect(err).NotTo(HaveOccurred())
			Expect(token).NotTo(BeEmpty())

			By("ensuring the controller pod is ready")
			verifyControllerPodReady := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "get", "pod", controllerPodName, "-n", namespace,
					"-o", "jsonpath={.status.conditions[?(@.type=='Ready')].status}"))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(Equal("True"), "Controller pod not ready")
			}
			Eventually(verifyControllerPodReady, 3*time.Minute, time.Second).Should(Succeed())

			By("verifying that the controller manager is serving the metrics server")
			verifyMetricsServerStarted := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "logs", controllerPodName, "-n", namespace))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(ContainSubstring("Serving metrics server"), "Metrics server not yet started")
			}
			Eventually(verifyMetricsServerStarted, 3*time.Minute, time.Second).Should(Succeed())

			By("creating the curl-metrics pod to access the metrics endpoint")
			overrides := fmt.Sprintf(`{
				"spec": {
					"containers": [{
						"name": "curl",
						"image": "curlimages/curl:latest",
						"command": ["/bin/sh", "-c"],
						"args": ["for i in $(seq 1 30); do curl -v -k -H 'Authorization: Bearer %s' https://%s.%s.svc.cluster.local:8443/metrics && exit 0 || sleep 2; done; exit 1"],
						"securityContext": {
							"readOnlyRootFilesystem": true,
							"allowPrivilegeEscalation": false,
							"capabilities": {"drop": ["ALL"]},
							"runAsNonRoot": true,
							"runAsUser": 1000,
							"seccompProfile": {"type": "RuntimeDefault"}
						}
					}],
					"serviceAccountName": "%s"
				}
			}`, token, metricsServiceName, namespace, serviceAccountName)
			_, err = utils.Run(exec.Command("kubectl", "run", "curl-metrics", "--restart=Never",
				"--namespace", namespace, "--image=curlimages/curl:latest", "--overrides", overrides))
			Expect(err).NotTo(HaveOccurred(), "Failed to create curl-metrics pod")

			By("waiting for the curl-metrics pod to complete")
			verifyCurlUp := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "get", "pods", "curl-metrics",
					"-o", "jsonpath={.status.phase}", "-n", namespace))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(Equal("Succeeded"), "curl pod in wrong status")
			}
			Eventually(verifyCurlUp, 5*time.Minute).Should(Succeed())

			By("getting the metrics by checking curl-metrics logs")
			verifyMetricsAvailable := func(g Gomega) {
				metricsOutput, err := getMetricsOutput()
				g.Expect(err).NotTo(HaveOccurred(), "Failed to retrieve logs from curl pod")
				g.Expect(metricsOutput).NotTo(BeEmpty())
				g.Expect(metricsOutput).To(ContainSubstring("< HTTP/1.1 200 OK"))
			}
			Eventually(verifyMetricsAvailable, 2*time.Minute).Should(Succeed())
		})

		It("should reconcile a declared workload to Ready and serve traffic", func() {
			workload := "e2e-workload"

			By("declaring a KubeContainer workload")
			manifest := fmt.Sprintf(`
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: %s
  namespace: default
spec:
  image: nginx:1.27
  port: 80
  scaling:
    replicas: 1
  healthCheck:
    path: /
`, workload)
			cmd := exec.Command("kubectl", "apply", "-f", "-")
			cmd.Stdin = strings.NewReader(manifest)
			_, err := utils.Run(cmd)
			Expect(err).NotTo(HaveOccurred(), "Failed to apply KubeContainer manifest")
			DeferCleanup(func() {
				_, _ = utils.Run(exec.Command("kubectl", "delete", "kubecontainer", workload, "-n", "default", "--ignore-not-found"))
				_, _ = utils.Run(exec.Command("kubectl", "delete", "pod", "curl-workload", "-n", "default", "--ignore-not-found"))
			})

			By("waiting for the KubeContainer to report Ready=True")
			verifyReady := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "get", "kubecontainer", workload,
					"-n", "default", "-o", "jsonpath={.status.conditions[?(@.type=='Ready')].status}"))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(Equal("True"), "workload should converge to Ready")
			}
			Eventually(verifyReady, 5*time.Minute).Should(Succeed())

			By("verifying the reported endpoint serves real traffic")
			endpoint, err := utils.Run(exec.Command("kubectl", "get", "kubecontainer", workload,
				"-n", "default", "-o", "jsonpath={.status.endpoint}"))
			Expect(err).NotTo(HaveOccurred())
			Expect(endpoint).NotTo(BeEmpty(), "status.endpoint should be populated")

			_, err = utils.Run(exec.Command("kubectl", "run", "curl-workload",
				"--restart=Never", "-n", "default",
				"--image=curlimages/curl:latest", "--",
				"curl", "-s", "-o", "/dev/null", "-w", "%{http_code}", fmt.Sprintf("http://%s/", endpoint)))
			Expect(err).NotTo(HaveOccurred(), "Failed to create curl-workload pod")

			verifyServing := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "get", "pod", "curl-workload", "-n", "default", "-o", "jsonpath={.status.phase}"))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(output).To(Equal("Succeeded"))
				logs, err := utils.Run(exec.Command("kubectl", "logs", "curl-workload", "-n", "default"))
				g.Expect(err).NotTo(HaveOccurred())
				g.Expect(logs).To(Equal("200"), "endpoint should answer HTTP 200")
			}
			Eventually(verifyServing, 3*time.Minute).Should(Succeed())

			By("deleting the managed Deployment to prove reconciliation repairs drift")
			_, err = utils.Run(exec.Command("kubectl", "delete", "deployment", workload, "-n", "default", "--wait=true"))
			Expect(err).NotTo(HaveOccurred(), "Failed to delete the managed Deployment")

			By("waiting for the operator to recreate the Deployment and restore readiness")
			verifyRecovered := func(g Gomega) {
				output, err := utils.Run(exec.Command("kubectl", "get", "deployment", workload,
					"-n", "default", "-o", "jsonpath={.status.availableReplicas}"))
				g.Expect(err).NotTo(HaveOccurred(), "operator should recreate the Deployment")
				g.Expect(output).To(Equal("1"), "recreated Deployment should have an available replica")
			}
			Eventually(verifyRecovered, 5*time.Minute, time.Second).Should(Succeed())
			Eventually(verifyReady, 2*time.Minute, time.Second).Should(Succeed())

			By("writing structured runtime evidence before cleanup")
			resourceJSON, err := exec.Command("kubectl", "get", "kubecontainer", workload, "-n", "default", "-o", "json").Output()
			Expect(err).NotTo(HaveOccurred())

			var resource map[string]any
			Expect(json.Unmarshal(resourceJSON, &resource)).To(Succeed())
			status, ok := resource["status"].(map[string]any)
			Expect(ok).To(BeTrue(), "status should be present in live evidence")

			evidence := map[string]any{
				"apiVersion":         "evidence.kubecontainer.unboxd.cloud/v1alpha1",
				"kind":               "KubeContainerReleaseEvidence",
				"workload":           workload,
				"httpStatus":         200,
				"driftRecovered":     true,
				"observedGeneration": status["observedGeneration"],
				"endpoint":           status["endpoint"],
				"conditions":         status["conditions"],
				"verdict":            "PROMISE_KEPT",
			}
			evidenceJSON, err := json.MarshalIndent(evidence, "", "  ")
			Expect(err).NotTo(HaveOccurred())
			Expect(os.MkdirAll("dist", 0o755)).To(Succeed())
			Expect(os.WriteFile("dist/e2e-release-evidence.json", evidenceJSON, 0o644)).To(Succeed())

			By("deleting the KubeContainer and verifying owned resources are garbage-collected")
			_, err = utils.Run(exec.Command("kubectl", "delete", "kubecontainer", workload, "-n", "default", "--wait=true"))
			Expect(err).NotTo(HaveOccurred(), "Failed to delete the KubeContainer")

			verifyGarbageCollected := func(g Gomega) {
				for _, kind := range []string{"deployment", "service"} {
					output, err := utils.Run(exec.Command("kubectl", "get", kind, workload, "-n", "default", "--ignore-not-found", "-o", "name"))
					g.Expect(err).NotTo(HaveOccurred())
					g.Expect(strings.TrimSpace(output)).To(BeEmpty(), "%s should be garbage-collected", kind)
				}
			}
			Eventually(verifyGarbageCollected, 3*time.Minute, time.Second).Should(Succeed())
		})

		It("should reject malformed, invalid, and unauthorized KubeContainer requests safely", func() {
			invalidCases := []struct {
				name     string
				manifest string
			}{
				{name: "unknown field", manifest: `
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: invalid-unknown
  namespace: default
spec:
  image: nginx:1.27
  port: 80
  unexpectedField: rejected
`},
				{name: "conflicting scaling modes", manifest: `
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: invalid-scaling
  namespace: default
spec:
  image: nginx:1.27
  port: 80
  scaling:
    replicas: 1
    autoscale:
      minReplicas: 1
      maxReplicas: 2
`},
				{name: "ingress without host", manifest: `
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: invalid-ingress
  namespace: default
spec:
  image: nginx:1.27
  port: 80
  expose:
    type: Ingress
`},
				{name: "invalid port", manifest: `
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: invalid-port
  namespace: default
spec:
  image: nginx:1.27
  port: 70000
`},
			}

			for _, tc := range invalidCases {
				By("proving the API server rejects " + tc.name)
				cmd := exec.Command("kubectl", "apply", "-f", "-")
				cmd.Stdin = strings.NewReader(tc.manifest)
				output, err := cmd.CombinedOutput()
				Expect(err).To(HaveOccurred(), "invalid request must be rejected: %s", tc.name)
				Expect(strings.TrimSpace(string(output))).NotTo(BeEmpty())
			}

			By("proving Kubernetes RBAC denies an unauthorized KubeContainer create before reconciliation")
			unauthorized := `
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: unauthorized-rbac
  namespace: default
spec:
  image: nginx:1.27
  port: 80
`
			cmd := exec.Command("kubectl", "apply", "--as=system:serviceaccount:default:kubecontainer-denied", "-f", "-")
			cmd.Stdin = strings.NewReader(unauthorized)
			output, err := cmd.CombinedOutput()
			Expect(err).To(HaveOccurred(), "unauthorized request must fail before reconciliation")
			Expect(string(output)).To(ContainSubstring("cannot create resource"))
			Expect(string(output)).To(ContainSubstring("kubecontainers"))

			created, err := utils.Run(exec.Command("kubectl", "get", "kubecontainer", "unauthorized-rbac", "-n", "default", "--ignore-not-found", "-o", "name"))
			Expect(err).NotTo(HaveOccurred())
			Expect(strings.TrimSpace(created)).To(BeEmpty(), "unauthorized KubeContainer must not persist")
		})
	})
})

func serviceAccountToken() (string, error) {
	const tokenRequestRawString = `{
		"apiVersion": "authentication.k8s.io/v1",
		"kind": "TokenRequest"
	}`

	By("creating temporary file to store the token request")
	secretName := fmt.Sprintf("%s-token-request", serviceAccountName)
	tokenRequestFile := filepath.Join("/tmp", secretName)
	if err := os.WriteFile(tokenRequestFile, []byte(tokenRequestRawString), os.FileMode(0o644)); err != nil {
		return "", err
	}

	var out string
	verifyTokenCreation := func(g Gomega) {
		By("executing kubectl command to create the token")
		cmd := exec.Command("kubectl", "create", "--raw", fmt.Sprintf(
			"/api/v1/namespaces/%s/serviceaccounts/%s/token", namespace, serviceAccountName), "-f", tokenRequestFile)
		output, err := cmd.CombinedOutput()
		g.Expect(err).NotTo(HaveOccurred())

		By("parsing the JSON output to extract the token")
		var token tokenRequest
		g.Expect(json.Unmarshal(output, &token)).To(Succeed())
		out = token.Status.Token
	}
	Eventually(verifyTokenCreation).Should(Succeed())

	return out, nil
}

func getMetricsOutput() (string, error) {
	By("getting the curl-metrics logs")
	return utils.Run(exec.Command("kubectl", "logs", "curl-metrics", "-n", namespace))
}

type tokenRequest struct {
	Status struct {
		Token string `json:"token"`
	} `json:"status"`
}
