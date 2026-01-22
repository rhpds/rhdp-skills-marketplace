#!/bin/bash

# RHDP Skills Marketplace Installer
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
DRY_RUN=false
NAMESPACE=""
PLATFORM=""
FORCE=false
REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace"
GITHUB_API_URL="https://api.github.com/repos/rhpds/rhdp-skills-marketplace/releases/latest"

# Installation paths (will be set based on platform)
SKILLS_DIR=""
DOCS_DIR=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --namespace <name>   Install specific namespace"
      echo "                       showroom  - Create demos and workshops (most users)"
      echo "                       agnosticv - RHDP internal catalog work"
      echo "                       health    - RHDP internal deployment validation"
      echo "                       all       - Install everything"
      echo ""
      echo "  --platform <name>    Specify platform"
      echo "                       claude - Claude Code (CLI) or VS Code with Claude extension"
      echo "                       cursor - Cursor IDE (experimental)"
      echo ""
      echo "  --dry-run            Show what would be installed without making changes"
      echo "  --force              Force installation even if already installed"
      echo "  --help               Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                                    # Interactive (recommended)"
      echo "  $0 --namespace showroom               # Just demo/workshop skills"
      echo "  $0 --platform claude --namespace all  # Everything for Claude Code"
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
  print_msg "$CYAN" "  RHDP Skills Marketplace Installer"
  print_msg "$CYAN" "═══════════════════════════════════════════════════════════"
  echo ""
}

# Detect platform
detect_platform() {
  if [[ -n "$PLATFORM" ]]; then
    return
  fi

  print_msg "$BLUE" "Which AI coding assistant are you using?"
  echo ""
  echo "  1) Claude Code or VS Code with Claude extension (Recommended - Native support)"
  echo "  2) Cursor (Experimental - Still testing, may not work reliably)"
  echo ""
  read -p "Enter your choice [1-2]: " choice < /dev/tty

  case $choice in
    1)
      PLATFORM="claude"
      ;;
    2)
      PLATFORM="cursor"
      ;;
    *)
      print_msg "$RED" "Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

# Set installation paths based on platform
set_installation_paths() {
  case $PLATFORM in
    claude)
      SKILLS_DIR="$HOME/.claude/skills"
      DOCS_DIR="$HOME/.claude/docs"
      print_msg "$GREEN" "✓ Platform: Claude Code"
      ;;
    cursor)
      SKILLS_DIR="$HOME/.cursor/skills"
      DOCS_DIR="$HOME/.cursor/docs"
      print_msg "$GREEN" "✓ Platform: Cursor"
      ;;
    *)
      print_msg "$RED" "Unknown platform: $PLATFORM"
      exit 1
      ;;
  esac

  echo "  Skills directory: $SKILLS_DIR"
  echo "  Docs directory: $DOCS_DIR"
  echo ""
}

# Check prerequisites
check_prerequisites() {
  print_msg "$BLUE" "Checking prerequisites..."

  if ! command -v git &> /dev/null; then
    print_msg "$RED" "✗ Git is not installed. Please install git first."
    exit 1
  fi
  print_msg "$GREEN" "✓ Git is installed"
  echo ""
}

# Select namespace
select_namespace() {
  if [[ -n "$NAMESPACE" ]]; then
    return
  fi

  print_msg "$BLUE" "Which namespace would you like to install?"
  echo ""
  echo "  📚 For creating demos/workshops (most users):"
  echo "  1) showroom"
  echo "     Create presenter-led demos and hands-on workshops"
  echo "     Skills: create-lab, create-demo, verify-content, blog-generate"
  echo ""
  echo "  ⚙️  For RHDP internal team:"
  echo "  2) agnosticv"
  echo "     Catalog provisioning and infrastructure deployment"
  echo "     Skills: agnosticv-catalog-builder, agnosticv-validator"
  echo ""
  echo "  3) health"
  echo "     Post-deployment validation and health checks"
  echo "     Skills: deployment-health-checker"
  echo ""
  echo "  4) all"
  echo "     Install everything (showroom + agnosticv + health)"
  echo ""
  read -p "Enter your choice [1-4]: " choice < /dev/tty

  case $choice in
    1)
      NAMESPACE="showroom"
      ;;
    2)
      NAMESPACE="agnosticv"
      ;;
    3)
      NAMESPACE="health"
      ;;
    4)
      NAMESPACE="all"
      ;;
    *)
      print_msg "$RED" "Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

# Backup existing skills
backup_existing() {
  if [[ ! -d "$SKILLS_DIR" ]]; then
    print_msg "$BLUE" "No existing skills directory found. Skipping backup."
    return
  fi

  local backup_dir="$SKILLS_DIR-backup-$(date +%Y%m%d-%H%M%S)"

  if [[ "$DRY_RUN" == true ]]; then
    print_msg "$YELLOW" "[DRY RUN] Would backup $SKILLS_DIR to $backup_dir"
    return
  fi

  print_msg "$BLUE" "Backing up existing skills..."
  cp -r "$SKILLS_DIR" "$backup_dir"
  print_msg "$GREEN" "✓ Backup created: $backup_dir"
  echo ""
}

