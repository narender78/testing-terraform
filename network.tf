# VCN
resource "oci_core_virtual_network" "testVCN" {
  cidr_block = var.VCN-CIDR
  dns_label = "testVCN"
  compartment_id = oci_identity_compartment.testCompartment.id
  display_name = "testVCN"
}

# DHCP Options
resource "oci_core_dhcp_options" "testDhcpOptions" {
  compartment_id = oci_identity_compartment.testCompartment.id
  vcn_id = oci_core_virtual_network.testVCN.id
  display_name = "testDhcpOptions"

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "testInternetGateway" {
  compartment_id = oci_identity_compartment.testCompartment.id
  vcn_id = oci_core_virtual_network.testVCN.id
  display_name = "testInternetGateway"
}

# Routing Tables
resource "oci_core_route_table" "testRouteTableViaIGW" {
  compartment_id = oci_identity_compartment.testCompartment.id
  vcn_id = oci_core_virtual_network.testVCN.id
  display_name = "testRouteTableViaIGW"
  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.testInternetGateway.id
  }
}

# Security List
resource "oci_core_security_list" "testSecurityList" {
  compartment_id = oci_identity_compartment.testCompartment.id
  vcn_id = oci_core_virtual_network.testVCN.id
  display_name = "testSecurityList"

  egress_security_rules {
    protocol = "6"
    destination = "0.0.0.0/0"
  }
 
  dynamic "ingress_security_rules" {
    for_each = var.service_ports
    content {
      protocol = "6"
      source = "0.0.0.0/0"
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  } 

  ingress_security_rules {
    protocol = "6"
    source = var.VCN-CIDR
  }
}

# Subnet
resource "oci_core_subnet" "testWebSubnet" {
  cidr_block = var.Subnet-CIDR
  display_name = "testWebSubnet"
  compartment_id = oci_identity_compartment.testCompartment.id
  vcn_id = oci_core_virtual_network.testVCN.id
  route_table_id = oci_core_route_table.testRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.testDhcpOptions.id
  security_list_ids = [oci_core_security_list.testSecurityList.id]
}
