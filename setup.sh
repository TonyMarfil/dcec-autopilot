#!/bin/bash
terraform init
terraform fmt
terraform validate
terraform plan
# apply
if [ "$1" != "non-interactive" ] ; then
  read -p "Press enter to continue"
  terraform apply --auto-approve
else
  terraform apply --auto-approve
fi
#export KUBECONFIG=$KUBECONFIG:$(echo -n "$(cat ./cluster-config)")
mkdir -p ~/.kube/
\cp ./cluster-config ~/.kube/cluster-config
export KUBECONFIG=$KUBECONFIG:~/.kube/cluster-config
