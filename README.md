# kubeadm-tour

This is just my experience for creating a kubernetes cluster in Vultr using kubeadm, Terraform and Puppet.

You need to have your api token from Vultr.

```bash
cd vultr
terraform apply
sleep $(( 2 * 4 * 8 * 16 ))
# now source list of servers and login
. ssh/servers.sh;ssh -i ssh/vultr_id_rsa $KUBE_NODE_0
```
