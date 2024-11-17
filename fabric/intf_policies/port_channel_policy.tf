resource "aci_rest_managed" "lacpLagPol" {
  for_each = local.port_channel_policy_map
  dn         = "uni/infra/lacplagp-${each.value.name}"
  class_name = "lacpLagPol"
  content = {
    name     = each.value.name
    mode     = each.value.mode
  }
}