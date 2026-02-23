# Cloud VMs Base Catalog Questions

**Loaded by**: `agnosticv:catalog-builder` after Step 3 infra gate selects RHEL / AAP VMs.

Covers Steps 3B–8 for `config: cloud-vms-base` catalogs (RHEL VMs on CNV or AWS).

After this file completes, return to `SKILL.md` for Step 7 (Catalog Details) onward.

---

## Step 3 (continued): VM Infrastructure Questions

Ask sequentially — ONE question at a time.

**Question B — Cloud provider** *(always ask — reference may differ)*:

```
Q: CNV or AWS? Default is CNV.

1. CNV  (default — OpenShift Virtualization)
2. AWS  (requires prior RHDP team approval)

Choice [1/2]:
```

→ If AWS: `Q: Do you have RHDP team approval? [Y/n]` *(No approval → stop)*

**Question C — RHEL image:**

```
Q: Which RHEL image?

1. rhel-9.6          (default)
2. RHEL-10-GOLD-latest

Choice [1/2]:
```

**Question D — Sizing override:**

```
Q: Use default sizing or override? [default/override]

Default: 8 cores, 16Gi memory, 200Gi disk
(Only override if you need different resources)
```

→ If override: ask cores, memory, image_size per VM.

**Question E — Ports to expose on bastion:**

```
Q: Which ports need to be exposed on the bastion?

Common: 22 (SSH), 80 (HTTP), 443 (HTTPS)
Add custom ports if needed (e.g., 5000 for registry, 8080 for app)

Enter ports (comma-separated, e.g.: 22,80,443):
```

→ If additional VMs beyond bastion: ask same port question per VM.

---

### Generated config — CNV

```yaml
config: cloud-vms-base
cloud_provider: openshift_cnv

bastion_instance_image: rhel-9.6   # from Question C

instances:
  - name: bastion
    count: 1
    unique: true
    image: "{{ bastion_instance_image }}"
    cores: 8
    memory: 16G
    image_size: 200Gi
    tags:
      - key: AnsibleGroup
        value: bastions
      - key: ostype
        value: linux
    services:
      - name: bastion
        ports:
          - port: 22
            protocol: TCP
            targetPort: 22
            name: bastion-ssh
          - port: 443
            protocol: TCP
            targetPort: 443
            name: bastion-https
    routes:
      - name: bastion-https
        host: bastion
        service: bastion
        targetPort: 443
```

### Generated config — AWS VMs

Use `security_groups:` instead of `services:`/`routes:`:

```yaml
config: cloud-vms-base
cloud_provider: aws

bastion_instance_image: rhel-9.6

instances:
  - name: bastion
    count: 1
    unique: true
    image: "{{ bastion_instance_image }}"
    cores: 8
    memory: 16G
    image_size: 200Gi
    tags:
      - key: AnsibleGroup
        value: bastions
      - key: ostype
        value: linux
    security_groups:
    - name: BastionSG
      rules:
      - name: BastionSSH
        from_port: 22
        to_port: 22
        protocol: tcp
        cidr: "0.0.0.0/0"
        rule_type: Ingress
      - name: BastionHTTPS
        from_port: 443
        to_port: 443
        protocol: tcp
        cidr: "0.0.0.0/0"
        rule_type: Ingress
```

---

## Step 4: Authentication

⚠️ **cloud-vms-base does NOT use `ocp4_workload_authentication`** — there is no OCP cluster.

Authentication for VM-based catalogs is handled at the OS/bastion level by AgnosticD base config:
- SSH key injection for bastion access
- OS user accounts set up by the base role
- Application-level auth configured by your workload roles

**Skip this step entirely.** Do not ask about authentication provider. Do not add any `ocp4_workload_authentication*` workload to the list.

---

## Step 5: Workload Selection

VM-based catalogs use Ansible roles that run on the VMs rather than OCP operators.
The `workloads:` list may be empty or contain custom VM-targeted roles.

**Do NOT recommend or add:**

- `ocp4_workload_authentication` — no OCP cluster
- `ocp4_workload_ocp_console_embed` — no OCP console
- `ocp4_workload_litellm_virtual_keys` — OCP workload, not available on VMs
- Any `ocp4_workload_*` role unless the catalog explicitly deploys OCP inside the VMs

**Ask:**

```
Q: Does this catalog run any post-provisioning automation on the VMs?
   (e.g., install AAP, configure RHEL, deploy an application)

1. Yes — I have custom Ansible roles or a collection
2. No — base RHEL VM provisioning is enough

Choice [1/2]:
```

**If YES:**

```
Q: What collection and workload name?
   Format: namespace.collection.role_name
   Example: rhpds.my_catalog.setup_aap

Workload:

Q: Is this collection in a GitHub repo? [Y/n]
   If yes, provide the URL:
```

Add to workloads and requirements_content accordingly.

**If NO:** Leave `workloads:` empty or omit the key.

---

## Step 5.5: Collection Versions *(auto — no question)*

Same `{{ tag }}` pattern as OCP catalogs.

```yaml
tag: main
```

Standard collections use `"{{ tag }}"`. If showroom is included (see Step 6), silently grep AgV repo for the highest pinned showroom version in use:

