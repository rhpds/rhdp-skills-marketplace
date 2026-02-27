---
layout: default
title: Updating Claude Code Skills
---

# Updating Claude Code Skills

Keep your RHDP Skills Marketplace plugins up to date to get the latest features, bug fixes, and improvements.

<div class="platform-note">
💻 <strong>For Cursor users:</strong> See the <a href="updating-cursor.html">Cursor updating guide</a> instead.
</div>

<div class="important-note">
⚠️ <strong>IMPORTANT: Two-Step Update Process</strong>

You must update the marketplace FIRST before updating plugins:

1. **Update marketplace** - Syncs from GitHub to learn about new versions
2. **Update plugins** - Installs the new versions

If you skip Step 1, the marketplace won't know new versions exist and won't show "Update now" options.
</div>

---

## Claude Code / VS Code

### Check Current Version

**Step 1: Open Plugin Interface**

In Claude Code chat, type:

```bash
/plugin
```

**Step 2: View Installed Plugins**

Navigate to the **Installed** tab (use arrow keys or tab to cycle through tabs).

You'll see your installed plugins with their current versions:

```
showroom @ rhdp-marketplace
Scope: user
Version: 2.4.3
Red Hat Showroom workshop and demo authoring, verification, and content transformation
```

### Update Plugins

**Step 1: Open Plugin Interface**

```bash
/plugin
```

**Step 2: Navigate to Marketplaces Tab**

Use arrow keys or tab to cycle to the **Marketplaces** tab.

<img src="{{ '/assets/images/updating/step1-plugin-marketplaces.png' | relative_url }}" alt="Navigate to Marketplaces tab">
<em>Screenshot: Use arrow keys or Tab to navigate to the Marketplaces tab</em>

**Step 3: Update Marketplace (REQUIRED FIRST)**

Select **Update marketplace** from the menu.

**Why this step is required:**
- The marketplace is a cached copy of the GitHub repository
- When new versions are released, your local cache is outdated
- Updating marketplace syncs from GitHub and pulls latest plugin.json files
- Only AFTER this sync will Claude Code know v2.4.3 (or newer) exists

You'll see:
- Last updated date
- "✓ Updated 1 marketplace" confirmation after syncing

<img src="{{ '/assets/images/updating/step2-updated-marketplace.png' | relative_url }}" alt="Updated marketplace confirmation">
<em>Screenshot: "✓ Updated 1 marketplace" confirmation shows marketplace is synced</em>

**Step 4: Check for Plugin Updates**

Navigate back to the **Installed** tab.

For each plugin, you'll see:
- Current version
- "Update now" option if updates are available

<img src="{{ '/assets/images/updating/step3-installed-tab.png' | relative_url }}" alt="Plugin details showing version">
<em>Screenshot: Installed tab shows current version (e.g., Version: 2.4.3)</em>

**Step 5: Update Plugins**

Select **Update now** for each plugin that has updates are available.

<img src="{{ '/assets/images/updating/step4-update-now.png' | relative_url }}" alt="Update now option">
<em>Screenshot: Select "Update now" to install the latest version</em>

The plugin will update to the latest version from the marketplace.

<img src="{{ '/assets/images/updating/step5-version-updated.png' | relative_url }}" alt="Updated version confirmation">
<em>Screenshot: After update, version number shows the latest release (e.g., Version: 2.4.4)</em>

---

## Getting a New Plugin (e.g. /ftl:lab-validator added in v2.8.1)

When the marketplace gains a **brand new plugin** (not just an update to an existing one), it won't appear in your installed list automatically — you need to install it explicitly.

**Step 1: Update marketplace first**

```bash
/plugin marketplace update
```

This pulls the latest marketplace index from GitHub. After this, the new plugin will appear in the **Marketplace** tab under Browse.

**Step 2: Install the new plugin**

```bash
/plugin install ftl@rhdp-marketplace
```

**Step 3: Restart Claude Code**

The new skill `/ftl:lab-validator` will now be available.

> **Why is this different from a regular update?**
> `/plugin update` only updates plugins you already have installed. A brand new plugin has never been installed, so it won't show up in the update list — you need to explicitly install it once.

---

## Understanding the Update Process

**Why two steps?**

**Step 1: Update Marketplace**
- **What it does**: Syncs the marketplace repository from GitHub
- **What changes**: Local cache of plugin.json files
- **What it learns**: New versions are available (e.g., v2.4.3)
- **What it does NOT do**: Does not update your installed plugins

**Step 2: Update Plugins**
- **What it does**: Downloads and installs new plugin versions
- **What changes**: Your installed skills in `~/.claude/plugins/cache/`
- **Requires**: Marketplace must be updated first (Step 1)
- **Why**: Can't install what it doesn't know exists

