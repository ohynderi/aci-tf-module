#
# Variables
#
variable "intf_pol_grp_cfg" {
    type = any
}

#
# Locals
#
locals {
    vpc_map = { for intf_pg in var.intf_pol_grp_cfg : intf_pg.name => intf_pg if intf_pg.type == "vpc" }
    po_map = { for intf_pg in var.intf_pol_grp_cfg : intf_pg.name => intf_pg if intf_pg.type == "pc" }
    access_map = { for intf_pg in var.intf_pol_grp_cfg : intf_pg.name => intf_pg if intf_pg.type == "access" }
}


#
# Output
#
output intf_pol_grp {
    value = {
        "access" = local.access_map
        "po" = local.po_map
        "vpc" = local.vpc_map
    }
}