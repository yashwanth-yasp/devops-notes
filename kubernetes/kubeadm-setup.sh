#!/bin/bash
set -euo pipefail
 
# Set hostname to kmaster
sudo hostnamectl set-hostname kmaster
 
# Initialize Kubernetes cluster
sudo kubeadm init
 
# Configure kubectl for current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
# Check the status of nodes
kubectl get nodes
 
# Apply Weave Net CNI plugin
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
 
# Check taints on kmaster node
kubectl describe node kmaster | grep Taint
 
# Remove control-plane taint to allow scheduling pods on master
kubectl taint node kmaster node-role.kubernetes.io/control-plane:NoSchedule- || true