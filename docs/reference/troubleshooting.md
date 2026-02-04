---
layout: default
title: Troubleshooting
---

# Troubleshooting

<div class="page-badge">🔧 Common Issues & Solutions</div>

Complete troubleshooting guide for RHDP Skills Marketplace.

---

## 🔌 Plugin-Based Installation Issues

<details>
<summary><strong>Marketplace Shows "(no content)"</strong></summary>

<div class="issue-card">
  <h4>Symptom:</h4>
  <p>After adding marketplace, plugin list shows "(no content)"</p>

  <h4>Causes:</h4>
  <ul>
    <li>Old cached marketplace data</li>
    <li>Plugin structure mismatch</li>
  </ul>

  <h4>Solution:</h4>
  <pre><code># Remove and re-add marketplace
/plugin marketplace remove rhdp-marketplace
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Or force refresh
/plugin marketplace update</code></pre>
</div>

</details>

<details>
<summary><strong>Skills Don't Show Namespace Prefix</strong></summary>

<div class="issue-card">
  <h4>Symptom:</h4>
  <p>Skills listed incorrectly without namespace prefix</p>

  <h4>Cause:</h4>
  <p>Old plugin version installed</p>

  <h4>Solution:</h4>
  <pre><code># Update marketplace
/plugin marketplace update

# Update plugins
/plugin update showroom@rhdp-marketplace
/plugin update agnosticv@rhdp-marketplace

# Restart Claude Code
# Exit completely and restart</code></pre>
</div>

</details>

<details>
<summary><strong>SSH Clone Fails (Permission Denied)</strong></summary>

<div class="issue-card warning">
  <h4>Symptom:</h4>
  <p><code>Permission denied (publickey)</code> when adding marketplace</p>

  <h4>Cause:</h4>
  <p>Using SSH format without SSH keys configured</p>

  <h4>Solution:</h4>
  <p>Use HTTPS instead:</p>
  <pre><code>/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace</code></pre>
</div>

</details>

### Skills Not Available After Installation

**Symptom:** Installed plugin but skills don't appear in `/help` or `/skills`

**Cause:** Claude Code needs restart to load new plugins

**Solution:**

1. Exit Claude Code completely (not just close window)
2. Restart Claude Code
3. Verify: `/skills`

### Unknown skill: showroom:create-demo

**Symptom:** Error message when trying to use `/showroom:create-demo`

**Causes:**
1. Plugin not installed
2. Old plugin version (without namespace support)
3. Claude Code not restarted after installation

**Solution:**

```bash
# Check installed plugins
/plugin list

# If not installed
/plugin install showroom@rhdp-marketplace

# If installed, update it
/plugin update showroom@rhdp-marketplace

# Restart Claude Code
# Exit and restart
```

### Plugins Installed But Old Skills Still Appear

**Symptom:** Both old `/showroom:create-lab` and new `/showroom:create-lab` appear

**Cause:** Old file-based installation not removed

**Solution:**

```bash
# Remove old file-based skills
rm -rf ~/.claude/skills/create-lab
rm -rf ~/.claude/skills/create-demo
rm -rf ~/.claude/skills/blog-generate
rm -rf ~/.claude/skills/verify-content
rm -rf ~/.claude/skills/agnosticv-catalog-builder
rm -rf ~/.claude/skills/agnosticv-validator
rm -rf ~/.claude/skills/deployment-health-checker

# Restart Claude Code
```

---

## Migration Issues

### All Skills Deleted After Clean Install

**Symptom:** Removed old plugins but new ones don't work

**Cause:** Forgot to reinstall marketplace plugins

**Solution:**

```bash
# Add marketplace (choose one)
# If you have SSH keys configured for GitHub
/plugin marketplace add rhpds/rhdp-skills-marketplace

# If SSH not configured, use HTTPS
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Install plugins
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace

# Restart Claude Code
```

### Want to Rollback to File-Based Installation

**Symptom:** Plugin system not working, need old installation

**Solution:**

