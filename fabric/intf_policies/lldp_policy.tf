resource "aci_rest_managed" "lldpIfPol" {
  for_each = local.lldp_policy_map
  dn         = "uni/infra/lldpIfP-${each.value.name}"
  class_name = "lldpIfPol"
  content = {
    name      = each.value.name
    adminRxSt = try(each.value.admin_rx_state, false) == true ? "enabled" : "disabled"
    adminTxSt = try(each.value.admin_tx_state, false) == true ? "enabled" : "disabled"
  }
}