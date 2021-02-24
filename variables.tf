variable "region" {
  type        = string
  description = "The region where the VPC resources will be deployed."
  default     = ""
}

variable tags {
  default = ["owner:ryantiffany"]
}

variable "vpc_ssh_key_name" {
  default     = ""
  description = "(Optional) Name of an existing VPC SSH key to inject in all created instances"
}

variable "resource_group" {
  default     = ""
  description = "Name of an existing resource group where to create resources"
}

variable "existing_vpc_name" {
  default     = ""
  description = "(Optional) Name of an existing VPC where to add the bastion"
}

variable "existing_subnet_id" {
  default     = ""
  description = "(Optional) ID of an existing subnet where to add the bastion. VPC name must be set too."
}

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key to create resources"
}

variable "ibmcloud_timeout" {
  default = 900
}

variable name {

} 