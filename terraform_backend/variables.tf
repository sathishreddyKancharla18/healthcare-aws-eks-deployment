# region variable is not used in the main.tf file, but it is defined in the variables.tf file and used in the providers.tf file.
# purpose: As s3 is globally unique, we need to ensure that the bucket name is unique across all AWS accounts and regions.
variable "region" {
  description = "AWS Region to deploy backend"
  type        = string
  default     = "us-east-1"
}