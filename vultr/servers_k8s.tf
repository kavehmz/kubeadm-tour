
resource "vultr_server" "k8s_server" {
  count                  = 1
  region_id              = "9"
  plan_id                = "203"
  os_id                  = "352"
  label                  = "kubeserver"
  hostname               = "kubeserver"
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
    source      = "provision/puppet_agent.sh"
    destination = "/tmp/puppet_agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/puppet_agent.sh",
      "/tmp/puppet_agent.sh ${self.internal_ip} ${vultr_server.puppet_master.internal_ip} kubeserver",
    ]
  }
}

output "kube_master_ip_addr" {
  value = "${vultr_server.k8s_server.*.main_ip}"
}

resource "vultr_server" "k8s_nodes" {
  count                  = 1
  region_id              = "9"
  plan_id                = "203"
  os_id                  = "352"
  label                  = "kubenode-${count.index + 1}"
  hostname               = "kubenode-${count.index + 1}"
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
    source      = "provision/puppet_agent.sh"
    destination = "/tmp/puppet_agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/puppet_agent.sh",
      "/tmp/puppet_agent.sh ${self.internal_ip} ${vultr_server.puppet_master.internal_ip} kubenode-${count.index + 1}",
    ]
  }
}


output "kube_nodes_ip_addr" {
  value = "${vultr_server.k8s_nodes.*.main_ip}"
}
