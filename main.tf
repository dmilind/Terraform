/* 
Terraform main config file which call modules, 
New parametes should be appended to variables.tf as well as same one from module.
Parameter values should be provided in terraform.tfvars file under module.
var-file would be terraform.tfvars from module.
*/

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = true
}

/*
# BACKEND #
terraform {
  backend "consul" {
    address = "${var.consul_address}"
    path    = "${var.consul_path}"
  }
}
*/

module "moduleName" {
  source = "./modules/moduleName"

  datacenter      = "${var.datacenter}"
  datastore       = "${var.datastore}"
  template        = "${var.template}"
  cluster         = "${var.cluster}"
  resource_pool   = "${var.resource_pool}"
  domain          = "${var.domain}"
  cpus            = "${var.cpus}"
  memory          = "${var.memory}"
  network         = "${var.network}"
  server_hostname = "${var.server_hostname}"
  server_ip       = "${var.server_ip}"
  server_gateway  = "${var.server_gateway}"
  consul_path     = "${var.consul_path}"
  consul_address  = "${var.consul_address}"
  disk01          = "${var.disk01}"
}

output "host_ip_address" {
  value = "${module.moduleName.ipaddr}"
}