```bash
grep -r "agnosticd/showroom" "$AGV_PATH" --include="*.yaml" -h \
  | grep "version:" | grep -v "tag" | sort -V | tail -1
```

Use that version, or `v1.5.1` as minimum if nothing higher found.

**EE image:** Grep AgV for most recent `ee-multicloud` chained image in use and write to `__meta__.deployer.execution_environment.image` — same as OCP catalogs.

---

## Step 6: Showroom Configuration

cloud-vms-base uses bastion-side showroom (`vm_workload_showroom`). It uses the same **nookbag** frontend as OCP showroom — split view, view_switcher, and tab embedding all work identically. The difference is what you embed: instead of the OCP console, you embed bastion terminals, AAP dashboards, RHEL consoles, or any HTTPS URL.

⚠️ **Do NOT add** `ocp4_workload_ocp_console_embed` — it requires an OCP cluster.
⚠️ **Requires Showroom 1.5.1+** for split view and view_switcher.

**Ask sequentially:**

**Question A — Include a Showroom lab guide?**

```
Q: Will this catalog include a Showroom lab guide? [Y/n]
```

If NO → skip this step entirely.

**Question B — Showroom repository:**

```
Q: URL or local path to the Showroom repository:
```

Check for Showroom 1.5.1 structure if local path provided (`site.yml` or `default-site.yml`, `ui-config.yml`, `supplemental-ui/`).

**Question C — Consoles and tools to embed in tabs:**

```
Q: What should learners see in the Showroom right panel?

Each tab appears as a clickable pane next to the lab guide.

Common options for VM catalogs:
- Bastion terminal  → port: 3000, path: /wetty
- AAP dashboard     → url: https://aap.${DOMAIN}
- RHEL Cockpit      → url: https://cockpit.${DOMAIN}:9090
- Grafana           → url: https://grafana.${DOMAIN}
- Code Server       → port: 3001, path: /code
- Custom app        → any https:// URL or port/path on bastion
- External docs     → url: https://docs.redhat.com/... (external: true)

List each as: name | url  OR  name | port + path

Examples:
  Terminal | /wetty (port 3000)
  AAP Dashboard | https://aap.${DOMAIN}

You can also configure this later by editing ui-config.yml in your Showroom repo.

Your tabs (or press Enter to leave as commented-out examples):
```

**Question D — ui-bundle theme:**

```
Q: Which ui-bundle theme do you need?

Default: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-one-2025/ui-bundle.zip

Press Enter to use the default, or paste a different URL:
```

**Generate Showroom section for common.yaml:**

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: v1.5.1   # fixed — minimum v1.5.1

workloads:
- agnosticd.showroom.vm_workload_showroom

# vm_workload_showroom uses short variable names (not ocp4_workload_ prefix)
showroom_git_repo: https://github.com/rhpds/<short-name>-showroom
showroom_git_ref: main
```

**Generate `ui-config.yml`** in the Showroom repo root (Showroom 1.5.1 format):

```yaml
---
type: showroom

default_width: 30
persist_url_state: true

view_switcher:
  enabled: true
  default_mode: split

tabs:
{{ generated_tabs_from_Question_C }}
```

If user pressed Enter (no tabs), add common VM examples as commented lines:

```yaml
tabs:
# - name: Terminal
#   port: 3000
#   path: /wetty
# - name: AAP Dashboard
#   url: 'https://aap.${DOMAIN}'
# - name: RHEL Cockpit
#   url: 'https://cockpit.${DOMAIN}:9090'
```

**If tabs use dynamic hostnames**, instruct user that `${DOMAIN}` is resolved at runtime by the showroom role from the bastion hostname — no hardcoding needed.

**No dev_mode variable** — `vm_workload_showroom` has no Antora dev mode toggle. No dev.yaml override needed.

**If NO (no Showroom):** Skip entirely. No showroom workload, collection, or ui-config.yml added.

---

## Step 8: Multi-User Configuration

⚠️ **cloud-vms-base has no per-user namespace isolation.**

Unlike OCP clusters, cloud-vms-base provisions a shared set of VMs. All users share the same bastion and VM resources. Multi-user only makes sense if your workload explicitly handles user-level isolation (separate accounts, separate directories, etc.).

**Ask:**

```
Q: Does this catalog need multiple concurrent users? [Y/n]

⚠️  cloud-vms-base has no built-in per-user namespace isolation.
    Only enable multi-user if your Ansible roles explicitly handle it.
    Default: single-user (recommended for VM-based catalogs)
```

**If single-user (default — recommended):**

```yaml
__meta__:
  catalog:
    multiuser: false
```

**If multi-user (only if workload handles isolation):**

```yaml
__meta__:
  catalog:
    multiuser: true
    parameters:
      - name: num_users
        description: Number of users (isolation handled by workload)
        formLabel: User Count
        openAPIV3Schema:
          type: integer
          default: 1
          minimum: 1
          maximum: 20
```

No `workshopLabUiRedirect` for VM-based catalogs — there is no per-user Showroom URL to redirect to.

No worker scaling formula — VMs are not scaled by user count.

---

**↩ Return to `SKILL.md` — continue from Step 7: Catalog Details.**
