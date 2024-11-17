resource "aci_rest_managed" "po_intf_pol_grps" {
  for_each   = local.po_map 
  dn         = "uni/infra/funcprof/accbundle-${each.value.name}"
  class_name = "infraAccBndlGrp"
  content = {
    name      = each.value.name
    descr     = try(each.value.description, "")
    lagT      =  "link"
  }
}

resource "aci_rest_managed" "po_cdp_pol_rs_s" {
  for_each   = { for key, value in local.po_map: key => value if contains(keys(value), "cdp_policy") }
  dn         = "${aci_rest_managed.po_intf_pol_grps[each.key].dn}/rscdpIfPol"
  class_name = "infraRsCdpIfPol"
  content = {
    tnCdpIfPolName = each.value.cdp_policy
  }
}

resource "aci_rest_managed" "po_lldp_pol_rs_s" {
  for_each   = { for key, value in local.po_map: key => value if contains(keys(value), "lldp_policy") }
  dn         = "${aci_rest_managed.po_intf_pol_grps[each.key].dn}/rslldpIfPol"
  class_name = "infraRsLldpIfPol"
  content = {
    tnLldpIfPolName  = each.value.lldp_policy
  }
}

resource "aci_rest_managed" "po_stp_pol_rs_s" {
  for_each   = { for key, value in local.po_map: key => value if contains(keys(value), "stp_policy") }
  dn         = "${aci_rest_managed.po_intf_pol_grps[each.key].dn}/rsstpIfPol"
  class_name = "infraRsStpIfPol"
  content = {
    tnStpIfPolName  = each.value.lldp_policy
  }
}

resource "aci_rest_managed" "po_mcp_pol_rs_s" {
  for_each   = { for key, value in local.po_map: key => value if contains(keys(value), "mcp_policy") }
  dn         = "${aci_rest_managed.po_intf_pol_grps[each.key].dn}/rsmcpIfPol"
  class_name = "infraRsMcpIfPol"
  content = {
    tnMcpIfPolName   = each.value.mcp_policy
  }
}
