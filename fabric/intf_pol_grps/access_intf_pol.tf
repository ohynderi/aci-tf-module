resource "aci_rest_managed" "access_intf_pol_grps" {
  for_each   = local.access_map 
  dn         = "uni/infra/funcprof/accportgrp-${each.value.name}"
  class_name = "infraAccPortGrp"
  content = {
    name      = each.value.name
    descr     = try(each.value.description, "")
  }
}

resource "aci_rest_managed" "access_cdp_pol_rs_s" {
  for_each   = { for key, value in local.access_map: key => value if contains(keys(value), "cdp_policy") }
  dn         = "${aci_rest_managed.access_intf_pol_grps[each.key].dn}/rscdpIfPol"
  class_name = "infraRsCdpIfPol"
  content = {
    tnCdpIfPolName = each.value.cdp_policy
  }
}

resource "aci_rest_managed" "access_lldp_pol_rs_s" {
  for_each   = { for key, value in local.access_map: key => value if contains(keys(value), "lldp_policy") }
  dn         = "${aci_rest_managed.access_intf_pol_grps[each.key].dn}/rslldpIfPol"
  class_name = "infraRsLldpIfPol"
  content = {
    tnLldpIfPolName  = each.value.lldp_policy
  }
}

resource "aci_rest_managed" "access_stp_pol_rs_s" {
  for_each   = { for key, value in local.access_map: key => value if contains(keys(value), "stp_policy") }
  dn         = "${aci_rest_managed.access_intf_pol_grps[each.key].dn}/rsstpIfPol"
  class_name = "infraRsStpIfPol"
  content = {
    tnStpIfPolName  = each.value.lldp_policy
  }
}

resource "aci_rest_managed" "access_mcp_pol_rs_s" {
  for_each   = { for key, value in local.access_map: key => value if contains(keys(value), "mcp_policy") }
  dn         = "${aci_rest_managed.access_intf_pol_grps[each.key].dn}/rsmcpIfPol"
  class_name = "infraRsMcpIfPol"
  content = {
    tnMcpIfPolName   = each.value.mcp_policy
  }
}
