# Showroom Scaffold Setup (create-lab)

### Step 3.1: Showroom Setup (Recommended for new labs)

**For NEW labs only. Skip if adding a module to an existing lab.**

**Note to RHDP developers**: If you want console embedding (OpenShift Console, Bastion terminal, etc.) and split-view in Showroom, your Showroom deployment must be on version 1.5.3 or above. Contact your RHDP administrator to confirm the version before publishing.

Ask these questions SEQUENTIALLY — one at a time.

**Question 0 — Catalog infrastructure type:**

```
Is this Showroom for an OCP-based or VM-based catalog?

1. OCP cluster     (OpenShift — uses ocp4_workload_showroom)
2. VM / RHEL       (cloud-vms-base — uses vm_workload_showroom, no OCP console)

Choice [1/2]:
```

**Question A — Consoles and tools to embed:**

*If OCP (choice 1):*
```
What consoles or tools should learners see in the Showroom right panel?

Common options for OCP catalogs:
- OpenShift Console  → https://console-openshift-console.${DOMAIN}
- Bastion terminal   → path: /wetty, port: 443
- OpenShift AI       → https://rhods-dashboard-redhat-ods-applications.${DOMAIN}
- AAP dashboard      → https://aap-dashboard.${DOMAIN}
- External URL       → any https:// URL

Examples:
  OpenShift Console | https://console-openshift-console.${DOMAIN}
  Bastion | /wetty (port 443)

Your consoles (or press Enter to leave as commented-out examples):
```

*If VM / RHEL (choice 2):*
```
What consoles or tools should learners see in the Showroom right panel?

Common options for VM catalogs (no OCP console available):
- Bastion terminal   → port: 3000, path: /wetty
- AAP dashboard      → https://aap.${DOMAIN}
- RHEL Cockpit       → https://cockpit.${DOMAIN}:9090
- Grafana            → https://grafana.${DOMAIN}
- Code Server        → port: 3001, path: /code
- Custom app         → any port/path on the bastion VM
- External docs      → any https:// URL (add external: true)

Note: ${DOMAIN} is resolved at runtime from the bastion hostname.

Examples:
  Terminal | /wetty (port 3000)
  AAP Dashboard | https://aap.${DOMAIN}

Your consoles (or press Enter to leave as commented-out examples):
```

If user presses Enter → add appropriate commented-out examples per infra type in the generated ui-config.yml.

**Question B — ui-bundle theme:**

```
Which ui-bundle theme do you need?

Default: https://github.com/rhpds/rhdp_showroom_theme/releases/download/rh-one-2025/ui-bundle.zip

Available themes (see https://github.com/rhpds/rhdp_showroom_theme/releases):
- rh-one-2025 (default — Red Hat One 2025 theme)
- rh-summit-2025 (Red Hat Summit 2025 theme)

Press Enter to use the default, or paste a different URL:
```

**Check, fix, or create each infrastructure file — never blindly overwrite.**

For every file below: silently check if it exists first.
- **EXISTS** → read it, detect stale/template values, fix only what's wrong, report changes.
- **MISSING** → create it from scratch, report created.

**Known stale/template title values** (treat as "not updated"):
`Workshop Title`, `Lab Title`, `Showroom Template`, `Red Hat Showroom`, `My Workshop`, `Template`, `showroom_template_nookbag`, empty string, or any value that exactly matches the repository directory name.

---

**1. `site.yml`** (at repo root — the going-forward standard):

The showroom role supports both `site.yml` and `site.yml` via fallback. `site.yml` is the new standard. `site.yml` is also valid and silently supported by the role.

```bash
# Check which playbook file exists
ls site.yml 2>/dev/null && echo "found site.yml"
ls site.yml 2>/dev/null && echo "found site.yml"
```

| State | Action |
|---|---|
| `site.yml` exists | Proceed to check/fix below |
| `site.yml` exists, no `site.yml` | Rename to `site.yml` silently, then check/fix |
| Both exist | Use `site.yml`, remove `site.yml` |
| Neither exists | Create `site.yml` from scratch |

If renaming:
```bash
mv site.yml site.yml

# Also update the GitHub Pages workflow if it references the old name
if grep -q "site.yml" .github/workflows/gh-pages.yml 2>/dev/null; then
  sed -i '' 's/antora generate site.yml/antora generate site.yml/g' .github/workflows/gh-pages.yml
fi
```
Report: `✓ Renamed site.yml → site.yml (new standard)`
Report: `✓ Updated .github/workflows/gh-pages.yml to reference site.yml` (if applicable)

*If EXISTS — check and fix:*
- `site.title` is stale/template → update to `"{{ lab_title }}"`
- `site.start_page` is not `modules::index.adoc` → fix
- `ui.bundle.url` is the old default nookbag bundle (not the theme from Question B) → update to `{{ ui_bundle_url }}`
- `ui.supplemental_files` is missing or not `./supplemental-ui` → fix
- `runtime.fetch` is missing → add `fetch: true`

