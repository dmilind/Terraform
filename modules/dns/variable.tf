#############################################
# DNS Host:                                 #
# Variables For Terraform Config File       #
############################################# 

variable "datacenter" {}

variable "datastore" {}

variable "network" {}

variable "template" {}

variable "cluster" {}

variable "cpus" {}

variable "memory" {}

variable "consul_address" {}

variable "consul_path" {}

variable "domain" {}

variable "server_gateway" {}

variable "resource_pool" {}

variable "disk01" {
  type = "list"
}

variable "server_hostname" {
  type = "list"
}

variable "server_ip" {
  type = "list"
}
