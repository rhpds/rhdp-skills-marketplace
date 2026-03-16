---
layout: default
title: Updating Cursor Skills
---

# Updating Cursor Skills

Keep your RHDP Skills Marketplace skills up to date in Cursor.

<div class="callout callout-warning"><span class="callout-icon">⚠️</span><div class="callout-body">
<strong>Cursor Updates are Manual</strong>

Unlike Claude Code's marketplace system, Cursor requires manual updates using the update script.
</div></div>

---

## Check Current Version

Check what version you have installed:

```bash
ls -la ~/.cursor/skills/
```

Compare with the latest release at: https://github.com/rhpds/rhdp-skills-marketplace/releases

---

## Update to Latest Version

**Run this in your TERMINAL** (not in Cursor chat):

```bash
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh | bash
```

### What the Update Script Does

1. **Checks current version** from your installed files
2. **Fetches latest version** from GitHub
3. **Compares versions** and shows what's new
4. **Displays changelog** with all changes
5. **Backs up current installation** before updating
6. **Installs latest version** to `~/.cursor/skills/`

### After Update

**Restart Cursor** to load the new skill versions.

Verify update by checking skills are available:

```bash
# Try invoking a skill
/showroom-create-lab
```

---

## Update Frequency

**Recommended schedule:**
- Check for updates: **Monthly**
- Critical fixes: Update immediately when announced

**Where to find update announcements:**
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- GitHub releases: https://github.com/rhpds/rhdp-skills-marketplace/releases

---

## Troubleshooting

<details>
<summary><strong>Skills not showing after update</strong></summary>

1. **Restart Cursor completely** (Cmd+Q / Ctrl+Q, then reopen)
2. Verify files were copied:
   ```bash
   ls ~/.cursor/skills/
   ```
3. Check for actual files (not symlinks):
   ```bash
   file ~/.cursor/skills/showroom-create-lab/SKILL.md
   ```
4. If symlinks, copy actual files:
   ```bash
   cp -r ~/.agents/skills/* ~/.cursor/skills/
   ```

</details>

<details>
<summary><strong>Permission denied errors</strong></summary>

Make sure you have write permissions:

```bash
chmod 755 ~/.cursor/skills
```

</details>

<details>
<summary><strong>Update script fails</strong></summary>

Try manual download and run:

```bash
# Download script
curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update-cursor.sh -o /tmp/update-cursor.sh

# Run with verbose output
bash -x /tmp/update-cursor.sh
```

</details>

---

## Want Automatic Updates?

For automatic update notifications and marketplace integration, use [Claude Code](claude-code.html) instead. Claude Code's plugin marketplace provides:

- Automatic update detection
- One-command updates
- Version management
- Rollback capability

---

<div class="links-grid">
  <a href="updating.html" class="link-card"><h4>Update Claude Code Skills</h4><p>Guide for updating Claude Code plugins</p></a>
  <a href="cursor.html" class="link-card"><h4>Cursor Setup Guide</h4><p>Full setup guide for Cursor</p></a>
  <a href="../reference/quick-reference.html" class="link-card"><h4>Quick Reference</h4><p>Commands at a glance</p></a>
</div>
