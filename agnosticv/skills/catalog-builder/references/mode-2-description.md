# Mode 2: Description Only

## MODE 2: Description Only

**When selected:** User chose option 2 (Description Only)

**Simplified workflow - just extract from Showroom and generate description.adoc**

### Step 1: Locate Showroom

**Ask directly for the path. DO NOT ask about GitHub org or try to find it yourself:**

```
📚 Showroom Content

Q: What is the path to your Showroom repository?

   💡 TIP: Use local paths to avoid GitHub API rate limits

   If you provide a GitHub URL, I'll need to clone it first.
   Local paths are faster and don't hit GitHub rate limits.

   Examples:
   - /Users/you/work/my-workshop-showroom (Recommended - local path)
   - ~/work/showroom-content/my-workshop (Recommended - local path)
   - . (current directory)
   - https://github.com/rhpds/my-workshop-showroom (Will clone locally first)

Path:
```

**If user provides GitHub URL:**
```
⚠️  GitHub URL Detected

You provided: <github-url>

GitHub API rate limits can cause issues. I'll clone this repository locally first.

Clone to: /tmp/showroom-<random>/

Proceed? [Y/n]
```

**If Yes:**
```bash
temp_dir=$(mktemp -d "/tmp/showroom-XXXXX")
git clone <github-url> "$temp_dir"

# Use temp_dir as path for rest of workflow
path="$temp_dir"
```

**If No:**
```
Q: Please provide a local path to your Showroom repository instead:

Local path:
```

**Validate:**
```bash
if [[ -d "$path/content/modules/ROOT/pages" ]]; then
  echo "✓ Found Showroom content"
  HAS_SHOWROOM=true
else
  echo "✗ No Showroom content found at: $path/content/modules/ROOT/pages"
  HAS_SHOWROOM=false
fi
```

**If no Showroom found, offer manual entry:**
```
⚠️  No Showroom Content Found

Mode 2 works best when you have Showroom content to extract from.

Options:
1. Enter description details manually (I'll ask you questions)
2. Create Showroom content first and come back
3. Exit and use Mode 1 (Full Catalog) instead

Your choice [1/2/3]:
```

**If option 2 (Create Showroom first):**
```
📚 Create Showroom Content First

Use the /create-lab or /create-demo skills to generate Showroom content:

For workshops:
  /create-lab

For demos:
  /create-demo

Once you have Showroom content, run this skill again with Mode 2.

⏸️  Exiting - Create Showroom content first.
```

**If option 3 (Use Mode 1):**
```
ℹ️  Mode 1 (Full Catalog) creates everything including description.adoc

Re-run this skill and select Mode 1 at the beginning.

⏸️  Exiting
```

**If option 1 (Manual entry), continue to Step 1a**

---

### Step 1a: Manual Entry (When No Showroom)

**Only run this step if HAS_SHOWROOM=false and user chose manual entry**

```
📝 Manual Description Entry (RHDP Structure)

Since you don't have Showroom content, I'll ask for all the details needed for description.adoc.
```

**1. Brief Overview (3-4 sentences max):**
```
Q: Brief overview (3-4 sentences):
   - Sentence 1: What is this showing or doing?
   - Sentence 2-3: What is the intended use? Business context?
   - Sentence 4: What do learners do/deploy?
   - Do NOT mention catalog name or generic info

   Example: "vLLM Playground demonstrates deploying and managing vLLM inference servers using containers with features like structured outputs and tool calling. This demo uses the ACME Corporation customer support scenario to show how Red Hat AI Inference Server modernizes AI-powered infrastructure. Learners deploy vLLM servers, configure structured outputs, and implement agentic workflows with performance benchmarking."

Overview:
```

**2. Warnings (optional):**
```
Q: Any warnings or special requirements? (optional)
   Examples: "GPU-enabled nodes recommended for optimal performance"
             "Beta release - features subject to change"
             "High memory usage - 32GB RAM minimum"

Warnings [press Enter to skip]:
```

**3. Guide Link:**
```
Q: Lab/Demo Guide URL:
   - Link to rendered Showroom (preferred)
   - Or link to repo/document if no Showroom yet

   Example: https://rhpds.github.io/my-workshop-showroom

Guide URL:
```

**4. Featured Products (max 3-4):**
```
Q: Featured Technology and Products (max 3-4, ONLY what matters):
   List the products that are the FOCUS of this asset with major versions.
   Do NOT list every product - only what matters.

   Example: "Red Hat Enterprise Linux 10, vLLM Playground 0.1.1, Red Hat AI"

Products [comma-separated with versions]:
```

**5. Module Details:**
```
Q: How many modules/chapters are in this lab/demo?

Module count:
```

