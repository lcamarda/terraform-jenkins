# Configure the VMware NSX-T Provider
provider "nsxt" {
  host                 = "${var.nsx_ip}"
  username             = "admin"
  password             = "${var.nsx_password}"
  allow_unverified_ssl = true
}


# Create the data sources we will need to refer to later
data "nsxt_transport_zone" "overlay_tz" {
  display_name = "OVERLAY-TZ"
}

data "nsxt_logical_tier0_router" "tier0_router" {
  display_name = "T0-SITEA"
}

data "nsxt_edge_cluster" "edge_cluster" {
  display_name = "edge-cluster-01a"
}


provider "vsphere" {
    user           = "${var.vsphere_user}"
    password       = "${var.vsphere_password}"
    vsphere_server = "${var.vsphere_server}"
    allow_unverified_ssl = true
}

# data source for my vSphere Data Center
data "vsphere_datacenter" "dc" {
  name = "RegionA01"
}

# Datastore data source
data "vsphere_datastore" "datastore" {
  name          = "esx-04a-local"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# data source for my cluster's default resource pool
data "vsphere_resource_pool" "pool" {
  name          = "terraform"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Data source for the template I am going to use to clone my VM from
data "vsphere_virtual_machine" "template" {
    name = "web"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "terraform_web" {
    name = "${nsxt_logical_switch.web.display_name}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
    depends_on = ["nsxt_logical_switch.web"]
}



