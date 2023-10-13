// Resources that needs to be tagged
locals {
  resources = ["volume", "network-interface"]
}


// Filtered DNS List (non 80 and 443 records)
locals {
  filtered_dns_list = [
    for obj in var.routing : obj
    if  obj["external_port"] != 80 &&
    obj["external_port"] != 443
  ]
}


// Unique DNS List
locals {
  unique_dns_list = toset(flatten([for dns in var.routing : dns["dns"]]))
}
