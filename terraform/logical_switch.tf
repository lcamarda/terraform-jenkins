resource "nsxt_logical_switch" "web" {
  admin_state       = "UP"
  description       = "LS created by Terraform"
  display_name      = "OV-Web-Terraform-${var.tenant_name}"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode  = "MTEP"
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}


