#
# Variables
#
variable "name" {
    type = string
}

variable "id" {
    type = number
}

variable "sn" {
    type = string
}

variable "interfaces" {
    type = list(any)
}


# variable "model" {
#     type = object({
#         name = string
#         type = string
#         id = number
#         sn = string
#         interfaces = optional(list(object({
#             card_id = number
#             port_id = number
#             intf_pol_grp = string
#         })))
#     })
# }

#
# Locals
#

locals {
    leaf_prof_name = "${var.id}_LeafProf"
    leaf_sel_name = "${var.id}_LeafSel"
    leaf_node_block_name = "${var.id}_Bck"
    leaf_intf_prof_name  = "${var.id}_LeafInfProf"

    interface_map = { for intf in var.interfaces: "${intf.card}/${intf.port}" => intf }
}


#
# Main
#

# Fabric Inventory
resource "aci_fabric_node_member" "tf-leaf" {
    name            = var.name
    serial          = var.sn
    node_id         = var.id
    pod_id          = var.id < 1000 ? 1 : 2
    role            = "leaf"
}


#
# Leaf Interface Profile
#
resource "aci_leaf_interface_profile" "tf-leaf-intf-profile" {
    name        = local.leaf_intf_prof_name
}


#
# Leaf Profile
#
resource "aci_leaf_profile" "tf-leaf-profile" {
    name                          = local.leaf_prof_name
    relation_infra_rs_acc_port_p  = [ aci_leaf_interface_profile.tf-leaf-intf-profile.id ]
    leaf_selector {
        name                      = local.leaf_sel_name
        switch_association_type   = "range"
        node_block {
            name                  = local.leaf_node_block_name
            from_                 = tostring(var.id)
            to_                   = tostring(var.id)
        }
    }
}


#
# Leaf interface selector
#

resource "aci_access_port_selector" "tf_acc_port_sel_list" {
    for_each                  = local.interface_map
    leaf_interface_profile_dn = aci_leaf_interface_profile.tf-leaf-intf-profile.id
    name                      = "Eth1-${each.value.port}"
    access_port_selector_type = "range"
}

resource "aci_access_port_block" "tf_acc_port_block_list" {
  for_each                          = local.interface_map
  access_port_selector_dn           = aci_access_port_selector.tf_acc_port_sel_list[each.key].id
  name                              = each.value.intf_pol_group
  from_card                         = each.value.card
  to_card                           = each.value.card
  from_port                         = each.value.port
  to_port                           = each.value.port
}



#
# Ouptuts
#
output "node_member" {
    value = aci_fabric_node_member.tf-leaf
}

output "interface_profile" {
    value = aci_leaf_interface_profile.tf-leaf-intf-profile
}

output "leaf_profile" {
    value = aci_leaf_profile.tf-leaf-profile
}
