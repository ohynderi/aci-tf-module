#
# Variables
# 
# variable "model" {
#     type = list(object({
#         name = string
#         type = string
#         id = number
#         sn = string
#         interfaces = optional(list(object({
#             card_id = number
#             port_id = number
#             intf_pol_grp = string
#             })))
#     }))
# }


variable "nodes_cfg" {
    type = any
}

#
# Locals
#
locals {
    leaf_map = { for node in var.nodes_cfg : node.name => node if node.type == "leaf" }
    spine_map = { for node in var.nodes_cfg : node.name => node if node.type == "spine" }
}

#
# Main
#
module "leafs" {
    for_each = local.leaf_map
    source = "./leaf"
    name = each.value.name
    id = each.value.id
    sn = each.value.sn
    interfaces = each.value.interfaces
}

#
#
#
