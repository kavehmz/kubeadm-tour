resource "local_file" "servers" {
  content = templatefile("servers.tmpl", {
    pupept  = vultr_server.puppet_master.main_ip
    masters = vultr_server.k8s_server.*.main_ip
    nodes   = vultr_server.k8s_nodes.*.main_ip
  })
  filename        = "./ssh/servers.sh"
  file_permission = "0750"
}