# Download latest release
download_release() {
  local temp_dir=$(mktemp -d)

  if [[ "$DRY_RUN" == true ]]; then
    print_msg "$YELLOW" "[DRY RUN] Would download latest release to $temp_dir" >&2
    echo "$temp_dir"
    return
  fi

  print_msg "$BLUE" "Fetching latest release..." >&2

  # Get latest release info from GitHub API
  local release_info
  if ! release_info=$(curl -s "$GITHUB_API_URL" 2>/dev/null); then
    print_msg "$YELLOW" "⚠️  Could not fetch release info from GitHub API, falling back to main branch" >&2
    git clone --quiet --depth 1 "${REPO_URL}.git" "$temp_dir" >&2
    print_msg "$GREEN" "✓ Repository downloaded" >&2
    echo "" >&2
    echo "$temp_dir"
    return
  fi

  # Extract tarball URL and tag name
  local tarball_url=$(echo "$release_info" | grep -o '"tarball_url": "[^"]*' | cut -d'"' -f4)
  local tag_name=$(echo "$release_info" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

  if [[ -z "$tarball_url" ]]; then
    print_msg "$YELLOW" "⚠️  No releases found, falling back to main branch" >&2
    git clone --quiet --depth 1 "${REPO_URL}.git" "$temp_dir" >&2
    print_msg "$GREEN" "✓ Repository downloaded" >&2
    echo "" >&2
    echo "$temp_dir"
    return
  fi

  print_msg "$BLUE" "Downloading release $tag_name..." >&2

  # Download and extract tarball
  curl -sL "$tarball_url" | tar xz -C "$temp_dir" --strip-components=1

  print_msg "$GREEN" "✓ Release $tag_name downloaded" >&2
  echo "" >&2

  echo "$temp_dir"
}

# Install namespace
install_namespace() {
  local repo_dir=$1
  local ns=$2

  print_msg "$BLUE" "Installing $ns namespace..."

  # Create directories
  if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$SKILLS_DIR"
    mkdir -p "$DOCS_DIR"
  fi

  # Copy skills
  if [[ -d "$repo_dir/$ns/skills" ]]; then
    for skill in "$repo_dir/$ns/skills"/*; do
      if [[ -d "$skill" ]]; then
        local skill_name=$(basename "$skill")
        if [[ "$DRY_RUN" == true ]]; then
          print_msg "$YELLOW" "  [DRY RUN] Would install skill: $skill_name"
        else
          cp -r "$skill" "$SKILLS_DIR/$skill_name"
          print_msg "$GREEN" "  ✓ Installed skill: $skill_name"
        fi
      fi
    done
  fi

  # Copy docs
  if [[ -d "$repo_dir/$ns/docs" ]]; then
    for doc in "$repo_dir/$ns/docs"/*; do
      if [[ -f "$doc" ]]; then
        local doc_name=$(basename "$doc")
        if [[ "$DRY_RUN" == true ]]; then
          print_msg "$YELLOW" "  [DRY RUN] Would install doc: $doc_name"
        else
          cp "$doc" "$DOCS_DIR/$doc_name"
          print_msg "$GREEN" "  ✓ Installed doc: $doc_name"
        fi
      fi
    done
  fi

  echo ""
}

# Save version info
save_version() {
  local repo_dir=$1
  local version_file="$SKILLS_DIR/.rhdp-marketplace-version"

  if [[ "$DRY_RUN" == true ]]; then
    print_msg "$YELLOW" "[DRY RUN] Would save version info to $version_file"
    return
  fi

  local version=$(cat "$repo_dir/VERSION")
  local timestamp=$(date +%Y-%m-%d)
  echo "$version|$NAMESPACE|$PLATFORM|$timestamp" > "$version_file"
}

# Install Cursor rules to current directory
install_cursor_rules() {
  local repo_dir=$1

  # Only install rules for Cursor platform
  if [[ "$PLATFORM" != "cursor" ]]; then
    return
  fi

  print_msg "$BLUE" "Installing Cursor rules to current directory..."

  local cursor_rules_src="$repo_dir/cursor-rules/.cursor/rules"
  local cursor_rules_dest=".cursor/rules"

  if [[ "$DRY_RUN" == true ]]; then
    print_msg "$YELLOW" "[DRY RUN] Would copy $cursor_rules_src to $cursor_rules_dest"
    return
  fi

  # Check if .cursor/rules already exists
  if [[ -d "$cursor_rules_dest" ]]; then
    print_msg "$YELLOW" "⚠️  .cursor/rules already exists in current directory"
    read -p "Overwrite? [y/N] " overwrite < /dev/tty
    if [[ ! "$overwrite" =~ ^[Yy] ]]; then
      print_msg "$BLUE" "Skipping .cursor/rules installation"
      echo ""
      return
    fi
    rm -rf "$cursor_rules_dest"
  fi

  # Copy .cursor/rules to current directory
  mkdir -p .cursor
  cp -r "$cursor_rules_src" "$cursor_rules_dest"
  print_msg "$GREEN" "✓ Installed .cursor/rules to current directory"
  echo ""
}

# Show success message
show_success() {
  print_msg "$GREEN" "═══════════════════════════════════════════════════════════"
  print_msg "$GREEN" "  Installation Complete!"
  print_msg "$GREEN" "═══════════════════════════════════════════════════════════"
  echo ""

  print_msg "$CYAN" "Installed Skills:"

  if [[ "$NAMESPACE" == "showroom" ]] || [[ "$NAMESPACE" == "all" ]]; then
    echo ""
    print_msg "$BLUE" "Showroom (Content Creation):"
    echo "  • /create-lab        - Generate workshop lab modules"
    echo "  • /create-demo       - Generate presenter-led demos"
    echo "  • /verify-content    - Quality validation"
    echo "  • /blog-generate     - Transform to blog posts"
  fi

  if [[ "$NAMESPACE" == "agnosticv" ]] || [[ "$NAMESPACE" == "all" ]]; then
    echo ""
    print_msg "$BLUE" "AgnosticV (RHDP Provisioning):"
    echo "  • /agnosticv-catalog-builder - Create/update catalogs"
    echo "  • /agnosticv-validator             - Validate catalogs"
  fi

  if [[ "$NAMESPACE" == "health" ]] || [[ "$NAMESPACE" == "all" ]]; then
    echo ""
    print_msg "$BLUE" "Health (Post-Deployment Validation):"
    echo "  • /deployment-health-checker - Create validation roles"
    echo "  • /ftl                     - Automated grader/solver generation"
  fi

  echo ""
  print_msg "$CYAN" "Next Steps:"

  if [[ "$PLATFORM" == "claude" ]]; then
    echo "  1. Restart Claude Code (or VS Code) to load the new skills"
    echo "  2. Try running a skill, e.g., /create-lab"
    echo "  3. Check for updates periodically with update.sh"
  else
    print_msg "$YELLOW" "  ⚠️  Cursor Users - Important!"
    echo ""
    echo "  Agent Skills in Cursor are experimental and we're still testing."
    echo "  Skills may not work reliably. Claude Code is the recommended platform."
    echo ""
    echo "  ✓ Skills installed to: ~/.cursor/skills/"
    echo "  ✓ Docs installed to: ~/.cursor/docs/"
    echo "  ✓ Rules installed to: .cursor/rules/ (current directory)"
    echo ""
    echo "  To use skills in Cursor stable/Enterprise:"
    echo "  1. Restart Cursor in this directory"
    echo ""
    echo "  2. Ask naturally using trigger phrases:"
    echo "     - 'create lab' (triggers create-lab skill)"
    echo "     - 'create demo' (triggers create-demo skill)"
    echo "     - 'validate agv' (triggers agnosticv-validator skill)"
    echo ""
    echo "  3. For other projects, copy .cursor/rules:"
    echo "     cp -r .cursor/rules /path/to/other/project/.cursor/"
    echo ""
    echo "  See: cursor-rules/README.md for full documentation"
    echo ""
    echo "  Alternative: Try Nightly channel (Settings > Beta > Update Channel)"
    echo "  See: https://forum.cursor.com/t/support-for-claude-skills/148267"
  fi

  echo ""
  print_msg "$CYAN" "Documentation:"
  echo "  https://github.com/rhpds/rhdp-skills-marketplace"
  echo ""
}

# Main installation flow
main() {
  print_header

  # Interactive prompts
  detect_platform
  set_installation_paths
  check_prerequisites
  select_namespace

  # Confirm installation
  if [[ "$DRY_RUN" == false ]]; then
    echo ""
    print_msg "$YELLOW" "Ready to install $NAMESPACE namespace for $PLATFORM"
    read -p "Continue? [Y/n] " confirm < /dev/tty
    if [[ "$confirm" =~ ^[Nn] ]]; then
      print_msg "$RED" "Installation cancelled."
      exit 0
    fi
    echo ""
  fi

  # Perform installation
  backup_existing

  local repo_dir=$(download_release)

  if [[ "$NAMESPACE" == "all" ]]; then
    install_namespace "$repo_dir" "showroom"
    install_namespace "$repo_dir" "agnosticv"
    install_namespace "$repo_dir" "health"
  else
    install_namespace "$repo_dir" "$NAMESPACE"
  fi

  save_version "$repo_dir"

  # Install Cursor rules to current directory (Cursor only)
  install_cursor_rules "$repo_dir"

  # Cleanup
  if [[ "$DRY_RUN" == false ]]; then
    rm -rf "$repo_dir"
  fi

  show_success
}

# Run installer
main
