# OCP Catalog Questions

**Loaded by**: `agnosticv:catalog-builder` after Step 3 infra gate selects OpenShift cluster.

Covers Steps 3B–8 for `config: openshift-workloads` catalogs (CNV multi-node, SNO, AWS OCP).

After this file completes, return to `SKILL.md` for Step 7 (Catalog Details) onward.

---

## Step 3 (continued): OCP Infrastructure Questions

Ask sequentially — ONE question at a time.

**Question B — Cluster size** *(always ask — reference sizing may differ)*:

```
Q: SNO or Multi-node?

1. Multi-node  (default — workshops, most demos)
2. SNO         (lightweight single-user demos, edge content)

Choice [1/2]:
```

*If SNO selected → force `multiuser: false`, skip Step 8 user count question.*

**Question C — OCP version:**

```
Q: Which OpenShift version?

1. 4.18
2. 4.20
3. 4.21 (latest)

Choice [1/2/3]:
```

**Question D — Custom pool:**

```
Q: Do you have a custom CNV pool allocated? [Y/n]

Default: agd-v2/ocp-cluster-cnv-pools/prod
```

**Question E — Auto-scale:** *(multi-node only)*

```
Q: Auto-scale workers based on num_users? [Y/n]
```

**Question F — AWS instead of CNV:** *(optional)*

```
Q: Do you need AWS instead of CNV? [Y/n]

AWS is only needed for GPU workloads or specific AWS-feature demos.
```

→ If YES: `Q: Do you have RHDP team approval for AWS? [Y/n]`
*(No approval → stop)*

---

### Generated config — CNV Multi-node

```yaml
config: openshift-workloads
cloud_provider: none

__meta__:
  components:
  - name: openshift
    display_name: OpenShift Cluster
    item: agd-v2/ocp-cluster-cnv-pools/prod   # or custom pool
    parameter_values:
      cluster_size: multinode                  # or sno
      host_ocp4_installer_version: "4.21"      # from Question C
      ocp4_fips_enable: false
      num_users: "{{ num_users }}"
    propagate_provision_data:
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
```

*If auto-scale:* add `openshift_cnv_scale_cluster: true` and worker formula (see Step 8).

### Generated config — AWS OCP

```yaml
config: openshift-cluster
cloud_provider: aws
cloud_provider_version: "{{ tag }}"

__meta__:
  components:
  - name: openshift
    display_name: OpenShift Cluster (AWS)
    item: agd-v2/ocp-cluster-aws-pools/prod
    parameter_values:
      cluster_size: default
      host_ocp4_installer_version: "4.21"
      num_users: "{{ num_users }}"
    propagate_provision_data:
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
```

*AWS extra includes (add to top of common.yaml):*

```
#include /includes/aws-sandbox-meta.yaml
#include /includes/parameters/aws-regions-standard.yaml
#include /includes/secrets/letsencrypt_with_zerossl_fallback.yaml
```

---

## Step 4: Authentication Setup

Single unified workload for all OCP authentication. Ask ONE question:

```
🔐 Authentication Provider

Which authentication provider?

1. htpasswd  (simple username/password — default, most common)
2. Keycloak  (RHBK — Red Hat Build of Keycloak, for multi-user workshops, AAP)

Note: RHSSO is not supported. Use Keycloak (RHBK) for SSO needs.

Q: Provider [1/2]:
```

**Workload is always the same — only the provider var changes:**

```yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication
```

**htpasswd config:**

```yaml
ocp4_workload_authentication_provider: htpasswd
ocp4_workload_authentication_admin_username: admin
ocp4_workload_authentication_admin_password: ""
ocp4_workload_authentication_num_users: "{{ num_users | default(0) }}"
ocp4_workload_authentication_user_password: ""
ocp4_workload_authentication_remove_kubeadmin: true
```

**Keycloak (RHBK) config:**

```yaml
ocp4_workload_authentication_provider: keycloak
ocp4_workload_authentication_admin_username: admin
ocp4_workload_authentication_admin_password: ""
ocp4_workload_authentication_num_users: "{{ num_users | default(0) }}"
ocp4_workload_authentication_user_password: ""
ocp4_workload_authentication_remove_kubeadmin: true
ocp4_workload_authentication_keycloak_channel: stable-v26.2
```

---

## Step 5: Workload Selection

Using the technologies from Step 1, recommend workloads silently. Present recommendations and confirm.

**Workload recommendation engine:**

Based on technologies already provided:

- `ansible` or `aap` → `rhpds.aap25.ocp4_workload_aap25`
- `ai` or `gpu` → `rhpds.nvidia_gpu.ocp4_workload_nvidia_gpu`
- `gitops` or `argocd` → `rhpds.openshift_gitops.ocp4_workload_openshift_gitops`
- `pipelines` → `rhpds.openshift_pipelines.ocp4_workload_openshift_pipelines`
- `showroom` → both workloads always together (see Step 6)

**Present recommendations:**

```
Recommended workloads:

✓ agnosticd.core_workloads.ocp4_workload_authentication (selected - auth)
✓ agnosticd.showroom.ocp4_workload_ocp_console_embed (recommended - console embedding)
✓ agnosticd.showroom.ocp4_workload_showroom (recommended - guide)
  agnosticd.aap25.ocp4_workload_aap25 (suggested - ansible)
  agnosticd.openshift_gitops.ocp4_workload_openshift_gitops (suggested - gitops)

Select workloads (comma-separated numbers, or 'all'):
```

