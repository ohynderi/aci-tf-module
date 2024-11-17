#
# Variables
#
variable "fabric_cfg" {
    type = any
}

#
# Local
#
locals {
    node_list = try(var.fabric_cfg.nodes, [])
    intf_pol_list = try(var.fabric_cfg.interface_policies, [])
    intf_pol_grp_list = try(var.fabric_cfg.interface_policy_groups, [])
    node_policy_list = try(var.fabric_cfg.node, [])
}


#
# Main
#
module "nodes" {
    count = length(local.node_list) > 0 ? 1 : 0
    source = "./nodes"
    nodes_cfg = local.node_list
}

module "intf_policies" {
    count = length(local.intf_pol_list) > 0 ? 1 : 0
    source = "./intf_policies"
    intf_pol_cfg = local.intf_pol_list
}

module "intf_pol_grps" {
    count = length(local.intf_pol_grp_list) > 0 ? 1 : 0
    source = "./intf_pol_grps"
    intf_pol_grp_cfg = local.intf_pol_grp_list
}

module "vpc_group" {
    count = length(local.node_policy_list) > 0 ? 1 : 0
    source = "./node_policies"
    node_policy_cfg = local.node_policy_list
}