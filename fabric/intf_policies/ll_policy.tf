resource "aci_rest_managed" "fabricHIfPol" {
  for_each = local.link_level_policy_map
  dn         = "uni/infra/hintfpol-${each.value.name}"
  class_name = "fabricHIfPol"
  content = {
    name             = each.value.name
    speed            = try(each.value.speed, "inherit")
    autoNeg          = try(each.value.auto, true) == true ? "on" : "off"
    fecMode          = try(each.value.fec_mode, "inherit")
    portPhyMediaType = try(each.value.physical_media_type, null) != null ? each.value.physical_media_type : null
  }
}