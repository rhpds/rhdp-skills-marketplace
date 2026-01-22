---
layout: default
title: Troubleshooting
---

# Troubleshooting

Common issues and solutions for RHDP Skills Marketplace.

---

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

**Symptom:** `/create-lab` not recognized in editor

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

**Symptom:** `/agv-generator` not found but `/create-lab` works

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
4. Re-run `/verify-content` after each batch of fixes

### blog-generate Produces Poor Quality

**Symptom:** Generated blog post lacks structure or clarity

**Solution:**

1. Ensure workshop content is complete and high-quality
2. Review Know/Show structure in lab modules
3. Run `/verify-content` on lab first
4. Try `/blog-generate` again after improving lab content

---

## AgnosticV Skill Issues

### agv-generator Can't Find Repository

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

### agv-validator Reports Many Errors

**Symptom:** Validation fails with multiple errors

**Solution:**

1. Read error messages carefully
2. Fix **ERRORS** first (blocking deployment)
3. Address **WARNINGS** (best practices)
4. Consider **SUGGESTIONS** (optional)
5. Re-validate after each fix:
   ```
   /agv-validator
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

**Slack (RHDP Internal):**
- #forum-rhdp - General RHDP questions
- #forum-rhdp-content - Content creation questions

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

[← Back to Home](../)
