resource "nsxt_nat_rule" "rule1" {
  logical_router_id         = "${nsxt_logical_tier1_router.tier1_router.id}"
  description               = "SNAT for Web Server in ${var.tenant_name} tenant"
  display_name              = "SNAT"
  action                    = "SNAT"
  enabled                   = true
  logging                   = true
  nat_pass                  = false
  translated_network        = "172.16.102.10"
  match_source_network      = "172.16.10.10"
   tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

resource "nsxt_nat_rule" "rule2" {
  logical_router_id         = "${nsxt_logical_tier1_router.tier1_router.id}"
  description               = "DNAT for Web Server in ${var.tenant_name} tenant"
  display_name              = "DNAT"
  action                    = "DNAT"
  enabled                   = true
  logging                   = true
  nat_pass                  = false
  translated_network        = "172.16.10.10"
  match_destination_network = "172.16.102.10"
   tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

