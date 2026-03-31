#!/bin/bash
# validate-module2.sh
# Lives in showroom repo alongside Ansible playbooks.
# Copied to bastion by ansible.builtin.script and executed there.
# lab-user on bastion has system:admin via ~/.kube/config
set -euo pipefail

if oc get configmap app-config -n demo-project &>/dev/null; then
  echo "OK: ConfigMap app-config exists in demo-project"
  exit 0
else
  echo "ERROR: ConfigMap app-config not found in demo-project"
  echo ""
  echo "Create it:"
  echo "  oc create configmap app-config --from-literal=environment=production -n demo-project"
  exit 1
fi
