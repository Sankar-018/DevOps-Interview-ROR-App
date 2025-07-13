terraform {
  backend "s3" {
    bucket         = "rorapp-terraform-state-devops"
    key            = "devops-infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
