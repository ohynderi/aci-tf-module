resource "aci_rest_managed" "cdpIfPol" {
  for_each = local.cdp_policy_map
  dn         = "uni/infra/cdpIfP-${each.value.name}"
  class_name = "cdpIfPol"
  content = {
    name    = each.value.name
    adminSt = try(each.value.admin_state, false) == true ? "enabled" : "disabled"
  }
}