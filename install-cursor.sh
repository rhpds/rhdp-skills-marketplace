#!/bin/bash

# Install RHDP Skills for Cursor
# Simple one-command installation

set -e

SKILLS_DIR="$HOME/.cursor/skills"
DOCS_DIR="$HOME/.cursor/docs"
REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace.git"
TMP_DIR="/tmp/rhdp-skills-install-$$"

echo "════════════════════════════════════════════════════"
echo "  RHDP Skills Marketplace - Cursor Installation"
echo "════════════════════════════════════════════════════"
echo ""

# Clone repo
echo "📥 Cloning marketplace..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"
cd "$TMP_DIR"

# Create directories
echo "📁 Creating directories..."
mkdir -p "$SKILLS_DIR"
mkdir -p "$DOCS_DIR"

# Copy all skills
echo "📦 Installing 7 skills..."
for skill_dir in skills/*; do
  if [ -d "$skill_dir" ]; then
    cp -r "$skill_dir" "$SKILLS_DIR/"
  fi
done

# Copy documentation
echo "📚 Installing documentation..."
cp -r showroom/.claude/docs/* "$DOCS_DIR/" 2>/dev/null || true
cp -r agnosticv/.claude/docs/* "$DOCS_DIR/" 2>/dev/null || true

# Copy prompts and templates to each skill
echo "🔧 Bundling support files..."
for skill in "$SKILLS_DIR"/showroom-*; do
  mkdir -p "$skill"/.claude/{prompts,templates}
  cp -r showroom/prompts/* "$skill/.claude/prompts/" 2>/dev/null || true
  cp -r showroom/templates/* "$skill/.claude/templates/" 2>/dev/null || true
done

for skill in "$SKILLS_DIR"/agnosticv-*; do
  mkdir -p "$skill"/.claude/docs
  cp -r agnosticv/.claude/docs/* "$skill/.claude/docs/" 2>/dev/null || true
done

# Cleanup
cd /
rm -rf "$TMP_DIR"

echo ""
echo "✅ Installation complete!"
echo ""
echo "Installed skills:"
echo "  • showroom-create-lab"
echo "  • showroom-create-demo"
echo "  • showroom-blog-generate"
echo "  • showroom-verify-content"
echo "  • agnosticv-catalog-builder"
echo "  • agnosticv-validator"
echo "  • health-deployment-validator"
echo ""
echo "Next steps:"
echo "  1. Restart Cursor completely (Cmd+Q / Ctrl+Q)"
echo "  2. Open Cursor"
echo "  3. Type / in Agent chat to see skills"
echo ""
echo "Skills location: $SKILLS_DIR"
echo "Docs location: $DOCS_DIR"
echo ""
