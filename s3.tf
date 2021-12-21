#### In Testing ####
# resource "aws_s3_bucket" "kube_config" {
#   bucket = "sunny-kube-config-bucket"
#   acl    = "private"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }

# resource "aws_kms_key" "kube_config" {
#   description             = "KMS key 1"
#   deletion_window_in_days = 7
# }

# resource "aws_s3_bucket_object" "kube_config_file" {
#   key        = "kube_config"
#   bucket     = aws_s3_bucket.kube_config.id
#   source     = var.kubeconfig_file
#   kms_key_id = aws_kms_key.kube_config.arn
# }

