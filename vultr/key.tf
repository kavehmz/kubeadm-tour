resource "tls_private_key" "vult_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "vult_ssh_key_pub" {
  content              = "${tls_private_key.vult_ssh_key.public_key_openssh}"
  filename             = "./ssh/vultr_id_rsa.pub"
  directory_permission = "0700"
  file_permission      = "0700"

}
resource "local_file" "vult_ssh_key" {
  content              = "${tls_private_key.vult_ssh_key.private_key_pem}"
  filename             = "./ssh/vultr_id_rsa"
  directory_permission = "0700"
  file_permission      = "0700"
}

resource "vultr_ssh_key" "setup_key" {
  name    = "setup"
  ssh_key = "${tls_private_key.vult_ssh_key.public_key_openssh}"
}
