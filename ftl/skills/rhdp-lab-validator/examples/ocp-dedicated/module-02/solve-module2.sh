#!/bin/bash
# solve-module2.sh
# Lives in showroom repo alongside Ansible playbooks.
# Copied to bastion by ansible.builtin.script and executed there.
# lab-user on bastion has system:admin via ~/.kube/config
set -euo pipefail

oc create configmap app-config \
  --from-literal=environment=production \
  --from-literal=app=my-app \
  -n demo-project \
  --dry-run=client -o yaml | oc apply -f -

echo "OK: app-config ConfigMap created in demo-project"
