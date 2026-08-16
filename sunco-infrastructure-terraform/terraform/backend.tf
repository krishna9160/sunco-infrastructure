terraform {
  backend "s3" {
    bucket = "sunco-terraform-state-filestorage"
    key    = "sunco/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
