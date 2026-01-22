#!/bin/bash

# RHDP Skills Marketplace Release Creator
# Creates a new git tag and GitHub release with changelog

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored message
print_msg() {
  local color=$1
  local msg=$2
  echo -e "${color}${msg}${NC}"
}

# Print header
print_header() {
  echo ""
  print_msg "$CYAN" "═══════════════════════════════════════════════════════════"
  print_msg "$CYAN" "  RHDP Skills Marketplace - Release Creator"
  print_msg "$CYAN" "═══════════════════════════════════════════════════════════"
  echo ""
}

# Check prerequisites
check_prerequisites() {
  print_msg "$BLUE" "Checking prerequisites..."

  # Check git
  if ! command -v git &> /dev/null; then
    print_msg "$RED" "✗ Git is not installed."
    exit 1
  fi

  # Check gh CLI
  if ! command -v gh &> /dev/null; then
    print_msg "$RED" "✗ GitHub CLI (gh) is not installed."
    print_msg "$YELLOW" "Install with: brew install gh"
    exit 1
  fi

  # Check if we're in the right repo
  if [[ ! -f "VERSION" ]] || [[ ! -f "CHANGELOG.md" ]]; then
    print_msg "$RED" "✗ Must run from rhdp-skills-marketplace root directory"
    exit 1
  fi

  # Check if we're on main branch
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$current_branch" != "main" ]]; then
    print_msg "$RED" "✗ Must be on main branch (current: $current_branch)"
    exit 1
  fi

  # Check for uncommitted changes
  if [[ -n $(git status -s) ]]; then
    print_msg "$RED" "✗ You have uncommitted changes. Commit or stash them first."
    git status -s
    exit 1
  fi

  print_msg "$GREEN" "✓ All prerequisites met"
  echo ""
}

# Get current version
get_current_version() {
  CURRENT_VERSION=$(cat VERSION | tr -d '\n')
  print_msg "$BLUE" "Current version: $CURRENT_VERSION"
}

# Prompt for new version
prompt_new_version() {
  echo ""
  print_msg "$YELLOW" "Enter new version (e.g., v1.1.0, v2.0.0):"
  read -p "> " NEW_VERSION

  # Add 'v' prefix if not present
  if [[ ! "$NEW_VERSION" =~ ^v ]]; then
    NEW_VERSION="v${NEW_VERSION}"
  fi

  # Validate version format
  if [[ ! "$NEW_VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    print_msg "$RED" "✗ Invalid version format. Use: vX.Y.Z (e.g., v1.0.0)"
    exit 1
  fi

  echo ""
  print_msg "$GREEN" "New version: $NEW_VERSION"
}

# Extract changelog for this version
extract_changelog() {
  print_msg "$BLUE" "Extracting changelog for $NEW_VERSION..."

  # Check if [Unreleased] section exists in CHANGELOG.md
  if ! grep -q "## \[Unreleased\]" CHANGELOG.md; then
    print_msg "$RED" "✗ No [Unreleased] section found in CHANGELOG.md"
    print_msg "$YELLOW" "Please add changes to CHANGELOG.md under [Unreleased] section first."
    exit 1
  fi

  # Extract unreleased changes
  CHANGELOG_CONTENT=$(awk '/## \[Unreleased\]/,/## \[/{if (/## \[/ && NR!=1) exit; print}' CHANGELOG.md | tail -n +2)

  if [[ -z "$CHANGELOG_CONTENT" ]]; then
    print_msg "$RED" "✗ [Unreleased] section is empty in CHANGELOG.md"
    print_msg "$YELLOW" "Please add changes before creating a release."
    exit 1
  fi

  echo ""
  print_msg "$CYAN" "Changelog for $NEW_VERSION:"
  echo "$CHANGELOG_CONTENT"
  echo ""
}

# Update files
update_files() {
  print_msg "$BLUE" "Updating VERSION and CHANGELOG.md..."

  # Update VERSION file
  echo "$NEW_VERSION" > VERSION

  # Update CHANGELOG.md - replace [Unreleased] with version and add new Unreleased section
  local date=$(date +%Y-%m-%d)

  # Create temporary file
  local temp_file=$(mktemp)

  # Replace [Unreleased] with version and add new Unreleased section
  awk -v version="$NEW_VERSION" -v date="$date" '
    /## \[Unreleased\]/ {
      print "## [Unreleased]"
      print ""
      print "## [" version "] - " date
      next
    }
    /\[Unreleased\]:/ {
      print "[Unreleased]: https://github.com/rhpds/rhdp-skills-marketplace/compare/" version "...HEAD"
      print "[" version "]: https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/" version
      next
    }
    { print }
  ' CHANGELOG.md > "$temp_file"

  mv "$temp_file" CHANGELOG.md

  print_msg "$GREEN" "✓ Files updated"
  echo ""
}

# Create git tag and push
create_tag() {
  print_msg "$BLUE" "Creating git tag and pushing..."

  # Commit version changes
  git add VERSION CHANGELOG.md
  git commit -m "Release $NEW_VERSION"

  # Create annotated tag
  git tag -a "$NEW_VERSION" -m "Release $NEW_VERSION"

  # Push commit and tag
  git push origin main
  git push origin "$NEW_VERSION"

  print_msg "$GREEN" "✓ Tag created and pushed"
  echo ""
}

# Create GitHub release
create_github_release() {
  print_msg "$BLUE" "Creating GitHub release..."

  # Save changelog to temp file for release notes
  local release_notes=$(mktemp)
  echo "$CHANGELOG_CONTENT" > "$release_notes"

  # Create release using gh CLI
  gh release create "$NEW_VERSION" \
    --title "Release $NEW_VERSION" \
    --notes-file "$release_notes"

  rm "$release_notes"

  print_msg "$GREEN" "✓ GitHub release created"
  echo ""
}

# Show success message
show_success() {
  print_msg "$GREEN" "═══════════════════════════════════════════════════════════"
  print_msg "$GREEN" "  Release $NEW_VERSION Created Successfully!"
  print_msg "$GREEN" "═══════════════════════════════════════════════════════════"
  echo ""
  print_msg "$CYAN" "Release URL:"
  echo "  https://github.com/rhpds/rhdp-skills-marketplace/releases/tag/$NEW_VERSION"
  echo ""
  print_msg "$CYAN" "Next steps:"
  echo "  1. Verify release on GitHub"
  echo "  2. Test install script: curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh | bash"
  echo "  3. Announce release in [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX) Slack channel"
  echo ""
}

# Main flow
main() {
  print_header
  check_prerequisites
  get_current_version
  prompt_new_version
  extract_changelog

  # Confirm
  print_msg "$YELLOW" "Ready to create release $NEW_VERSION"
  read -p "Continue? [Y/n] " confirm
  if [[ "$confirm" =~ ^[Nn] ]]; then
    print_msg "$RED" "Release cancelled."
    exit 0
  fi
  echo ""

  update_files
  create_tag
  create_github_release
  show_success
}

# Run
main
