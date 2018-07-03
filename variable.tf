# Variables provided to main.tf file

variable "vsphere_user" {}

variable "vsphere_password" {}

variable "vsphere_server" {}

variable "datacenter" {}

variable "datastore" {}

variable "network" {}

variable "template" {}

variable "cluster" {}

variable "cpus" {}

variable "memory" {}

variable "domain" {}

variable "server_gateway" {}

variable "consul_address" {}

variable "consul_path" {}

variable "resource_pool" {}

variable "server_hostname" {
  type = "list"
}

variable "server_ip" {
  type = "list"
}

variable "disk01" {
  type = "list"
}