**For each module, ask:**
```bash
for ((i=1; i<=module_count; i++)); do
  echo ""
  echo "=== Module $i Details ==="
  echo ""
  echo "Q: Module $i title:"
  read module_title

  echo ""
  echo "Q: Module $i details (2-3 bullets max, what do learners do?):"
  echo "   Enter bullets one per line, press Enter twice when done"
  echo ""

  bullets=()
  while IFS= read -r line; do
    [[ -z "$line" ]] && break
    bullets+=("$line")
  done

  # Store module data
  module_data["$i"]="$module_title|${bullets[*]}"
done
```

**6. Authors:**
```
Q: Lab/Demo authors (from __meta__.owners or manual entry):
   If this catalog has a common.yaml, I'll extract from __meta__.owners.
   Otherwise, enter author names (one per line, press Enter twice when done):

Authors:
```

**Capture authors:**
```bash
authors=()
while IFS= read -r line; do
  [[ -z "$line" ]] && break
  authors+=("$line")
done
```

**7. Support Information:**
```
Q: Content support Slack channel (where users get help with instructions):
   Example: #my-lab-support

Content Slack channel:

Q: Author Slack handle (to tag for content questions):
   Example: @john-smith

Author Slack handle:

Q: Author email (alternative to Slack):
   Example: jsmith@redhat.com

Author email [optional]:
```

**Set variables for Step 3:**
```bash
# For manual entry, set these variables
brief_overview="$overview_input"
warnings="$warnings_input"
guide_url="$guide_url_input"
featured_products="$products_input"
module_details=("${module_data[@]}")
authors=("${authors[@]}")
content_slack_channel="$content_slack_input"
author_slack_handle="$author_slack_handle_input"
author_email="$author_email_input"

# Skip Step 2 (extraction) and go directly to Step 3 (generate)
```

### Step 2: Extract Content from Showroom

**Only run this step if HAS_SHOWROOM=true (skip if manual entry)**

**IMPORTANT: Read ALL modules locally from filesystem to avoid GitHub rate limits**

GitHub API can hit rate limits when fetching files. Instead, we read all modules directly from the local filesystem, which is:
- ✅ Faster (no network calls)
- ✅ No rate limits
- ✅ Works offline
- ✅ Reads ALL modules comprehensively

**Read ALL modules and extract comprehensive information:**
```bash
# Get ALL modules from local filesystem (ensure we don't miss any)
# This reads files directly - NO GitHub API calls, NO rate limits
modules=$(find "$path/content/modules/ROOT/pages" -type f -name "*.adoc" \
  -not -name "index.adoc" \
  -not -name "*nav.adoc" \
  -not -name "workshop-overview.adoc" | sort)

# Count modules
module_count=$(echo "$modules" | grep -c "\.adoc$")

# Extract and display all module titles
echo "📚 Reading $module_count modules:"
module_titles=()
while IFS= read -r module; do
  if [[ -f "$module" ]]; then
    title=$(grep "^= " "$module" | head -1 | sed 's/^= //')
    echo "  * $title ($(basename "$module"))"
    module_titles+=("$title")
  fi
done <<< "$modules"

# Read ALL modules for comprehensive content extraction
echo ""
echo "📖 Analyzing all module content from local files..."
echo "   (Reading from filesystem - no GitHub API, no rate limits)"

# Combine all module content from local files (excluding index/nav)
# Direct file reading - fast, no network, no API limits
all_content=$(cat "$path/content/modules/ROOT/pages"/*.adoc 2>/dev/null | grep -v "^include::" | grep -v "^::")

# Extract overview from index.adoc first
if [[ -f "$path/content/modules/ROOT/pages/index.adoc" ]]; then
  index_overview=$(awk '
    /^= / { in_content=1; next }
    in_content && /^:/ { next }
    in_content && /^$/ { next }
    in_content && /^[A-Z]/ {
      print;
      for(i=1; i<=3; i++) {
        getline;
        if ($0 != "") print;
      }
      exit
    }
  ' "$path/content/modules/ROOT/pages/index.adoc" 2>/dev/null)
fi

# Extract key learning objectives from all modules
learning_objectives=$(echo "$all_content" | grep -E "learn|understand|configure|deploy|create|build|integrate|automate" | grep -v "^#" | head -10)

# Detect Red Hat product names across ALL modules
detected_products=$(echo "$all_content" | grep -hoE '(Red Hat )?OpenShift (Container Platform|Virtualization|AI|GitOps|Pipelines|Data Foundation)?|Ansible Automation Platform|(Red Hat )?Ansible( AI)?|Red Hat Enterprise Linux|RHEL [0-9.]+|Red Hat Device Edge|Red Hat Insights|Advanced Cluster Management|ACM|Red Hat Quay|Red Hat OpenShift Service Mesh|Red Hat AMQ|Red Hat Integration|Red Hat build of Keycloak|Red Hat OpenShift Data Foundation|Red Hat Advanced Cluster Security' 2>/dev/null | sort -u | head -15)

# Extract version numbers mentioned across ALL modules
version_info=$(echo "$all_content" | grep -hoE '(OpenShift|Ansible|RHEL|AAP|Kubernetes) [0-9]+\.[0-9]+|version [0-9]+\.[0-9]+' 2>/dev/null | sort -u | head -8)

# Detect key technical topics across ALL modules
technical_topics=$(echo "$all_content" | grep -hoE 'GitOps|CI/CD|Kubernetes|Operators|Helm|Service Mesh|Serverless|Tekton|ArgoCD|Prometheus|Grafana|Storage|Networking|Security|Multi-cluster' 2>/dev/null | sort -u | head -10)

# Get git author
author=$(git -C "$path" config user.name 2>/dev/null || echo "Unknown")

# Get GitHub Pages URL from remote
remote=$(git -C "$path" remote get-url origin 2>/dev/null)
if [[ -n "$remote" ]]; then
  github_pages_url=$(echo "$remote" | sed 's|git@github.com:|https://|' | sed 's|\.git$|/|' | sed 's|github.com/|rhpds.github.io/|')
else
  github_pages_url=""
fi

echo ""
echo "📊 Extracted from ALL modules (read from local filesystem):"
echo "  ✓ Modules analyzed: $module_count (all read locally - no GitHub API used)"
echo "  ✓ Module titles:"
for title in "${module_titles[@]}"; do
  echo "    - $title"
done
echo "  ✓ Author: $author"
echo "  ✓ GitHub Pages: $github_pages_url"
echo "  ✓ Red Hat Products detected:"
echo "$detected_products" | while read product; do
  [[ -n "$product" ]] && echo "    - $product"
done
if [[ -n "$version_info" ]]; then
  echo "  ✓ Versions found:"
  echo "$version_info" | while read version; do
    [[ -n "$version" ]] && echo "    - $version"
  done
fi
if [[ -n "$technical_topics" ]]; then
  echo "  ✓ Technical topics:"
  echo "$technical_topics" | while read topic; do
    [[ -n "$topic" ]] && echo "    - $topic"
  done
fi
```

