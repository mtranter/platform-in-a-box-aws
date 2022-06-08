terraform {
  backend "s3" {
    bucket = "platform-in-a-box-tf-state"
    key    = "realworld/tfstate"
    region = "ap-southeast-2"
  }
}