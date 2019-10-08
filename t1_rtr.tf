# Create T1 router
resource "nsxt_logical_tier1_router" "tier1_router" {
  description                 = "Tier1 router provisioned by Terraform"
  display_name                = "t1-terraform-${var.tenant_name}"
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = "${data.nsxt_edge_cluster.edge_cluster.id}"
  enable_router_advertisement = true
  advertise_nat_routes        = true
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

# Create a port on the T0 router. We will connect the T1 router to this port
resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  description       = "Provisioned by Terraform"
  display_name      = "t1-terraform-${var.tenant_name}"
  logical_router_id = "${data.nsxt_logical_tier0_router.tier0_router.id}"
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

# Create a T1 uplink port and connect it to T0 router
resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  description                   = "Provisioned by Terraform"
  display_name                  = "T0_PORT"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.link_port_tier0.id}"
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

# Create a switchport on the web logical switch
resource "nsxt_logical_port" "web_logical_port" {
  admin_state       = "UP"
  description       = "Provisioned by Terraform"
  display_name      = "t1-terraform-${var.tenant_name}"
  logical_switch_id = "${nsxt_logical_switch.web.id}"
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

# Create downlink port on the T1 router and connect it to the switchport we created earlier on the web logical switch
resource "nsxt_logical_router_downlink_port" "web" {
  description                   = "Provisioned by Terraform"
  display_name                  = "Web"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.web_logical_port.id}"
  ip_address                    = "${var.web_ip}"
  tag {
        scope = "tenant"
        tag = "${var.tenant_name}"
    }
  tag {
        scope = "CreatedBy"
        tag = "Terraform"
    }
}