**LiteMaaS question (ask after workload selection):**

```
Q: Will this catalog use LiteMaaS for AI model inference? [Y/n]

LiteMaaS provides hosted AI models (granite, mistral, qwen, llama, etc.)
via a shared inference platform.
```

**If YES — ask two more questions:**

```
Q: Which models should be available? (comma-separated)

Current models on LiteMaaS:
  codellama-7b-instruct
  deepseek-r1-distill-qwen-14b
  granite-3-2-8b-instruct
  granite-4-0-h-tiny
  llama-guard-3-1b
  llama-scout-17b
  microsoft-phi-4
  nomic-embed-text-v1-5
  qwen3-14b

Models:

Q: Virtual key duration?
Default: 7d  Examples: 1d, 7d, 30d, 90d

Duration [default: 7d]:
```

**Generate for common.yaml:**

```yaml
ocp4_workload_litellm_virtual_keys_duration: "7d"
ocp4_workload_litellm_virtual_keys_models:
- qwen3-14b
- granite-3-2-8b-instruct
ocp4_workload_litellm_virtual_keys_multi_user: "{{ multiuser | default(false) }}"
ocp4_workload_litellm_virtual_keys_verify_ssl: true
```

**Add to workloads:**

```yaml
- rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys
```

**Add to requirements_content:**

```yaml
- name: https://github.com/rhpds/rhpds.litellm_virtual_keys.git
  type: git
  version: "{{ tag }}"
```

**Add includes:**

```
#include /includes/secrets/litemaas-master_api.yaml
#include /includes/parameters/litellm_metadata.yaml
```

---

## Step 5.5: Collection Versions *(auto — no question)*

Use the `{{ tag }}` pattern — one variable controls all standard collection versions.

```yaml
tag: main
```

All standard collections use `"{{ tag }}"` as version. Showroom uses a fixed pinned version — NOT `{{ tag }}`.

Silently grep AgV repo for the highest pinned showroom version in use:

```bash
grep -r "agnosticd/showroom" "$AGV_PATH" --include="*.yaml" -h \
  | grep "version:" | grep -v "tag" | sort -V | tail -1
```

Use that version, or `v1.5.3` as minimum if nothing higher found.

**EE image:** Grep AgV for most recent `ee-multicloud` chained image in use and write to `__meta__.deployer.execution_environment.image`.

---

## Step 6: Showroom Configuration

Both OCP showroom workloads must always be added together. `ocp4_workload_ocp_console_embed` is required to embed the OCP console and other UIs in the Showroom split view.

**Ask for the Showroom repo:**

```
📚 Showroom repository

Based on naming convention, your Showroom repo should be:
  https://github.com/rhpds/<short-name>-showroom

Has this repository been created yet? [Y/n]
```

**If YES:** Ask for URL or local path. Check for Showroom 1.5.3 structure (`default-site.yml`, `supplemental-ui/` at root, `ui-config.yml`). Pre-1.5.3 → block with migration instructions.

**If NO:** Add placeholder and continue without blocking.

**Generate Showroom section for common.yaml:**

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.3   # fixed — minimum v1.5.3

workloads:
- agnosticd.showroom.ocp4_workload_ocp_console_embed
- agnosticd.showroom.ocp4_workload_showroom

ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/<short-name>-showroom
ocp4_workload_showroom_content_git_repo_ref: main
ocp4_workload_showroom_antora_enable_dev_mode: "false"
```

**dev.yaml Showroom override:**

```yaml
ocp4_workload_showroom_antora_enable_dev_mode: "true"
```

---

*(Step 7: Catalog Details is in SKILL.md — it runs after you return from this file.)*

## Step 8: Multi-User Configuration

**SNO forces single-user:** If SNO was selected in Step 3B → set `multiuser: false`, skip num_users question entirely.

**Auto-set based on category:**

| Category | multiuser |
|---|---|
| Workshops / Brand_Events | true |
| Demos | false |
| Sandboxes | false |

**If multi-user (Workshops/Brand_Events):**

```
Q: How many concurrent users (maximum)?
   Typical range: 10-60
   Default: 30

Max users [default: 30]:
```

**Set in common.yaml:**

```yaml
__meta__:
  catalog:
    multiuser: true
    workshopLabUiRedirect: true
    parameters:
      - name: num_users
        description: Number of users to provision within the environment
        formLabel: User Count
        openAPIV3Schema:
          type: integer
          default: 3
          minimum: 3
          maximum: 60
```

**Worker scaling formula (if auto-scale enabled in Step 3E):**

```yaml
openshift_cnv_scale_cluster: "{{ (num_users | int) > 3 }}"
worker_instance_count: "{{ [(num_users | int / 5) | round(0, 'ceil') | int, 1] | max if (num_users | int) > 3 else 0 }}"
```

**If single-user (Demos / SNO):**

```yaml
__meta__:
  catalog:
    multiuser: false
```

No `workshopLabUiRedirect` for demos.

---

**↩ Return to `SKILL.md` — continue from Step 7: Catalog Details.**