**Common mistake:** Trying to update plugins without updating marketplace first = marketplace still thinks you have the latest version because its cache is outdated.

---

## Quick Update Command

Instead of using the UI, you can update via command:

```bash
/plugin marketplace update
```

This will:
1. **Sync the marketplace** (pulls latest plugin.json from GitHub)
2. Check all installed plugins for updates
3. Show changelog for available updates
4. Prompt you to install updates

**This command does both steps automatically** - it syncs marketplace THEN shows plugin updates.

**Example output:**

```
Checking for updates...

Updates available:
• showroom: v2.4.2 → v2.4.3
• agnosticv: v2.4.2 → v2.4.3
• health: v2.4.2 → v2.4.3

Changelog for v2.4.3:
- Fixed installation documentation
- Fixed code block rendering in setup guides
- Updated migration guide with claude command
- Synced plugin.json versions

Install updates? (y/n)
```

---

## Verify Updated Version

After updating, verify the new version:

**Method 1: Plugin List**

```bash
/plugin list
```

Shows all installed plugins with versions:

```
showroom @ rhdp-marketplace (v2.4.3)
agnosticv @ rhdp-marketplace (v2.4.3)
health @ rhdp-marketplace (v2.4.3)
```

**Method 2: Plugin Interface**

```bash
/plugin
```

Navigate to **Installed** tab, select a plugin to see full details including version number.

---

## Check Latest Available Version

To see what version is currently available in the marketplace:

**Step 1: Check GitHub Releases**

Visit: https://github.com/rhpds/rhdp-skills-marketplace/releases

The latest release tag shows the current version (e.g., v2.4.3).

**Step 2: Compare with Installed Version**

Use `/plugin list` to see your installed version.

If your version is lower than the latest release:
1. Run `/plugin marketplace update`
2. Install available updates

---

## Update Frequency

**Recommended schedule:**
- Check for updates: **Monthly**
- Critical fixes: Update immediately when announced in Slack

**Update notifications:**
- Claude Code marketplace checks automatically
- Announcements posted in: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- GitHub releases: https://github.com/rhpds/rhdp-skills-marketplace/releases

---

## Troubleshooting

<details>
<summary><strong>Marketplace shows outdated versions</strong></summary>

Force sync the marketplace:

```bash
/plugin marketplace sync
```

Then check for updates:

```bash
/plugin marketplace update
```

</details>

<details>
<summary><strong>Update command shows "no updates available" but I know there's a new version</strong></summary>

**Most common cause:** Marketplace cache is stale. You must update the marketplace FIRST before plugin updates appear.

Try:

```bash
/plugin marketplace sync
/plugin marketplace update
```

If that doesn't work, remove and re-add the marketplace:

```bash
/plugin marketplace remove rhdp-marketplace
/plugin marketplace add rhpds/rhdp-skills-marketplace
```

Then install the plugins again:

```bash
/plugin install showroom@rhdp-marketplace
/plugin install agnosticv@rhdp-marketplace
/plugin install health@rhdp-marketplace
/plugin install ftl@rhdp-marketplace
```

</details>

<details>
<summary><strong>Plugin updated but I still see old version</strong></summary>

1. Restart Claude Code completely
2. Check version again: `/plugin list`
3. If still showing old version, reinstall:
   ```bash
   /plugin uninstall showroom
   /plugin install showroom@rhdp-marketplace
   ```

</details>

---

## Version History

To see all past versions and changes:

- **CHANGELOG**: https://github.com/rhpds/rhdp-skills-marketplace/blob/main/CHANGELOG.md
- **All Releases**: https://github.com/rhpds/rhdp-skills-marketplace/releases

---

<div class="next-steps">
  <h3>📚 Next Steps</h3>
  <ul>
    <li><a href="../reference/quick-reference.html">Quick Reference Guide →</a></li>
    <li><a href="claude-code.html">Installation Guide →</a></li>
    <li><a href="../skills/create-lab.html">Using Skills →</a></li>
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

.platform-note {
  background: #e7f3ff;
  border-left: 4px solid #0969da;
  padding: 1rem;
  margin: 1.5rem 0;
  border-radius: 4px;
  color: #0969da;
}

.platform-note a {
  color: #0969da;
  text-decoration: underline;
  font-weight: 600;
}

.platform-note a:hover {
  text-decoration: none;
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

/* Screenshot styling */
img[src*="/assets/images/updating/"] {
  border: 2px solid #e1e4e8;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  margin: 1.5rem 0 0.5rem 0;
  max-width: 100%;
  display: block;
}

img[src*="/assets/images/updating/"] + em {
  display: block;
  text-align: center;
  color: #586069;
  font-size: 0.875rem;
  font-style: italic;
  margin-bottom: 1.5rem;
  padding: 0.5rem;
  background: #f6f8fa;
  border-radius: 4px;
}
</style>
