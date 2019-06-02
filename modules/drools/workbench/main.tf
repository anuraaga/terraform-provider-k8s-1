locals {
  command = join("\n", [
    for each in var.users:
      "/opt/jboss/wildfly/bin/add-user.sh -u ${each.user} -p ${each.password} -ro ${each.roles} -a"
  ])
}

locals {
  parameters = {
    name = var.name
    namespace = var.namespace
    replicas = var.replicas
    ports = [
      {
        name = "http"
        port = "8080"
      },
      {
        name = "git"
        port = "8001"
      }
    ]
    enable_service_links = false
    containers = [
      {
        name = "workbench"
        image = var.image
        lifecycle = {
          post_start = {
            exec = {
              command = [
                "bash",
                "-cx",
                local.command
              ]
            }
          }
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
