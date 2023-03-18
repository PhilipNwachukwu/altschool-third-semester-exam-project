terraform {
  backend "s3" {
    bucket = "myaltschoolapp-bucket"
    region = "eu-west-2"
    key    = "jenkins-server/terraform.tfstate"
  }
}
