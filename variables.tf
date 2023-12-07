variable "region" {
  description = "AWS region"
  //default     = "us-east-1"
}

variable "account_id" {
  description = "AWS account ID"
  //default     = "us-east-1"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  /*default     = {
    project     = "aws-proserv",
    environment = "dev"
    application = "cohort-demo"
  }
  */
}

variable "resource_tags_dr" {
  description = "Tags to set for all resources"
  type        = map(string)
  /*default     = {
    project     = "aws-proserv",
    environment = "dev"
    application = "cohort-demo"
    backup      = "yes"
  }
  */
}

