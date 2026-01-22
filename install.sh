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
REPO_URL="https://github.com/rhpds/rhdp-skills-marketplace.git"

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
      echo "  --namespace <name>   Install specific namespace (showroom, agnosticv, health, all)"
      echo "  --platform <name>    Specify platform (claude, cursor)"
      echo "  --dry-run            Show what would be installed without making changes"
      echo "  --force              Force installation even if already installed"
      echo "  --help               Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                                    # Interactive installation"
      echo "  $0 --namespace showroom              # Install showroom namespace only"
      echo "  $0 --platform claude --namespace all # Install all for Claude Code"
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
  echo "  1) Claude Code"
  echo "  2) Cursor"
  echo ""
  read -p "Enter your choice [1-2]: " choice

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
  echo "  1) showroom (Recommended for content creators)"
  echo "     └─ Skills: create-lab, create-demo, verify-content, blog-generate"
  echo ""
  echo "  2) agnosticv (RHDP internal/advanced - Catalog provisioning)"
  echo "     └─ Skills: agv-generator, agv-validator, generate-agv-description"
  echo ""
  echo "  3) health (RHDP internal/advanced - Post-deployment validation)"
  echo "     └─ Skills: validation-role-builder"
  echo ""
  echo "  4) all (Install all namespaces)"
  echo ""
  read -p "Enter your choice [1-4]: " choice

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

# Clone repository
clone_repo() {
  local temp_dir=$(mktemp -d)

  if [[ "$DRY_RUN" == true ]]; then
    print_msg "$YELLOW" "[DRY RUN] Would clone $REPO_URL to $temp_dir" >&2
    echo "$temp_dir"
    return
  fi

  print_msg "$BLUE" "Cloning repository..." >&2
  git clone --quiet "$REPO_URL" "$temp_dir" >&2
  print_msg "$GREEN" "✓ Repository cloned" >&2
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
    echo "  • /agv-generator            - Create catalog items"
    echo "  • /agv-validator            - Validate catalogs"
    echo "  • /generate-agv-description - Generate descriptions"
  fi

  if [[ "$NAMESPACE" == "health" ]] || [[ "$NAMESPACE" == "all" ]]; then
    echo ""
    print_msg "$BLUE" "Health (Post-Deployment Validation):"
    echo "  • /validation-role-builder  - Create validation roles"
  fi

  echo ""
  print_msg "$CYAN" "Next Steps:"

  if [[ "$PLATFORM" == "claude" ]]; then
    echo "  1. Restart Claude Code to load the new skills"
    echo "  2. Try running a skill, e.g., /create-lab"
    echo "  3. Check for updates periodically with update.sh"
  else
    print_msg "$YELLOW" "  ⚠️  Cursor Users - Important!"
    echo ""
    echo "  Agent Skills support in Cursor is experimental (not ready for primetime)."
    echo "  Skills may not work directly in Cursor stable/Enterprise."
    echo ""
    echo "  Recommended: Use .cursorrules approach instead"
    echo "  1. Copy .cursorrules template to your project:"
    echo "     cp ~/work/code/rhdp-skills-marketplace/cursor-rules/.cursorrules.showroom .cursorrules"
    echo "  2. See cursor-rules/README.md for full instructions"
    echo "  3. Restart Cursor and ask naturally (e.g., 'create a workshop lab')"
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
    read -p "Continue? [Y/n] " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
      print_msg "$RED" "Installation cancelled."
      exit 0
    fi
    echo ""
  fi

  # Perform installation
  backup_existing

  local repo_dir=$(clone_repo)

  if [[ "$NAMESPACE" == "all" ]]; then
    install_namespace "$repo_dir" "showroom"
    install_namespace "$repo_dir" "agnosticv"
    install_namespace "$repo_dir" "health"
  else
    install_namespace "$repo_dir" "$NAMESPACE"
  fi

  save_version "$repo_dir"

  # Cleanup
  if [[ "$DRY_RUN" == false ]]; then
    rm -rf "$repo_dir"
  fi

  show_success
}

# Run installer
main
