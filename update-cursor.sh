#!/bin/bash

# Update RHDP Skills for Cursor
# Checks for updates and reinstalls if available

set -e

SKILLS_DIR="$HOME/.cursor/skills"
DOCS_DIR="$HOME/.cursor/docs"
VERSION_FILE="$SKILLS_DIR/.rhdp-version"
REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace.git"
TMP_DIR="/tmp/rhdp-skills-update-$$"

echo "════════════════════════════════════════════════════"
echo "  RHDP Skills Marketplace - Cursor Update"
echo "════════════════════════════════════════════════════"
echo ""

# Check if skills are installed
if [ ! -d "$SKILLS_DIR" ] || [ ! "$(ls -A $SKILLS_DIR 2>/dev/null)" ]; then
  echo "❌ No RHDP skills found in $SKILLS_DIR"
  echo ""
  echo "To install, run:"
  echo "  curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install-cursor.sh | bash"
  echo ""
  exit 1
fi

# Get current version
CURRENT_VERSION="unknown"
if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
fi

echo "📋 Current version: $CURRENT_VERSION"
echo "🔍 Checking for updates..."

# Clone latest version
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>&1 | grep -v "^Cloning" || true
cd "$TMP_DIR"

# Get latest version
LATEST_VERSION=$(git describe --tags --always 2>/dev/null || echo "unknown")

echo "📦 Latest version: $LATEST_VERSION"
echo ""

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✅ Already up to date!"
  rm -rf "$TMP_DIR"
  exit 0
fi

# Show changelog if available
if [ -f "CHANGELOG.md" ]; then
  echo "📝 Recent changes:"
  echo "────────────────────────────────────────────────────"
  head -n 20 CHANGELOG.md
  echo "────────────────────────────────────────────────────"
  echo ""
fi

# Confirm update
read -p "Update to version $LATEST_VERSION? [y/N] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "❌ Update cancelled"
  rm -rf "$TMP_DIR"
  exit 0
fi

echo ""
echo "🔄 Updating skills..."

# Backup current skills
BACKUP_DIR="$SKILLS_DIR.backup-$(date +%Y%m%d-%H%M%S)"
cp -r "$SKILLS_DIR" "$BACKUP_DIR"
echo "💾 Backup created: $BACKUP_DIR"

# Remove old skills
rm -rf "$SKILLS_DIR"/*
rm -rf "$DOCS_DIR"/*

# Install new version
mkdir -p "$SKILLS_DIR"
mkdir -p "$DOCS_DIR"

# Copy all skills
for skill_dir in skills/*; do
  if [ -d "$skill_dir" ]; then
    cp -r "$skill_dir" "$SKILLS_DIR/"
  fi
done

# Copy documentation
cp -r showroom/.claude/docs/* "$DOCS_DIR/" 2>/dev/null || true
cp -r agnosticv/.claude/docs/* "$DOCS_DIR/" 2>/dev/null || true

# Copy prompts and templates to each skill
for skill in "$SKILLS_DIR"/showroom-*; do
  mkdir -p "$skill"/.claude/{prompts,templates}
  cp -r showroom/prompts/* "$skill/.claude/prompts/" 2>/dev/null || true
  cp -r showroom/templates/* "$skill/.claude/templates/" 2>/dev/null || true
done

for skill in "$SKILLS_DIR"/agnosticv-*; do
  mkdir -p "$skill"/.claude/docs
  cp -r agnosticv/.claude/docs/* "$skill/.claude/docs/" 2>/dev/null || true
done

# Save version
echo "$LATEST_VERSION" > "$VERSION_FILE"

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo ""
echo "✅ Update complete!"
echo ""
echo "Updated from: $CURRENT_VERSION"
echo "         to: $LATEST_VERSION"
echo ""
echo "Backup location: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "  1. Restart Cursor completely (Cmd+Q / Ctrl+Q)"
echo "  2. Open Cursor"
echo "  3. Type / in Agent chat to see updated skills"
echo ""
