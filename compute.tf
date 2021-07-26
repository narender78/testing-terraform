# Webserver Compute

resource "oci_core_instance" "testWebserver" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0].name
  compartment_id = oci_identity_compartment.testCompartment.id
  display_name = "testWebserver"
  shape = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus = var.FlexShapeOCUPS
    }
  }

  source_details {
    source_type = "image"
    source_id = lookup(data.oci_core_images.OSImage.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.testWebSubnet.id
    assign_public_ip = true
  }
  
}
