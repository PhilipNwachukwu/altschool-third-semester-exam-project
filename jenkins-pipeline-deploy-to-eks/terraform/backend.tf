terraform {
  backend "s3" {
    bucket = "myaltschoolapp-bucket"
    region = "eu-west-2"
    key    = "eks/terraform.tfstate"
  }
}
