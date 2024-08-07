resource "kubernetes_service_account" "eks_s3_access" {
  metadata {
    name      = "eks-s3-access"
    namespace = "default"

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account_id}:role/EKSClusterS3WriterIAMRole"
    }
  }
}

resource "kubernetes_config_map" "python_script_configmap" {
  metadata {
    name      = "python-script"
    namespace = "default"
  }
  data = {
    "cronjob.py" = file("cronjob.py")
  }
}

resource "kubernetes_cron_job_v1" "example_cronjob" {
  metadata {
    name      = "example-cronjob"
    namespace = "default"
  }

  spec {
    schedule = "* * * * *"

    job_template {
      metadata {
        name      = "example-cronjob-job"
        namespace = "default"
      }
      spec {
        template {
          metadata {
            name = "example-cronjob-spec"
          }
          spec {
            service_account_name = "eks-s3-access"
            container {
              image   = "python:slim"
              name    = "example-cronjob"
              command = ["sh", "-c", "pip install requests boto3; printenv; python /code/cronjob.py"]
              volume_mount {
                mount_path = "/code"
                name       = kubernetes_config_map.python_script_configmap.metadata[0].name
              }
            }
            volume {
              name = "python-script"
              config_map {
                name = kubernetes_config_map.python_script_configmap.metadata[0].name
              }
            }
            restart_policy = "Never"
          }
        }
      }
    }
  }
}
