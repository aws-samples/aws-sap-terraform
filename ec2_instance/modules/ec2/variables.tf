
variable "aws_region" {
  description = "Region where to run this TF in"
  type        = string
}

variable "environment" {
  description = "Environment to be used for this run"
  type        = string
}

variable "hostname" {
  description = "Hostname"
  type        = string
}

variable "domain" {
  description = "Domain for host"
  type        = string
}

variable "private_ip" {
  description = "Private Ip address"
  type        = string
}

variable "application_code" {
  description = "Application code (HANA or NetWeaver)"
  type        = string
}

variable "application_SID" {
  description = "Application SID"
  type        = string
}

variable "ha" {
  description = "Is the EC2 part of an HA cluster"
  type        = bool
}

variable "ami_ID" {
  description = "AMI ID"
  type        = string
}

variable "subnet_ID" {
  description = "Subnet ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "hana_data_storage_type" {
  description = "Storage type (gp3, io2, etc)"
  type        = string
}

variable "hana_logs_storage_type" {
  description = "Storage type (gp3, io2, etc)"
  type        = string
}

variable "hana_backup_storage_type" {
  description = "Storage type (gp3, gp2, st1, etc)"
  type        = string
}

variable "hana_shared_storage_type" {
  description = "Storage type (gp3, gp2, etc)"
  type        = string
}

variable "custom_ebs_config" {
  description = "Custom EBS configuration"
  #type        = list
}

variable "key_name" {
  description = "Key name"
  type        = string
}

variable "monitoring" {
  description = "Detailed monitoring"
  type        = bool
}

variable "root_ebs_size" {
  description = "Size root volume"
  type        = string
}

variable "ec2_tags" {
  description = "EC2 tags"
  type        = map(any)
}
