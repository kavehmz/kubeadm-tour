resource "vultr_server" "puppet_master" {
  region_id              = "9"
  plan_id                = "202"
  os_id                  = "352"
  label                  = "puppet_master"
  hostname               = "puppet_master"
  ssh_key_ids            = ["${vultr_ssh_key.setup_key.id}"]
  notify_activate        = false
  enable_private_network = true

  connection {
    type        = "ssh"
    user        = "root"
    private_key = "${tls_private_key.vult_ssh_key.private_key_pem}"
    host        = "${self.main_ip}"
  }
  provisioner "file" {
    source      = "provision/puppet_server.sh"
    destination = "/tmp/puppet_server.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/puppet_server.sh",
      "/tmp/puppet_server.sh ${self.internal_ip}",
    ]
  }
}

output "puppet_master_ip_addr" {
  value = "${vultr_server.puppet_master.main_ip}"
}
output "puppet_master_priv_addr" {
  value = "${vultr_server.puppet_master.internal_ip}"
}
