# The home, declared — OpenTofu. The ground as config: plan, apply,
# idempotent; the provider is the builder's pick (pick your metal),
# declared in providers.tf beside this file at first apply.

variable "gitlab_host"    { default = "git.unboxd.cloud" }
variable "gitlab_version" { default = "19.0.2-ce.0" }
variable "gitlab_port"    { default = 8081 }      # behind the front proxy
variable "traefik_policy" { default = "route" }   # route | evict
variable "install_k0s"    { default = true }
variable "kc_bundle" {
  default = "https://github.com/unboxd-cloud/KubeContainer/releases/download/v0.2.0/install.yaml"
}

# The declaration of record for the home's converge. The resources
# below are the skeleton the provider fills: the VPS (or the existing
# host imported), its DNS A record, and the converge run by the
# HomeSetup binary as the machine's first boot act — the binary walks,
# the declaration governs.
#
# resource "<provider>_server" "home" { ... }
# resource "<provider>_dns_record" "git" {
#   name = "git", type = "A", value = <server ip>
# }
# provisioner: homesetup -host ${var.gitlab_host} \
#   -gitlab-version ${var.gitlab_version} -traefik ${var.traefik_policy}
