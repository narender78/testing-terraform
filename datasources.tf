# ADs Datasource
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.compartment_ocid
}

# Images Datasource
data "oci_core_images" "OSImage" {
  compartment_id = var.compartment_ocid
  operating_system = var.instance_os
  operating_system_version = var.linux_os_version
  shape = var.Shape

  filter {
    name = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex = true
  }
}

# Compute VNIC Attachment DataSource
data "oci_core_vnic_attachments" "testWebserver_VNIC1_attach" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
  compartment_id      = oci_identity_compartment.testCompartment.id
  instance_id         = oci_core_instance.testWebserver.id
}

# Compute VNIC DataSource
data "oci_core_vnic" "testWebserver_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.testWebserver_VNIC1_attach.vnic_attachments.0.vnic_id
}
