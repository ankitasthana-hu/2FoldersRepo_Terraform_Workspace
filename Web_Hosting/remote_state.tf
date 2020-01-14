data "terraform_remote_state" "infra_remote_state" {
  backend = "s3"

  config = {
    bucket = "wordpress-tfstate"
    key    = "infra.tfstate"
    region = "eu-central-1"
  }
}