### Step 3: Generate Description

**If HAS_SHOWROOM=true (extracted from Showroom):**

**Review comprehensive extracted content from ALL modules:**
```
📝 Description Content Review

I've read ALL $module_count modules locally (from filesystem - no GitHub API, no rate limits) and extracted the following:

Module Structure:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${module_titles[@]}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overview (from index.adoc):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$index_overview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Red Hat Products Detected (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$detected_products
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Versions Found (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$version_info
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Technical Topics (from all modules):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$technical_topics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q: Is the extracted overview accurate? [Y to use as-is / N to provide custom]:

If N:
Q: Provide a brief overview (2-3 sentences, starting with product name):
   Base it on the module titles and content above.

Custom overview:

Q: Are the detected products/technologies/versions correct? [Y to use / N to customize]:

If N:
Q: Featured technologies (comma-separated with versions):
   Example: OpenShift 4.14, Ansible Automation Platform 2.5, Red Hat Enterprise Linux 9

   Detected: $detected_products $version_info

Custom technologies:

Q: Any warnings or special requirements? (optional)
   Examples: "Requires GPU nodes", "High memory usage", "Network-intensive"
   Based on: $technical_topics

Warnings [optional]:
```

**IMPORTANT:**
- ALL modules have been read and analyzed, not just index.adoc
- If user says Yes to extracted content, use it directly. Don't ask again!
- Show comprehensive data from all modules so user can make informed decisions
- Module titles, products, versions, and topics are extracted from the entire workshop content

---

**If HAS_SHOWROOM=false (manual entry):**

**Review manually entered content:**
```
📝 Description Content Review

You entered the following information:

Display Name:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$display_name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Overview:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$index_overview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Technologies:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$detected_products
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Modules ($module_count):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
${module_titles[@]}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Author: $author
GitHub Pages: ${github_pages_url:-"Not provided"}
Warnings: ${warnings:-"None"}

Q: Is this information correct? [Y to proceed / N to edit]:

If N, allow editing:
  Q: What would you like to edit?
     1. Overview
     2. Technologies
     3. Modules
     4. All of the above

  Choice [1-4]:
```

**After confirmation, proceed to generate description.adoc**

---

**Generate and write description.adoc** (same format as Mode 1, Step 10.3)

### Step 4: Locate Output Directory

**Ask directly for the path. DO NOT try to auto-detect, search, or ask about subdirectories:**

```
📂 Output Location

Q: What is the path to the catalog/CI directory where I should save description.adoc?

   Just provide the full path - I'll save the file there directly.

   Examples:
   - ~/work/code/agnosticv/agd_v2/my-workshop
   - /Users/you/code/agnosticv/catalogs/demo-catalog
   - agd_v2/my-catalog (relative to AgV repo)

Path:
```

**Write file and optionally commit** (same as Mode 1, Step 12)

---

