variable "aws_region" {
  description = "Region where to run this TF in"
  type        = string
}

variable "environment" {
  description = "Environment being built. DEV, QA or PRD"
  type        = string
}

variable "sap_discovery_tag" {
  description = "Tag key that identifies sap relevant objects"
  type        = string
}

variable "db_sg_list" {
  description = "DB SG List"
  type        = any
}

variable "app_sg_list" {
  description = "App SG List"
  type        = any
}
