resource "oci_identity_compartment" "testCompartment" {
  name = "testCompartment"
  description = "Compartment for testing"
  compartment_id = var.compartment_ocid
  
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
