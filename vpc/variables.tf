variable name {
  description = "A name for your VPC. This will also be added as a tag on the VPC resource"
  type        = string
  default     = ""
}

variable resource_group {
  description = "Resource group for deployed assets."
  type        = string
  default     = ""
}

variable tags {
  description = "Tags to add to VPC."
  type        = list
  default     = []
}