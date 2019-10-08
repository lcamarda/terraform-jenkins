resource "vsphere_virtual_machine" "webvm" {
    name             = "${var.tenant_name}-webvm"
    depends_on = ["nsxt_logical_switch.web"]
    resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
    datastore_id     = "${data.vsphere_datastore.datastore.id}"
    num_cpus = 1
    memory   = 2048
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
    # Attach the VM to the network data source that refers to the newly created logical switch
    network_interface {
      network_id = "${data.vsphere_network.terraform_web.id}"
    }
    disk {
        label = "${var.tenant_name}-webvm.vmdk"
        size = 16
        thin_provisioned = true
    }
    clone {
        template_uuid = "${data.vsphere_virtual_machine.template.id}"
    }
}
