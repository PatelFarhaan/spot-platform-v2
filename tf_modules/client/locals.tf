// Resources that needs to be tagged
locals {
  resources = ["volume", "network-interface"]
}


// Filtered DNS List (non 80 and 443 records)
locals {
  filtered_dns_list = [
    for obj in var.routing : obj
    if  obj["servicePorts"]["external"] != 80 &&
    obj["servicePorts"]["external"] != 443
  ]
}


// Unique DNS List
locals {
  unique_dns_list = toset(flatten([for dns in var.routing : dns["dnsName"]]))
}


// Merging tags
locals {
  tags = merge(
    {
      "Application" = var.app
    },
    {
      "Environment" = var.env
    },
    var.tags
  )
}