*If MISSING — create `site.yml`:*
```yaml
site:
  title: "{{ lab_title }}"
  start_page: modules::index.adoc

content:
  sources:
  - url: ./
    start_path: content

ui:
  bundle:
    url: {{ ui_bundle_url }}
    # Themes: https://github.com/rhpds/rhdp_showroom_theme/releases
    snapshot: true
  supplemental_files:
    - path: ./content/supplemental-ui
    - path: ./content/lib

runtime:
  fetch: true

asciidoc:
  attributes:
    source-highlighter: rouge
```

---

**2. `ui-config.yml`** (at repo root, Showroom 1.5.4 format):

**⚠️ Tabs must be configured** — split view is enabled but the right panel is blank without tabs. Always ask the developer which consoles to show and configure them. A blank right panel is one of the most common Showroom issues.

*If EXISTS — check and fix:*
- `type: showroom` missing → add at top
- `view_switcher.enabled` is false or missing → set `enabled: true`, `default_mode: split`
- `tabs:` section is entirely commented out → uncomment and configure tabs from Question A
- `persist_url_state` missing → add `persist_url_state: true`

*If MISSING — create:*
```yaml
---
type: showroom

default_width: 30
persist_url_state: true

view_switcher:
  enabled: true
  default_mode: split

tabs:
{{ generated_tabs_from_Question_A }}
```

If user pressed Enter (no tabs): add commented-out examples appropriate for infra type from Question 0.

*OCP (choice 1):*
```yaml
tabs:
# - name: OpenShift Console
#   url: 'https://console-openshift-console.${DOMAIN}'
# - name: Bastion
#   path: /wetty
#   port: 443
# - name: OpenShift AI
#   url: 'https://rhods-dashboard-redhat-ods-applications.${DOMAIN}'
```

*VM / RHEL (choice 2):*
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

---

**3. `content/antora.yml`**:

*If EXISTS — check and fix:*
- `title:` is stale/template value → update to `"{{ lab_title }}"`
- `name:` is not `modules` → fix to `modules`
- `start_page:` is missing or not `index.adoc` → fix
- `asciidoc.attributes.lab_name` is stale/template or missing → update to `"{{ lab_slug }}"`
- `nav:` list missing `modules/ROOT/nav.adoc` → add it

*If MISSING — create:*
```yaml
name: modules
title: "{{ lab_title }}"
version: master
start_page: index.adoc
nav:
- modules/ROOT/nav.adoc

asciidoc:
  attributes:
    lab_name: "{{ lab_slug }}"
```

---

**4. `content/lib/`** — 4 JS extension files:

Check each file individually. For each that is MISSING, clone reference repo and copy it:
```bash
# Clone reference if not already available
# JS extension files should already be in your repo if cloned from showroom_template_nookbag
```

Files to check/copy if missing:
- `content/lib/all-attributes-console-extension.js`
- `content/lib/attributes-page-extension.js`
- `content/lib/dev-mode.js`
- `content/lib/unlisted-pages-extension.js`

If all 4 already exist → confirm present, skip clone.

---

**5. `supplemental-ui/`** — 4 UI asset files:

Same pattern — check each, copy only missing ones:
- `content/supplemental-ui/css/site-extra.css`
- `content/supplemental-ui/img/favicon.ico`
- `content/supplemental-ui/partials/head-meta.hbs`

---

**6. `.github/workflows/gh-pages.yml`**:

*If EXISTS* → do not modify (workflow is rarely wrong, and changes could break CI). Just confirm it's present.

*If MISSING — create:*
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

---

**Confirm scaffold status:**

```
✅ Scaffold complete:

  site.yml              → [created | updated: title, ui-bundle] | no changes
  ui-config.yml         → [created | updated: view_switcher, tabs] | no changes
  content/antora.yml    → [created | updated: title, lab_name] | no changes
  content/lib/          → [all present | copied 2 missing files]
  supplemental-ui/      → [all present | copied 1 missing file]
  .github/workflows/    → [created | already present]
```

**⚠️ GitHub Pages must be enabled manually** (one-time setup per repo):

```
1. Go to your GitHub repository
2. Settings → Pages
3. Under "Build and deployment", set Source to: GitHub Actions
4. Save

Without this step the gh-pages.yml workflow will run but GitHub Pages
will not be published — the Showroom guide URL will return 404.

After enabling, the first push to main will trigger a build.
Your guide will be available at:
  https://rhpds.github.io/<repo-name>/
```

**Note**: These files must exist and have correct values BEFORE generating any content modules (Step 8).

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

**Collection version (requirements_content.collections):**
```yaml
- name: agnosticd.showroom
  version: ">=1.5.3"
```
