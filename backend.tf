terraform {
  backend "s3" {
    bucket = "talent-academy-terraform-tfstates-787786425565"
    key    = "sprint1/week4/tf_vpc_challenges/terraform.tfstates"
    lock   = "dynamodb"
  }
}