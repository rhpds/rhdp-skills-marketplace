---
layout: default
title: Updating Cursor Skills
---

# Updating Cursor Skills

Keep your RHDP Skills Marketplace skills up to date in Cursor.

<div class="important-note">
⚠️ <strong>Cursor Updates are Manual</strong>

Unlike Claude Code's marketplace system, Cursor requires manual updates using the update script.
</div>

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

- ✅ Automatic update detection
- ✅ One-command updates
- ✅ Version management
- ✅ Rollback capability

---

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="updating.html">Update Claude Code Skills →</a></li>
    <li><a href="cursor.html">Cursor Setup Guide →</a></li>
    <li><a href="../reference/quick-reference.html">Quick Reference →</a></li>
  </ul>
</div>

<style>
.important-note {
  background: #fff3cd;
  border-left: 4px solid #ffc107;
  padding: 1.5rem;
  margin: 2rem 0;
  border-radius: 8px;
  color: #856404;
}

.important-note strong {
  color: #856404;
  font-size: 1.1rem;
}

.next-steps {
  background: linear-gradient(135deg, #EE0000 0%, #CC0000 100%);
  color: white;
  padding: 2rem;
  border-radius: 12px;
  margin: 2rem 0;
}

.next-steps h3 {
  margin-top: 0;
  color: white;
}

.next-steps a {
  color: white;
  text-decoration: underline;
}

.next-steps a:hover {
  text-decoration: none;
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
  color: #EE0000;
}

details[open] {
  padding-bottom: 1rem;
}

details[open] summary {
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}
</style>
