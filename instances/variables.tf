variable resource_group {}
variable name {}
variable subnet_id {}
variable vpc {}
variable zone {}
variable security_group {}
variable ssh_key_ids {}
variable image_name {
  default = "ibm-ubuntu-20-04-minimal-amd64-2"
}
variable profile_name {
  default = "cx2-2x4"
}

variable tags {}