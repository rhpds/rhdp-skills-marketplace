# Showroom Scaffold Setup (create-demo)

## Step 3.1: Showroom Setup (New labs only)

**Skip entirely if adding a module to an existing lab.**

Most developers start from the nookbag template repo (`showroom_template_nookbag`) which already has the correct directory structure. This step only configures two files.

---

### Ask (ONE at a time)

**Q0 — Catalog type:**
```
Is this for an OCP or VM-based catalog?

1. OCP cluster  (uses ocp4_workload_showroom + ocp4_workload_ocp_console_embed)
2. VM / RHEL    (uses vm_workload_showroom — no OCP console)

Choice [1/2]:
```

**Q1 — Tabs (configure in ui-config.yml):**

**⚠️ Tabs MUST be configured** — split view shows a blank right panel without them. Ask the developer which consoles to embed.

*OCP — common tab options:*
```
Which consoles should appear in the right panel?

Tab format for ui-config.yml:
  - name: Terminal
    path: /wetty
    port: 443
  - name: OCP Console
    url: 'https://console-openshift-console.${DOMAIN}'
  - name: OpenShift AI
    url: 'https://rhods-dashboard-redhat-ods-applications.${DOMAIN}'
  - name: AAP
    url: 'https://aap-aap.${DOMAIN}'
  - name: ArgoCD
    url: 'https://openshift-gitops-server-openshift-gitops.${DOMAIN}'
  - name: DevSpaces
    url: 'https://devspaces.${DOMAIN}'

${DOMAIN} is resolved at runtime from the cluster ingress domain.
Enter your tabs, or type 'default' to use commented-out examples:
```

*VM / RHEL — common tab options:*
```
Which tools should appear in the right panel?

  - name: Terminal
    port: 3000
    path: /wetty
  - name: AAP Dashboard
    url: 'https://aap.${DOMAIN}'
  - name: RHEL Cockpit
    url: 'https://cockpit.${DOMAIN}:9090'
  - name: Grafana
    url: 'https://grafana.${DOMAIN}'

Enter your tabs, or type 'default' to use commented-out examples:
```

**Q2 — ui-bundle theme:**
```
Which Red Hat theme?
1. rh-one-2025 (default)
2. rh-summit-2025
3. Other — paste URL

Choice [1/2/3]:

Default: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-one-2025/ui-bundle.zip
Summit:  https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-summit-2025/ui-bundle.zip
```

---

### Files to create or fix

**Only two files the skill handles.**

---

#### 1. `site.yml` (repo root)

`site.yml` is the standard. If repo has `default-site.yml` only → rename to `site.yml` and update `.github/workflows/gh-pages.yml` reference.

| State | Action |
|---|---|
| `site.yml` exists | Check/fix title only |
| `default-site.yml` only | Rename to `site.yml`, update gh-pages.yml |
| Neither exists | Create `site.yml` |

Fix stale titles: `Workshop Title`, `Lab Title`, `Showroom Template`, `Red Hat Showroom`, `My Workshop`, empty, or matches repo directory name.

```yaml
site:
  title: "Your Lab Title"      ← update this
  start_page: modules::index.adoc

content:
  sources:
  - url: .
    start_path: content

ui:
  bundle:
    url: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-one-2025/ui-bundle.zip
    snapshot: true
  supplemental_files:
    - path: ./content/supplemental-ui
    - path: ./content/lib
    - path: .nojekyll
    - path: ui.yml
      contents: "static_files: [ .nojekyll ]"

antora:
  extensions:
  - require: ./content/lib/dev-mode.js
    enabled: false

output:
  dir: ./www
```

Only update `title`. Leave everything else as-is.

---

#### 2. `ui-config.yml` (repo root) — **tabs must be configured**

This file controls split view and which consoles appear on the right.

Check/fix:
- `type: showroom` present → keep
- `view_switcher.enabled: true` → required for split view
- `view_switcher.default_mode: split` → required
- `persist_url_state: true` → required
- **`tabs:` section** → **must have at least one uncommented tab** — blank right panel is the #1 Showroom complaint

```yaml
---
type: showroom

default_width: 30
persist_url_state: true

view_switcher:
  enabled: true
  default_mode: split

tabs:
  {{ from Q1 — at least one tab MUST be uncommented }}
```

**OCP tab examples** (from real `tests/showroom-embed-test` catalog):
```yaml
tabs:
- name: Terminal
  path: /wetty
  port: 443
- name: OCP Console
  url: 'https://console-openshift-console.${DOMAIN}'
- name: OpenShift AI
  url: 'https://rhods-dashboard-redhat-ods-applications.${DOMAIN}'
- name: AAP
  url: 'https://aap-aap.${DOMAIN}'
- name: ArgoCD
  url: 'https://openshift-gitops-server-openshift-gitops.${DOMAIN}'
- name: DevSpaces
  url: 'https://devspaces.${DOMAIN}'
```

**VM tab examples:**
```yaml
tabs:
- name: Terminal
  port: 3000
  path: /wetty
- name: AAP Dashboard
  url: 'https://aap.${DOMAIN}'
- name: RHEL Cockpit
  url: 'https://cockpit.${DOMAIN}:9090'
```

**Tabs can also be overridden at deploy time in AgV** (without changing the Showroom repo):
```yaml
ocp4_workload_showroom_tabs:
  - name: OCP Console
    url: "https://console-openshift-console.${DOMAIN}"
  - name: Terminal
    path: /wetty
    port: 443
```

---

### Report after scaffold

```
✅ Showroom scaffold:
  site.yml      → [created | updated: title] | no changes
  ui-config.yml → [created | updated: tabs, view_switcher] | no changes
  ⚠️  Tabs configured: [list tab names] — learners will see these in the right panel
```

---

### AgnosticV common.yaml — Showroom workloads and vars

**OCP (console embed + split view — BOTH workloads required, embed MUST be first):**
```yaml
workloads:
  - agnosticd.showroom.ocp4_workload_ocp_console_embed   # MUST be before showroom
  - agnosticd.showroom.ocp4_workload_showroom

ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/your-showroom-repo.git
ocp4_workload_showroom_content_git_repo_ref: main
ocp4_workload_showroom_content_antora_playbook: site.yml
```

**VM / cloud-vms-base:**
```yaml
workloads:
  - agnosticd.showroom.vm_workload_showroom

showroom_git_repo: https://github.com/rhpds/your-showroom-repo.git
showroom_git_ref: main
showroom_content_antora_playbook: site.yml
```

**Collection version (requirements_content.collections):**
```yaml
- name: https://github.com/agnosticd/showroom.git
  type: git
  version: "v1.5.4"   # fixed — minimum v1.5.4, always pin to latest
```
