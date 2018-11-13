variable "name" {}

variable "command" {}

variable image {
  default = "registry.rebelsoft.com/base"
}

variable restart_policy {
  default = "Never"
}

variable backoff_limit {
  default = 4
}

resource "k8s_batch_v1_job" "this" {
  metadata {
    name = "${var.name}"
  }

  spec {
    selector = {}

    template {
      metadata = {}

      spec {
        containers {
          name      = "base"
          image     = "${var.image}"
          command   = ["bash", "-cx", "${var.command}"]
          resources = {}
        }

        restart_policy   = "${var.restart_policy}"
        security_context = {}
      }
    }

    backoff_limit = "${var.backoff_limit}"
  }
}
