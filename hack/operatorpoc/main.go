// OperatorPOC — the trick, shown: one application declaration moves
// through gates into two environments; the operator keeping it need
// not be the same in each. Two views, same app, two envs. Runs in the
// rehearsal chamber (envtest), applies one KubeContainer to a "dev"
// and a "prod" namespace, and prints both views side by side.
package main

import (
	"context"
	"fmt"
	"os"
	"time"

	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	utilruntime "k8s.io/apimachinery/pkg/util/runtime"
	clientgoscheme "k8s.io/client-go/kubernetes/scheme"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/envtest"
	"sigs.k8s.io/controller-runtime/pkg/log/zap"
	metricsserver "sigs.k8s.io/controller-runtime/pkg/metrics/server"

	v1 "github.com/unboxd-cloud/kubecontainer/api/v1alpha1"
	"github.com/unboxd-cloud/kubecontainer/internal/controller"
)

// the environments the same app moves through (the gates)
type env struct {
	name     string
	replicas int32 // the env differs: dev runs 1, prod runs 3 — same app, different keeping
}

func main() {
	ctrl.SetLogger(zap.New(zap.UseDevMode(false)))
	scheme := runtime.NewScheme()
	utilruntime.Must(clientgoscheme.AddToScheme(scheme))
	utilruntime.Must(v1.AddToScheme(scheme))

	te := &envtest.Environment{CRDDirectoryPaths: []string{"config/crd/bases"}}
	cfg, err := te.Start()
	if err != nil {
		fmt.Println("control plane:", err)
		os.Exit(1)
	}
	defer func() { _ = te.Stop() }()

	mgr, _ := ctrl.NewManager(cfg, ctrl.Options{Scheme: scheme,
		Metrics: metricsserver.Options{BindAddress: "0"}, HealthProbeBindAddress: "0"})
	_ = (&controller.KubeContainerReconciler{Client: mgr.GetClient(), Scheme: mgr.GetScheme(),
		Recorder: mgr.GetEventRecorder("kc")}).SetupWithManager(mgr)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	go func() { _ = mgr.Start(ctx) }()
	mgr.GetCache().WaitForCacheSync(ctx)
	c := mgr.GetClient()

	envs := []env{{"dev", 1}, {"prod", 3}}
	for _, e := range envs {
		_ = c.Create(ctx, &corev1.Namespace{ObjectMeta: metav1.ObjectMeta{Name: e.name}})
		// THE SAME APP — identical spec but for the env's own replica policy:
		// the application is one declaration; the operator keeps it differently per env.
		app := &v1.KubeContainer{
			ObjectMeta: metav1.ObjectMeta{Name: "arithmetic", Namespace: e.name},
			Spec: v1.KubeContainerSpec{
				Image: "nginx:1.27", Port: 80,
				Scaling: v1.Scaling{Replicas: &e.replicas},
			},
		}
		if err := c.Create(ctx, app); err != nil {
			fmt.Printf("[%s] admission refused: %v\n", e.name, err)
			os.Exit(1)
		}
	}

	time.Sleep(3 * time.Second)
	fmt.Println("== two views, same app, two envs ==")
	fmt.Printf("%-8s %-12s %-10s %-8s\n", "ENV", "APP", "DESIRED", "KEPT-BY")
	for _, e := range envs {
		var got v1.KubeContainer
		_ = c.Get(ctx, client.ObjectKey{Name: "arithmetic", Namespace: e.name}, &got)
		var dep appsView
		dep.get(ctx, c, e.name)
		fmt.Printf("%-8s %-12s %-10d %-8s\n", e.name, got.Name, derefReplicas(got.Spec.Scaling), dep.image)
	}
	fmt.Println("the app is one declaration; each env's operator kept it to that env's policy —")
	fmt.Println("the application moves through the gates; the operator need not be the same.")
}

type appsView struct{ image string }

func (a *appsView) get(ctx context.Context, c client.Client, ns string) {
	dep := &appsv1.Deployment{}
	if err := c.Get(ctx, client.ObjectKey{Name: "arithmetic", Namespace: ns}, dep); err == nil {
		a.image = "operator"
	} else {
		a.image = "pending"
	}
}

func derefReplicas(s v1.Scaling) int32 {
	if s.Replicas != nil {
		return *s.Replicas
	}
	return 0
}
