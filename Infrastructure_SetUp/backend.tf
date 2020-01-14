data "terraform_remote_state" "wordpress_state" {
  backend = "s3"

  config = {
    bucket     = "wordpress-tfstate"
    key        = "infra.tfstate"
    region     = "eu-central-1"
    kms_key_id = aws_kms_key.s3_encryption_key
  }
}

resource "aws_kms_key" "s3_encryption_key" {
  deletion_window_in_days = 5
}