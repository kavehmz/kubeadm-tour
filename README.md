# kubeadm-tour

```
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=10.9.96.5
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml
```