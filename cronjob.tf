terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_cron_job" "example_cronjob" {
  metadata {
    name = "example-cronjob"
    namespace = "default"
  }

  spec {
    schedule = "*/1 * * * *"  # Cron schedule (runs every minute in this example)

    job_template {
      metadata {
        labels = {
          app = "example-cronjob"
        }
      }
      spec {
        template {
          metadata {
            labels = {
              app = "example-cronjob"
            }
          }
          spec {
            container {
              image = "busybox"
              name  = "example-cronjob"
              args  = ["date"]  # Command to run in the container
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
