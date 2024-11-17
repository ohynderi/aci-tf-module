#
# Variables
#
variable "intf_pol_cfg" {
    type = any
}

#
# Locals
#
locals {
    cdp_policy_map = { for pol in try(var.intf_pol_cfg.cdp_policies, []) : pol.name => pol}
    lldp_policy_map = { for pol in try(var.intf_pol_cfg.lldp_policies, []) : pol.name => pol}
    link_level_policy_map = { for pol in try(var.intf_pol_cfg.link_level_policies, []) : pol.name => pol}
    port_channel_policy_map = { for pol in try(var.intf_pol_cfg.port_channel_policies, []) : pol.name => pol}
    spanning_tree_policy_map = { for pol in try(var.intf_pol_cfg.spanning_tree_policies, []) : pol.name => pol}
    mcp_policy_map = { for pol in try(var.intf_pol_cfg.mcp_policies, []) : pol.name => pol }
}


#
# Outputs
#

output link_layer_policies {
    value = {
        "cdp" = local.mcp_policy_map
        "lldp" = local.lldp_policy_map
        "port_channel" = local.port_channel_policy_map
        "spanning_tree" = local.spanning_tree_policy_map
        "mcp" = local.mcp_policy_map
    }
}