See [Migration Guide - Rollback](../setup/migration.html#rollback-if-needed)

---

## Plugin Update Issues

### Update Shows No New Version Available

**Symptom:** `/plugin marketplace update` says no updates but you know there's a newer version

**Solution:**

```bash
# Force remove and re-add marketplace
/plugin marketplace remove rhdp-marketplace
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace

# Reinstall plugins
/plugin install showroom@rhdp-marketplace --force
```

### Plugin Cache Corrupted

**Symptom:** Plugins behaving strangely or skills missing

**Solution:**

```bash
# Completely remove plugins
/plugin uninstall showroom@rhdp-marketplace
/plugin uninstall agnosticv@rhdp-marketplace
/plugin uninstall health@rhdp-marketplace

# Remove marketplace
/plugin marketplace remove rhdp-marketplace

# Clear cache manually
rm -rf ~/.claude/plugins/cache/*
rm -rf ~/.claude/plugins/marketplaces/*

# Reinstall fresh
/plugin marketplace add https://github.com/rhpds/rhdp-skills-marketplace
/plugin install showroom@rhdp-marketplace

# Restart Claude Code
```

---

## File-Based Installation Issues (Legacy)

<div class="warning">
  <strong>Note:</strong> File-based installation is deprecated. Please use <a href="../setup/migration.html">plugin-based installation</a>.
</div>

## Installation Issues

### Git Not Installed

**Symptom:** `git: command not found`

**Solution:**

```bash
# macOS
brew install git

# RHEL/Fedora
sudo dnf install git

# Ubuntu/Debian
sudo apt-get install git
```

### Installation Fails Silently

**Symptom:** No errors but skills not installed

**Solution:**

```bash
# Run with verbose output
bash -x <(curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh)

# Check permissions
ls -la ~/.claude/
ls -la ~/.cursor/
```

### Cannot Download Install Script

**Symptom:** `curl: Could not resolve host`

**Solution:**

1. Check internet connection
2. Verify GitHub is accessible
3. Try alternative installation:

```bash
# Clone and run locally
git clone https://github.com/rhpds/rhdp-skills-marketplace.git
cd rhdp-skills-marketplace
./install.sh
```

---

## Skill Recognition Issues

### Skill Not Found After Installation

**Symptom:** `/showroom:create-lab` not recognized in editor

**Solution:**

1. **Restart your editor** (most common fix)
2. Verify installation:
   ```bash
   ls ~/.claude/skills/create-lab
   ls ~/.cursor/skills/create-lab
   ```
3. Check version file:
   ```bash
   cat ~/.claude/skills/.rhdp-marketplace-version
   ```
4. Reinstall if needed:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
   ```

### Wrong Namespace Installed

**Symptom:** `/agnosticv:catalog-builder` not found but `/showroom:create-lab` works

**Solution:**

This is expected - you installed only showroom namespace. To add agnosticv skills:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --namespace agnosticv
```

Or install all:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --namespace all
```

### Skills Installed for Wrong Platform

**Symptom:** Skills in `~/.claude/` but using Cursor

**Solution:**

Reinstall for correct platform:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | \
  bash -s -- --platform cursor --namespace all --force
```

---

## Showroom Skill Issues

### create-lab Generates Invalid AsciiDoc

**Symptom:** Showroom build fails with AsciiDoc errors

**Solution:**

1. Run verification:
   ```
   /verify-content
   ```
2. Fix reported syntax errors
3. Common issues:
   - Missing blank lines before code blocks
   - Unclosed attributes `{}`
   - Invalid heading levels

### Attributes Not Rendering

**Symptom:** `{openshift_console_url}` shows as literal text

**Solution:**

Ensure `_attributes.adoc` is defined:

```asciidoc
// content/modules/ROOT/partials/_attributes.adoc
:openshift_console_url: https://console.example.com
:user: user1
:password: openshift
```

And referenced in pages:

```asciidoc
// At top of module file
include::partial$_attributes.adoc[]
```

### verify-content Reports Many Issues

**Symptom:** Long list of warnings and errors

**Solution:**

1. Fix errors first (blocking issues)
2. Address warnings (best practices)
3. Review suggestions (optional improvements)
4. Re-run `/showroom:verify-content` after each batch of fixes

### blog-generate Produces Poor Quality

**Symptom:** Generated blog post lacks structure or clarity

**Solution:**

1. Ensure workshop content is complete and high-quality
2. Review Know/Show structure in lab modules
3. Run `/showroom:verify-content` on lab first
4. Try `/showroom:blog-generate` again after improving lab content

---

## AgnosticV Skill Issues

### agnosticv-catalog-builder Can't Find Repository

**Symptom:** `AgnosticV repository not found at ~/work/code/agnosticv`

**Solution:**

Clone the repository:

```bash
cd ~/work/code
git clone git@github.com:rhpds/agnosticv.git
```

Verify access:

```bash
cd agnosticv
git status
```

### UUID Already Exists

**Symptom:** `UUID collision detected`

**Solution:**

Generate new UUID:

```bash
# macOS/Linux
uuidgen

# Python
python -c "import uuid; print(uuid.uuid4())"
```

Update `common.yaml`:

```yaml
__meta__:
  asset_uuid: <new-uuid-here>
```

### Workload Collection Not Found

**Symptom:** `Collection <name> not available in requirements`

**Solution:**

1. Check collection name spelling
2. Verify collection version exists:
   ```bash
   ansible-galaxy collection list <namespace>.<collection>
   ```
3. Check AgnosticD core_workloads repository
4. Update `requirements_content.collections` in `common.yaml`

### agnosticv-validator Reports Many Errors

**Symptom:** Validation fails with multiple errors

**Solution:**

1. Read error messages carefully
2. Fix **ERRORS** first (blocking deployment)
3. Address **WARNINGS** (best practices)
4. Consider **SUGGESTIONS** (optional)
5. Re-validate after each fix:
   ```
   /agnosticv-validator
   ```

### Cannot Push to Remote

**Symptom:** `Permission denied (publickey)` or `remote: Repository not found`

**Solution:**

1. Verify SSH key setup:
   ```bash
   ssh -T git@github.com
   ```
2. Check remote URL:
   ```bash
   git remote -v
   ```
3. Update remote if needed:
   ```bash
   git remote set-url origin git@github.com:rhpds/agnosticv.git
   ```

---

## RHDP Integration Issues

### Catalog Not Found in RHDP

**Symptom:** Cannot find catalog after pushing to Git

**Solution:**

1. Verify PR is merged to main branch
2. Wait 5-10 minutes for sync
3. Check catalog slug matches directory name
4. Verify `__meta__.catalog.display_name` is set

### Deployment Fails in RHDP

**Symptom:** Service fails to deploy

**Solution:**

1. Check **Events** tab in RHDP service
2. Look for error messages
3. Common issues:
   - Invalid UUID
   - Missing workload collection
   - Infrastructure not available
   - Workload configuration errors
4. Fix issues in Git and redeploy

### UserInfo Variables Not Available

**Symptom:** Cannot find UserInfo after deployment

**Solution:**

1. Wait for deployment to complete (check status)
2. Go to service **Details** → **Advanced settings**
3. Look for `user_info_messages` section
4. If missing, check workload configurations for `agnosticd_user_info` tasks

---

## Update Issues

### Update Script Shows "Already Latest"

**Symptom:** Update says latest version but you know there's a newer one

**Solution:**

Force update:

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | \
  bash -s -- --force
```

### Update Fails Mid-Installation

**Symptom:** Update starts but doesn't complete

**Solution:**

1. Check internet connection
2. Restore from backup:
   ```bash
   ls ~/.claude/skills-backup-*/
   cp -r ~/.claude/skills-backup-<timestamp>/* ~/.claude/skills/
   ```
3. Try fresh installation:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash
   ```

---

## Platform-Specific Issues

### macOS: Permission Denied

**Symptom:** `Permission denied` when installing

**Solution:**

```bash
# Check ownership
ls -la ~/.claude/
ls -la ~/.cursor/

# Fix ownership if needed
sudo chown -R $USER:staff ~/.claude/
sudo chown -R $USER:staff ~/.cursor/
```

### macOS: Gatekeeper Blocks Execution

**Symptom:** "cannot be opened because it is from an unidentified developer"

**Solution:**

Scripts are safe, but if blocked:

```bash
# Run with bash explicitly
bash <(curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh)
```

### Linux: Home Directory Not Standard

**Symptom:** Installation fails because skills directory not found

**Solution:**

Set `HOME` explicitly:

```bash
HOME=/custom/home/path bash <(curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh)
```

---

## Getting Help

### Before Asking for Help

1. **Check this troubleshooting guide**
2. **Search GitHub Issues:** [Existing issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
3. **Gather information:**
   - Platform (Claude Code or Cursor)
   - Version installed
   - Error messages (full text)
   - Steps to reproduce

### How to Get Help

**GitHub Issues:** [Create new issue](https://github.com/rhpds/rhdp-skills-marketplace/issues/new)

**Slack:**
- [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) - RHDP questions and support

**Include in Your Request:**
```
Platform: Claude Code / Cursor
Version: (from ~/.claude/skills/.rhdp-marketplace-version)
Namespace: showroom / agnosticv / all
Issue: Brief description
Error Message: Full error text
Steps to Reproduce: What you did before the error
```

---

## Known Issues

### Issue: Skills Load Slowly

**Status:** Known limitation

**Workaround:** First invocation may be slow; subsequent calls are faster

### Issue: Validation Takes Time on Large Catalogs

**Status:** Expected behavior

**Workaround:** Use validation scope selection (quick vs full)

---

## Debug Mode

For advanced troubleshooting:

```bash
# Installation debug
bash -x <(curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh)

# Check file permissions
ls -laR ~/.claude/skills/
ls -laR ~/.cursor/skills/

# Verify Git configuration
git config --list

# Check Python availability (for UUID generation)
python --version
python3 --version
```

---

<div class="navigation-footer">
  <a href="../" class="nav-button">← Back to Home</a>
  <a href="../setup/" class="nav-button">Setup Guide →</a>
</div>

<style>
.page-badge {
  display: inline-block;
  background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  margin: 1rem 0;
}

.issue-card {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-left: 4px solid #0969da;
  padding: 1.5rem;
  border-radius: 4px;
  margin-top: 1rem;
}

.issue-card.warning {
  border-left-color: #ffc107;
}

.issue-card.error {
  border-left-color: #dc3545;
}

.issue-card h4 {
  margin-top: 0;
  color: #24292e;
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  margin-bottom: 0.5rem;
}

.issue-card p {
  color: #586069;
  margin: 0.5rem 0;
}

.issue-card ul {
  margin: 0.5rem 0;
  padding-left: 1.25rem;
  color: #586069;
  font-size: 0.875rem;
}

.issue-card pre {
  background: #f6f8fa;
  padding: 1rem;
  border-radius: 6px;
  margin: 0.75rem 0 0 0;
}

.issue-card code {
  background: #f6f8fa;
  padding: 0.125rem 0.375rem;
  border-radius: 3px;
  font-size: 0.875rem;
  color: #EE0000;
}

.navigation-footer {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  margin: 2rem 0;
  padding-top: 2rem;
  border-top: 1px solid #e1e4e8;
}

.nav-button {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  text-decoration: none;
  color: #24292e;
  font-weight: 600;
  transition: all 0.2s ease;
}

.nav-button:hover {
  border-color: #EE0000;
  color: #EE0000;
  transform: translateY(-2px);
}

details {
  background: #f6f8fa;
  border: 1px solid #e1e4e8;
  border-radius: 8px;
  padding: 1rem;
  margin: 1rem 0;
}

summary {
  cursor: pointer;
  font-weight: 600;
  color: #24292e;
}

summary:hover {
  color: #0969da;
}

details[open] {
  padding-bottom: 1rem;
}

details[open] summary {
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}

.warning {
  background: #fff3cd;
  border-left: 4px solid #ffc107;
  padding: 1rem;
  margin: 1rem 0;
  border-radius: 4px;
}

.warning strong {
  color: #856404;
}

.warning a {
  color: #0969da;
  text-decoration: none;
}

.warning a:hover {
  text-decoration: underline;
}

h2 {
  color: #24292e;
  border-bottom: 2px solid #e1e4e8;
  padding-bottom: 0.5rem;
  margin-top: 2rem;
}

h3 {
  color: #24292e;
  margin-top: 1.5rem;
}

code {
  background: #f6f8fa;
  padding: 0.125rem 0.375rem;
  border-radius: 3px;
  font-size: 0.875rem;
  color: #EE0000;
}

pre code {
  color: #24292e;
}
</style>
