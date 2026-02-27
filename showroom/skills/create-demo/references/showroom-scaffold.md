# Showroom Scaffold Setup (create-demo)

### Step 3.1: Showroom Setup (Recommended for new demos)

**For NEW demos only. Skip if adding a module to an existing demo.**

**Note to RHDP developers**: If you want console embedding (OpenShift Console, Bastion terminal, etc.) and split-view in Showroom, your Showroom deployment must be on version 1.5.3 or above. Contact your RHDP administrator to confirm the version before publishing.

Ask these questions SEQUENTIALLY — one at a time.

**Question A — Consoles and tools to embed:**

```
What consoles or tools should the presenter see in the Showroom right panel?

Each tab appears as a clickable pane next to the demo script.

Common options:
- OpenShift Console  → https://console-openshift-console.${DOMAIN}
- Bastion terminal   → path: /wetty, port: 443
- OpenShift AI       → https://rhods-dashboard-redhat-ods-applications.${DOMAIN}
- AAP dashboard      → https://aap-dashboard.${DOMAIN}
- External URL       → any https:// URL

List each console as: name | url  (or name | path + port for terminals)

Examples:
  OpenShift Console | https://console-openshift-console.${DOMAIN}
  Bastion | /wetty (port 443)

You can adjust these later by editing ui-config.yml.

Your consoles (or press Enter to leave as commented-out examples):
```

**Question B — ui-bundle theme:**

```
Which ui-bundle theme do you need?

Default: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-one-2025/ui-bundle.zip

Available themes (see https://github.com/rhpds/rhdp_showroom_theme/releases):
- rh-one-2025 (default — Red Hat One 2025 theme)
- rh-summit-2025 (Red Hat Summit 2025 theme)

Press Enter to use the default, or paste a different URL:
```

**Now create all infrastructure files:**

**1. Create `site.yml`** (at repo root):

```yaml
site:
  title: "{{ demo_title }}"
  start_page: modules::index.adoc

content:
  sources:
  - url: ./
    start_path: content

ui:
  bundle:
    url: {{ ui_bundle_url }}
    # Themes can be found at https://github.com/rhpds/rhdp_showroom_theme
    # Summit 2025 url: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-summit-2025/ui-bundle.zip
    snapshot: true
  supplemental_files: ./supplemental-ui

runtime:
  fetch: true

asciidoc:
  attributes:
    source-highlighter: rouge
```

**2. Create `ui-config.yml`** (at repo root, Showroom 1.5.3 format):

```yaml
---
type: showroom

# Set the left column width to 30%
default_width: 30
# Persist the URL state so browser refresh doesn't reset the UI
persist_url_state: true

view_switcher:
  enabled: true
  default_mode: split

tabs:
{{ generated_tabs_from_Question_B }}
```

If the user provided tabs in Question B, generate the `tabs:` block. If they pressed Enter, include the common examples as commented-out lines:

```yaml
tabs:
# - name: OpenShift Console
#   url: 'https://console-openshift-console.${DOMAIN}'
# - name: Bastion
#   path: /wetty
#   port: 443
```

**3. Create `content/lib/`** — read these 4 files from `https://github.com/rhpds/lb2298-ibm-fusion` (clone to temp dir if not available locally) and write unchanged:

- `content/lib/all-attributes-console-extension.js`
- `content/lib/attributes-page-extension.js`
- `content/lib/dev-mode.js`
- `content/lib/unlisted-pages-extension.js`

**4. Create `supplemental-ui/`** at repo root — same reference repo, write unchanged:

- `supplemental-ui/css/site-extra.css`
- `supplemental-ui/img/favicon.ico`
- `supplemental-ui/partials/head-meta.hbs`

**5. Create `.github/workflows/gh-pages.yml`:**

```yaml
name: github pages

on:
  workflow_dispatch:
  push:
    branches: [main]
    paths-ignore:
      - "README.adoc"
      - ".gitignore"

permissions:
  pages: write
  id-token: write

concurrency:
  group: gh-pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v4
      - name: configure pages
        uses: actions/configure-pages@v5
      - name: setup node
        uses: actions/setup-node@v4
        with:
          node-version: 20.13.1
      - name: install antora
        run: npm install --global @antora/cli@3.1 @antora/site-generator@3.1
      - name: antora generate
        run: antora generate site.yml --stacktrace
      - name: upload pages artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: www
  deploy:
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
    - name: deploy github pages
      id: deployment
      uses: actions/deploy-pages@v4
```

**6. Update `content/antora.yml`** with demo title and slug:

```yaml
name: modules
title: "{{ demo_title }}"
version: master
start_page: index.adoc
nav:
- modules/ROOT/nav.adoc

asciidoc:
  attributes:
    lab_name: "{{ demo_slug }}"
```

**Confirm scaffold is complete:**

```
✅ Scaffold created:
- site.yml (ui-bundle: {{ ui_bundle_url }})
- ui-config.yml ({{ tab_count }} tab(s) configured)
- content/lib/ (4 JS extension files)
- supplemental-ui/ (css, favicon, partials)
- .github/workflows/gh-pages.yml
- content/antora.yml (updated)
```

**Note**: These files must exist BEFORE generating any content modules (Step 8).

---


---

### AgnosticV common.yaml — Showroom workloads and vars

**OCP (console embed + split view — BOTH workloads required):**
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
