output "service_account_name" {
  value = kubernetes_service_account.eks_s3_access.metadata[0].name
}

output "config_map_name" {
  value = kubernetes_config_map.python_script_configmap.metadata[0].name
}

output "cron_job_name" {
  value = kubernetes_cron_job_v1.example_cronjob.metadata[0].name
}
