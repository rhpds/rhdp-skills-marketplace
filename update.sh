#!/bin/bash

# RHDP Skills Marketplace Updater
# Supports: Claude Code, Cursor
# Repository: https://github.com/rhpds/rhdp-skills-marketplace

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
FORCE=false
REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace"
GITHUB_API_URL="https://api.github.com/repos/rhpds/rhdp-skills-marketplace/releases/latest"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/install.sh"

# Installation paths (will be detected)
SKILLS_DIR=""
VERSION_FILE=""
CURRENT_VERSION=""
CURRENT_NAMESPACE=""
CURRENT_PLATFORM=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --force    Force update even if already on latest version"
      echo "  --help     Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0          # Check for updates and prompt to install"
      echo "  $0 --force  # Force update to latest version"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run with --help for usage information"
      exit 1
      ;;
  esac
done

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
  print_msg "$CYAN" "  RHDP Skills Marketplace Updater"
  print_msg "$CYAN" "═══════════════════════════════════════════════════════════"
  echo ""
}

# Detect installation
detect_installation() {
  print_msg "$BLUE" "Detecting current installation..."

  # Try Claude Code first
  if [[ -f "$HOME/.claude/skills/.rhdp-marketplace-version" ]]; then
    SKILLS_DIR="$HOME/.claude/skills"
    VERSION_FILE="$SKILLS_DIR/.rhdp-marketplace-version"
    CURRENT_PLATFORM="claude"
  # Try Cursor
  elif [[ -f "$HOME/.cursor/skills/.rhdp-marketplace-version" ]]; then
    SKILLS_DIR="$HOME/.cursor/skills"
    VERSION_FILE="$SKILLS_DIR/.rhdp-marketplace-version"
    CURRENT_PLATFORM="cursor"
  else
    print_msg "$RED" "✗ RHDP Skills Marketplace is not installed."
    echo ""
    print_msg "$BLUE" "To install, run:"
    echo "  curl -fsSL $INSTALL_SCRIPT_URL | bash"
    echo ""
    exit 1
  fi

  # Read version file
  if [[ -f "$VERSION_FILE" ]]; then
    local version_data=$(cat "$VERSION_FILE")
    CURRENT_VERSION=$(echo "$version_data" | cut -d'|' -f1)
    CURRENT_NAMESPACE=$(echo "$version_data" | cut -d'|' -f2)
    # Platform might not be in old version files
    if [[ $(echo "$version_data" | grep -o "|" | wc -l) -ge 2 ]]; then
      CURRENT_PLATFORM=$(echo "$version_data" | cut -d'|' -f3)
    fi
  else
    print_msg "$RED" "✗ Could not read version file."
    exit 1
  fi

  print_msg "$GREEN" "✓ Found installation"
  echo "  Platform: $CURRENT_PLATFORM"
  echo "  Current version: $CURRENT_VERSION"
  echo "  Namespace: $CURRENT_NAMESPACE"
  echo ""
}

# Check latest version
check_latest_version() {
  print_msg "$BLUE" "Checking for latest version..."

  # Get latest release from GitHub API
  local release_info
  if ! release_info=$(curl -s "$GITHUB_API_URL" 2>/dev/null); then
    print_msg "$YELLOW" "⚠️  Could not fetch release info from GitHub API, checking main branch..." >&2
    local temp_dir=$(mktemp -d)
    git clone --quiet --depth 1 "${REPO_URL}.git" "$temp_dir" 2>/dev/null
    LATEST_VERSION=$(cat "$temp_dir/VERSION")
    rm -rf "$temp_dir"
  else
    # Extract tag name from release info
    LATEST_VERSION=$(echo "$release_info" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

    if [[ -z "$LATEST_VERSION" ]]; then
      print_msg "$YELLOW" "⚠️  No releases found, checking main branch..." >&2
      local temp_dir=$(mktemp -d)
      git clone --quiet --depth 1 "${REPO_URL}.git" "$temp_dir" 2>/dev/null
      LATEST_VERSION=$(cat "$temp_dir/VERSION")
      rm -rf "$temp_dir"
    fi
  fi

  print_msg "$GREEN" "✓ Latest version: $LATEST_VERSION"
  echo ""
}

# Compare versions
compare_versions() {
  # Remove 'v' prefix for comparison
  local current="${CURRENT_VERSION#v}"
  local latest="${LATEST_VERSION#v}"

  if [[ "$current" == "$latest" ]]; then
    return 0  # Same version
  else
    return 1  # Different version
  fi
}

# Show changelog
show_changelog() {
  print_msg "$CYAN" "What's New in $LATEST_VERSION:"
  echo ""

  # Get release notes from GitHub API
  local release_info
  if release_info=$(curl -s "$GITHUB_API_URL" 2>/dev/null); then
    local release_body=$(echo "$release_info" | grep -o '"body": "[^"]*' | cut -d'"' -f4 | sed 's/\\n/\n/g' | sed 's/\\r//g')

    if [[ -n "$release_body" ]]; then
      echo "$release_body" | head -n 20
    else
      # Fallback to CHANGELOG.md if no release body
      local temp_dir=$(mktemp -d)
      git clone --quiet --depth 1 "${REPO_URL}.git" "$temp_dir" 2>/dev/null

      if [[ -f "$temp_dir/CHANGELOG.md" ]]; then
        awk "/## \[$LATEST_VERSION\]/,/## \[/{if (/## \[/ && NR!=1) exit; print}" "$temp_dir/CHANGELOG.md" | grep -v "^## \[$LATEST_VERSION\]" | head -n 20
      else
        echo "No changelog available."
      fi

      rm -rf "$temp_dir"
    fi
  else
    echo "Could not fetch changelog from GitHub."
  fi

  echo ""
}

# Perform update
perform_update() {
  print_msg "$BLUE" "Updating to $LATEST_VERSION..."
  echo ""

  # Download and run install script with current settings
  curl -fsSL "$INSTALL_SCRIPT_URL" | bash -s -- \
    --platform "$CURRENT_PLATFORM" \
    --namespace "$CURRENT_NAMESPACE" \
    --force

  print_msg "$GREEN" "✓ Update complete!"
  echo ""
}

# Main update flow
main() {
  print_header

  detect_installation
  check_latest_version

  # Compare versions
  if compare_versions && [[ "$FORCE" == false ]]; then
    print_msg "$GREEN" "✓ You are already on the latest version ($CURRENT_VERSION)"
    echo ""
    print_msg "$BLUE" "To force reinstall, run:"
    echo "  curl -fsSL https://raw.githubusercontent.com/rhpds/rhdp-skills-marketplace/main/update.sh | bash -s -- --force"
    echo ""
    exit 0
  fi

  if [[ "$FORCE" == false ]]; then
    print_msg "$YELLOW" "Update available: $CURRENT_VERSION → $LATEST_VERSION"
    echo ""
    show_changelog
  else
    print_msg "$YELLOW" "Force reinstalling version $LATEST_VERSION"
    echo ""
  fi

  # Confirm update
  read -p "Would you like to update now? [Y/n] " confirm
  if [[ "$confirm" =~ ^[Nn] ]]; then
    print_msg "$RED" "Update cancelled."
    exit 0
  fi

  echo ""
  perform_update
}

# Run updater
main
