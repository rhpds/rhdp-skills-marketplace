# AgV Prerequisites for ZT Grading

## OCP Tenant Lab (config: namespace)

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/namespaced_workloads.git
    type: git
    version: "{{ tag }}"
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.6.4
  - name: https://github.com/rhpds/rhpds-ftl.git
    type: git
    version: "{{ tag }}"

workloads: >-
  {{
    [
      'agnosticd.namespaced_workloads.ocp4_workload_tenant_keycloak_user',
      'agnosticd.namespaced_workloads.ocp4_workload_tenant_namespace',
      'agnosticd.showroom.ocp4_workload_showroom',
      'rhpds.ftl.ocp4_workload_runtime_automation_k8s'   # ← REQUIRED
    ]
  }}

# Namespace suffixes — student gets devuser-{guid}-{suffix} namespaces
ocp4_workload_tenant_keycloak_username: "devuser-{{ guid }}"
ocp4_workload_tenant_namespace_username: "devuser-{{ guid }}"
ocp4_workload_tenant_namespace_suffixes:
- suffix: zttest       # → student_ns  = devuser-{guid}-zttest
- suffix: ztworkspace  # → student_ns2 = devuser-{guid}-ztworkspace

# Showroom — zerotouch chart required
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/my-lab-showroom.git
ocp4_workload_showroom_content_git_repo_ref: main
ocp4_workload_showroom_deployer_chart_name: zerotouch
ocp4_workload_showroom_deployer_chart_version: "1.9.18"
ocp4_workload_showroom_runtime_automation_image: "quay.io/rhpds/zt-runner:v2.3.0"
ocp4_workload_showroom_zero_touch_ui_enabled: true
ocp4_workload_showroom_terminal_type: ""
```

## OCP Dedicated Lab (config: openshift-workloads)

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.6.4
  - name: https://github.com/rhpds/rhpds-ftl.git
    type: git
    version: "{{ tag }}"

workloads:
- agnosticd.core_workloads.ocp4_workload_authentication   # creates developer user
- agnosticd.showroom.ocp4_workload_ocp_console_embed
- agnosticd.showroom.ocp4_workload_showroom
- rhpds.ftl.ocp4_workload_runtime_automation_k8s          # ← REQUIRED

# Dedicated cluster mode — SA gets cluster-admin
ocp4_workload_runtime_automation_k8s_cluster_admin: true
ocp4_workload_runtime_automation_k8s_openshift_api_url: "{{ openshift_api_url }}"
ocp4_workload_runtime_automation_k8s_openshift_api_token: "{{ openshift_cluster_admin_token }}"

# Developer user (common password so {openshift_cluster_admin_password} works for both)
common_password: >-
  {{ lookup('password', output_dir ~ '/common_password', length=12, chars=['ascii_letters', 'digits']) }}
ocp4_workload_authentication_admin_password: "{{ common_password }}"
ocp4_workload_authentication_cluster_accounts:
- name: developer
ocp4_workload_authentication_cluster_account_password: "{{ common_password }}"
ocp4_workload_authentication_cluster_account_password_randomized: false

# Showroom — wetty terminal for bastion access
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/my-lab-showroom.git
ocp4_workload_showroom_content_git_repo_ref: main
ocp4_workload_showroom_terminal_type: wetty
ocp4_workload_showroom_wetty_ssh_bastion_login: true
ocp4_workload_showroom_deployer_chart_name: zerotouch
ocp4_workload_showroom_deployer_chart_version: "1.9.18"
ocp4_workload_showroom_runtime_automation_image: "quay.io/rhpds/zt-runner:v2.3.0"
ocp4_workload_showroom_zero_touch_ui_enabled: true

# Component propagation — bastion SSH port required for runner
components:
- name: openshift
  propagate_provision_data:
  - {name: bastion_ssh_port, var: bastion_ansible_port}
  - {name: bastion_public_hostname, var: bastion_ansible_host}
  - {name: bastion_ssh_user_name, var: bastion_ansible_user}
  - {name: bastion_ssh_password, var: bastion_ansible_ssh_pass}
  - {name: openshift_cluster_admin_token, var: openshift_cluster_admin_token}
  - {name: openshift_api_url, var: openshift_api_url}
```

## RHEL VM + Bastion (config: cloud-vms-base)

```yaml
requirements_content:
  collections:
    - name: https://github.com/agnosticd/core_workloads.git
      type: git
      version: "{{ tag }}"
    - name: https://github.com/agnosticd/cloud_vm_workloads.git
      type: git
      version: "{{ tag }}"
    - name: https://github.com/agnosticd/showroom.git
      type: git
      version: v1.6.4   # must be >= v1.6.4 (traefik fix merged in PR #53)
    - name: https://github.com/rhpds/rhpds-ftl.git
      type: git
      version: "{{ tag }}"

# Instances — AnsibleGroup tags drive node discovery
instances:
  - name: bastion
    tags:
      - key: AnsibleGroup
        value: "bastions,showroom"
  - name: node      # add node01, node02 etc. for multi-node labs
    tags:
      - key: AnsibleGroup
        value: nodes

post_software_final_workloads:
  bastions:
    - agnosticd.showroom.vm_workload_showroom
    - rhpds.ftl.vm_workload_runtime_automation   # ← REQUIRED

# Showroom
showroom_git_repo: https://github.com/rhpds/my-lab-showroom.git
showroom_git_ref: main
showroom_ansible_runner_api: true
showroom_ansible_runner_image: quay.io/rhpds/zt-runner
showroom_ansible_runner_image_tag: v2.3.0
```

## What Each Role Does

| Role | What it provisions |
|---|---|
| `ocp4_workload_runtime_automation_k8s` | Creates `zt-runner` SA + kubeconfig Secret in showroom namespace. Multi-user: namespace RoleBindings. Dedicated: ClusterRoleBinding. |
| `vm_workload_runtime_automation` | Copies `{guid}key.pem` to `/opt/showroom/.ssh/id_rsa`. Writes SSH config with all node + bastion Host entries. Mounted at `/app/.ssh/` in runner container. |

## Extravars Injected by jobs.py

These are available in ALL playbooks automatically:

**OCP labs:**
- `student_user` — keycloak username (e.g. `devuser-{guid}`)
- `student_ns` — `{user}-zttest`
- `student_ns2` — `{user}-ztworkspace`
- `guid`
- `k8s_kubeconfig` — path to kubeconfig file written from Secret
- `bastion_host`, `bastion_port`, `bastion_password` — if bastion data in showroom-userdata CM

**RHEL labs (env var fallback):**
- `student_user` — lab-user
- `bastion_host`, `bastion_port`, `bastion_password`, `bastion_user`
