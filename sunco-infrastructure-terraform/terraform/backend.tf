terraform {
  backend "s3" {
    bucket = "sunco-terraform-state-file"
    key    = "sunco/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
