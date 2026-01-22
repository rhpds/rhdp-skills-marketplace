## AgnosticV Configuration Assistance (Shared Contract)

**Applies to**: `/create-lab` and `/create-demo` skills

Both lab and demo skills provide intelligent AgnosticV (AgV) configuration assistance to help users find existing catalogs or create new ones following agd_v2 best practices.

### Workflow Timing

**When**: Step 2.5 - After overall story planning (Step 2), before module-specific details (Step 3)

**IMPORTANT**: This is OPTIONAL assistance - always ask first!

**CRITICAL**: If user chooses option 3 (YES to AgV help), you MUST complete the ENTIRE AgV catalog setup (create new) BEFORE proceeding to Step 3 (module creation). The module content will use variables from the AgV catalog.

### Initial Opt-In Question

**First, ask if user needs AgV help:**

```
Q: Do you need help with AgnosticV catalog configuration?

Options:
1. "No, RHDP developers already set up my catalog" → Ask for AgV access to extract UserInfo ↓
2. "No, I'll handle AgV myself" → Ask for AgV access to extract UserInfo ↓
3. "Yes, help me create a new catalog" → Continue to catalog creation ↓
4. "What's AgnosticV?" → Explain and ask again

Your choice? [1/2/3/4]
```

**If user chooses 1 or 2 (No help needed):**
```
✓ Skipping AgV configuration

To create accurate showroom content, I need UserInfo variables.

Q1: Do you have access to a deployed environment on demo.redhat.com?

If YES (RECOMMENDED - easiest and most accurate):
1. Login to https://demo.redhat.com (or integration.demo.redhat.com)
2. Order your catalog if not already ordered
3. Once environment is ready, go to "My services" → Your service
4. Click "Details" tab
5. Expand "Advanced settings" section
6. Copy and paste the output here

This provides exact variables like:
- openshift_cluster_console_url
- openshift_cluster_admin_username
- gitea_console_url
- [custom workload variables]

Your answer: [Yes and paste Advanced settings / No]
```

**If user has deployed environment (Yes to Q1):**
```
✓ Perfect! Please paste the Advanced settings output.

→ Proceeding to Step 3: Module-Specific Details
```

**If user does NOT have deployed environment (No to Q1):**
```
ℹ️ No Deployed Environment Access

**Recommended**: Contact RHDP team to get Advanced settings from deployed environment.

They can help you:
- Get access to deployed catalog on demo.redhat.com
- Provide Advanced settings output
- Answer questions about catalog setup

Q2: Would you like to use placeholder attributes for now and get actual values later?

If YES:
I'll use placeholder attributes:
- {openshift_console_url}
- {user}, {password}
- {openshift_api_url}

You can update these later when you get Advanced settings.

If NO (RHDP internal team only):
I can extract variables from AgnosticV repository if you have it cloned locally.
This requires AgV repository access and is more complex.

Your choice: [Use placeholders / Extract from AgV]
```

**If user chooses "Extract from AgV" (RHDP internal only):**
```
Q3: What is your AgnosticV repository directory path?

If not cloned yet:
git clone https://github.com/rhpds/agnosticv.git

Example: /Users/username/work/code/agnosticv/

Your AgV path: [Enter path]
```

**Then:**
```
Q4: What is your catalog directory path (relative to AgV repo)?

Example: agd_v2/agentic-ai-openshift

Your catalog path: [Enter path]

I'll extract variables from {{ agv_path }}/{{ catalog_path }}/common.yaml

Note: This is less reliable than Advanced settings from deployed environment.

→ Proceeding to Step 3: Module-Specific Details
```

**If user chooses 3 (Yes, help needed):**
- **IMMEDIATELY ask for AgnosticV path** (see Access Check Protocol below) ↓

**If user chooses 4 (Explain):**
```
**What is AgnosticV?**

AgnosticV (AgV) defines catalog items in Red Hat Demo Platform (RHDP) that provision workshop/demo environments.

Think of it as:
- **What to deploy**: OpenShift cluster + workloads (AI, Pipelines, etc.)
- **Who provisions**: RHDP automation
- **Where defined**: agnosticv repository (common.yaml files)

**You need AgV if:**
- Your workshop/demo needs a live OpenShift cluster
- You want automated infrastructure provisioning
- You're deploying to RHDP

**You DON'T need AgV if:**
- RHDP developers already created your catalog
- Documentation/slides only (no hands-on)
- Using external/customer clusters

Do you need help with AgV configuration? [Yes/No]
```

### Access Check Protocol

**CRITICAL: This MUST be asked IMMEDIATELY when user selects option 3**

**Before any file operations, ask for AgnosticV path:**

```
Q: Do you have the AgnosticV repository cloned? If yes, please provide the directory path:

Example paths:
- ~/work/code/agnosticv/
- ~/projects/agnosticv/
- /path/to/agnosticv/

Your AgV path: [Enter path or 'skip' if you don't have access]
```

**If user provides valid path:**
- Use that path for catalog search and creation
- Continue to catalog search workflow ↓

**If user doesn't have access ('skip' or invalid path):**

```
ℹ️ **No AgnosticV Access**

Your workshop/demo can still be deployed via RHDP, but AgV catalog creation requires access.

**Recommendation:**

Contact RHDP developers to help create your AgV catalog.

**What I can suggest for reuse:**

Based on your workshop/demo "{{ workshop_demo_name }}" with technologies {{ tech_keywords }},
I recommend these existing catalogs as a good base:

1. **{{ suggested_catalog_1 }}** (Best match)
   - Display name: "{{ catalog_1_name }}"
   - Technologies: {{ catalog_1_tech }}
   - Category: {{ catalog_1_category }}

2. **{{ suggested_catalog_2 }}** (Alternative)
   - Display name: "{{ catalog_2_name }}"
   - Technologies: {{ catalog_2_tech }}

**Share this with RHDP developers** when requesting AgV catalog creation.

For now, I'll continue with placeholder attributes in your workshop/demo content:
- {openshift_console_url}
- {user}, {password}
- {openshift_api_url}

→ Proceeding to Step 3: Module-Specific Details
```

**If user provides valid path:**
- Use that path for all AgV operations
- Continue to catalog search workflow (if option 3) or catalog creation workflow (if option 4) ↓

### User-Suggested Catalog Search (Q3)

**Prerequisites**: User has provided valid AgV path in Access Check Protocol above.

**Before automatic keyword search**, ask user:

**Q3**: "Do you think there's an existing catalog that could be a good base for this workshop/demo?"

**Options:**
- "Yes, I know of one" → Continue to Q3a
- "No" or "Not sure" → Skip to keyword recommendations

**If user answers "Yes":**

**Q3a**: "What's the catalog display name or slug?"

**Examples:**
- Display name: "Agentic AI on OpenShift", "OpenShift Pipelines Workshop"
- Catalog slug: "agentic-ai-openshift", "ocp-pipelines-workshop"

### Display Name Search Specification

**Search algorithm** when user provides catalog suggestion:

1. **Search locations:**
   - `__meta__.catalog.display_name` field in `common.yaml` (partial match, case-insensitive)
   - Catalog directory slug in `agd_v2/` (partial match)
   - `__meta__.catalog.keywords` array (exact keyword match)
   - `__meta__.catalog.category` field (partial match)

2. **Scoring system:**
   - Display name match: **50 points**
   - Catalog slug match: **40 points**
   - Keyword match: **10 points each**
   - Category match: **5 points**

3. **Return top 5 results** sorted by score descending

4. **Show for each result:**
   - Display name and score
   - Catalog slug
   - Category (Workshops, Demos, etc.)
   - Multi-user: Yes/No (and user range if applicable)
   - Infrastructure type (CNV, SNO, AWS)
   - Key workloads (first 5)
   - OpenShift version requirement
   - Path (e.g., agd_v2/catalog-slug)

5. **User options:**
   - Use catalog #X as-is → Extract UserInfo, go to Step 3
   - Create new catalog based on #X → Copy structure, continue to creation workflow
   - See details for catalog #Y → Show full workload list
   - Go back to keyword search → Fallback to keyword recommendations

**If no results found:**
```
No catalogs found matching "{{ user_input }}".

Try:
- Different spelling or keywords
- Catalog slug instead of display name
- Let me search by technology keywords from your workshop/demo plan

Search again or proceed to keyword recommendations? [Search again/Keywords]
```

### Keyword-Based Catalog Recommendations (Fallback)

**When triggered:**
- User answered "No/Not sure" to Q3
- User-suggested search found no results
- User chose "Go back to keyword search"

**Algorithm:**
1. Extract technology keywords from Step 2 (overall story planning)
   - Examples: AI, pipelines, GitOps, platform value, automation
2. Search catalog display names and slugs in `agd_v2/`
3. Analyze workload lists in `common.yaml`
4. Score by relevance to workshop/demo tech stack
5. Show top 3-5 matches

**Show for each:**
- Display name and match score (with star rating)
- Multi-user support
- Category
- Key workloads
- Infrastructure type
- Best use case description

**Options:**
- Use one of these catalogs: [Enter 1, 2, or 3]
- View workloads in detail: [Enter catalog name]
- Create new catalog instead: [Enter 'new']
- Skip AgV for now: [Enter 'skip']

### Multi-user vs Dedicated Rules

**Default recommendations:**

**Labs** (`/create-lab`):
- **Recommend: Multi-user**
- Rationale: Hands-on workshops with 5-50 attendees, cost-effective, one cluster with multiple user accounts (user1...userN)
- Infrastructure: CNV with autoscaling
- Authentication: htpasswd for multi-user

**Demos** (`/create-demo`):
- **Recommend: Dedicated**
- Rationale: Presenter-led demonstrations, executive/sales demos, consistent experience, single presenter control
- Infrastructure: CNV or AWS (if GPU)
- Authentication: Keycloak for demos

**Special Cases (Always Dedicated):**
- Non-OpenShift workloads (VMs, edge, Windows)
- GPU-accelerated workloads
- Executive demos (C-level, pre-sales briefings)
- Single deep-dive scenarios

### Infrastructure Selection Rules

**CNV (Container-Native Virtualization)** - DEFAULT for most labs/demos:
- ✓ Fast provisioning (10-15 mins)
- ✓ Cost-effective
- ✓ Supports multi-user (up to 64Gi/32 cores per worker)
- ✓ Best for: Standard OpenShift workloads
- ✓ Autoscaling support
- **When to use:** Default choice for OpenShift-based labs and demos

**SNO (Single Node OpenShift)**:
- ✓ Faster provisioning (5-10 mins)
- ✓ Lightweight workloads
- ✓ Single-user scenarios
- ✓ Edge computing demos
- **When to use:** Quick platform overviews, edge scenarios, lightweight demos

**AWS (Cloud-Specific)**:
- ✓ GPU acceleration (NVIDIA, g6.4xlarge instances)
- ✓ Large memory requirements (>128Gi)
- ✓ Cloud-native service integration (S3, ELB, etc.)
- ⚠️ Slower provisioning (30-45 mins)
- ⚠️ Higher cost - reserve for GPU needs
- **When to use:** AI/ML workloads requiring GPU, large memory footprint, cloud services

### Collection Recommendation Mappings

**Always include:**
- `agnosticd.core_workloads` - Authentication (htpasswd for multi-user, Keycloak for demos), base OpenShift capabilities

**AI/ML keywords** (ai, ml, openshift-ai, models, llm, rag):
- `agnosticd.ai_workloads` - OpenShift AI operator, GPU operator, OLS (OpenShift Lightspeed)
- `rhpds.litellm_virtual_keys` (optional) - LiteLLM proxy for model access, virtual API key management

**DevOps/GitOps keywords** (pipeline, gitops, tekton, argo):
- Core workloads already include:
  - `ocp4_workload_pipelines` (OpenShift Pipelines / Tekton)
  - `ocp4_workload_openshift_gitops` (Argo CD)
  - `ocp4_workload_gitea_operator` (Git server for labs)

**Workshop/Demo Content Delivery (REQUIRED - Auto-selected based on infrastructure):**

**For OCP-based** (`config: openshift-workloads` or `config: openshift-cluster`):
- `agnosticd.showroom.ocp4_workload_showroom_ocp_integration` - OCP integration layer
- `agnosticd.showroom.ocp4_workload_showroom` - Showroom platform on OCP
- Features: Terminal integration, OCP cluster access, Know/Show structure support

**For VM-based** (`config: cloud-vms-base`):
- `agnosticd.showroom.vm_workload_showroom` - Showroom platform on bastion
- Features: Terminal integration on bastion, VM access, Know/Show structure support

**IMPORTANT**: Showroom workload is automatically selected based on `config` type. Do NOT ask user - detect from infrastructure choice.

**Showroom Git Repository URL Pattern**:

Users will clone showroom content repositories locally to work with skills, so **always use HTTPS URLs** (not SSH).

**Standard Pattern**:
```
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/<workshop-name>-showroom.git
ocp4_workload_showroom_content_git_repo_ref: main
```

**Examples from actual catalogs**:
- `https://github.com/rhpds/showroom-agentic-ai-llamastack.git`
- `https://github.com/rhpds/ai-driven-automation-showroom.git`
- `https://github.com/rhpds/automating-ripu-with-ansible-showroom.git`

**Why HTTPS**: Users clone these repositories locally when working with Claude skills, so SSH URLs won't work for most users.

### Workload Selection Assistant

**Purpose:** Recommend specific workloads based on workshop/demo abstract and keywords

#### Workload Recommendation Workflow

**Step 1: When showing catalog matches** (from search results):

```markdown
**Recommended Catalog:**

1. **"Agentic AI on OpenShift"** (90% match)
   - Catalog: agd_v2/agentic-ai-openshift
   - Multi-user: Yes (5-40 users)
   - Infrastructure: CNV multi-node

   **Workloads included:**
   ✓ ocp4_workload_authentication_htpasswd → Multi-user login
   ✓ ocp4_workload_showroom → Workshop platform
   ✓ ocp4_workload_litellm_virtual_keys → LLM API proxy
   ✓ ocp4_workload_openshift_ai → OpenShift AI operator
   ✓ ocp4_workload_pipelines → Model deployment automation

   Use this catalog? [Yes/Create new based on this/See next]
```

**If user chooses "Yes" (use catalog as-is):**
- Skip catalog creation
- Extract UserInfo variables from this catalog (see UserInfo Variable Extraction section)
- Proceed to Step 3 (module creation)

**If user chooses "Create new based on this":**

**CRITICAL: Use reference catalog as TEMPLATE**

1. **Read reference catalog files:**
   ```
   Reading reference catalog: {{ agv_path }}/{{ reference_catalog_path }}/

   Files found:
   - common.yaml
   - dev.yaml
   - description.adoc (optional)
   ```

2. **Copy structure from reference:**
   - Parse reference `common.yaml`
   - Use it as TEMPLATE for new catalog
   - Preserve structure, includes, component definitions
   - Copy `dev.yaml` as-is (can be used unchanged)

3. **Modify only what's needed:**
   - **UUID**: Replace with user-generated UUID (ask user to generate)
   - **Display name**: Ask user for new name
   - **Catalog slug**: Derive from new display name
   - **Showroom repo**: Use detected repo from cwd
   - **Workloads**: Review and customize (ask user)
   - **Multi-user settings**: Keep from reference or ask to change
   - **Infrastructure**: Keep from reference or ask to change

4. **Ask user for modifications:**
   ```
   Q: Reference catalog "{{ reference_name }}" uses:
   - Multi-user: {{ ref_multiuser }}
   - Authentication: {{ ref_auth }}
   - Infrastructure: {{ ref_infra }}
   - Workloads: {{ ref_workload_count }} workloads

   Keep these settings? [Yes/Customize]
   ```

   If "Customize":
   - Ask which settings to change
   - Show options for each setting

5. **Generate files using reference as template:**
   - **CRITICAL: Create EXACT COPY of reference catalog**
   - **ONLY modify these fields** (unless user explicitly requests other changes):
     1. UUID → New generated UUID
     2. `__meta__.catalog.display_name` → User's workshop/demo name
     3. Catalog directory slug → Based on display name
     4. `__meta__.catalog.showroom` → User's showroom repo URL
   - **KEEP EVERYTHING ELSE EXACTLY AS-IS:**
     - All workloads (unless user says "remove X" or "add Y")
     - All workload variables and configurations
     - All includes (#include directives)
     - All components
     - All parameters
     - Infrastructure configuration
     - Multi-user settings
     - Category
     - `dev.yaml` → Copy exactly from reference
     - `description.adoc` → Copy with updated display name

**CRITICAL: DO NOT "intelligently" modify workloads or settings**:
- ❌ Don't remove workloads you think aren't needed
- ❌ Don't add workloads you think would be helpful
- ❌ Don't change infrastructure settings
- ❌ Don't modify multi-user configuration
- ❌ Don't change workload variables
- ✅ ONLY modify if user explicitly says: "remove this" or "change that"

**Why this matters:**
- Reference catalogs have **proven working structure**
- Prevents schema validation errors
- Preserves all dependencies and integrations
- Reference may have non-obvious workload dependencies
- User chose this reference because it works - don't break it!
- Only changes what's truly different (UUID, name, repo URL)

**If user chooses "See next":**
- Show next catalog match from search results
- Repeat options: [Yes/Create new based on this/See next]

---

**Step 2: When creating new catalog FROM SCRATCH** (user chose "Create new" with no reference):

Extract keywords from abstract → Map to workloads → Present recommendations

```markdown
**Workload Recommendations for Your New Catalog:**

Based on abstract: "{{ workshop_abstract }}"
Keywords detected: {{ detected_keywords }}

**Core (Always Required):**

**Authentication Method:**
Q: Which authentication method?
- Keycloak (Recommended) → More features, SSO, better UX
- htpasswd → Simple, faster setup

✓ agnosticd.core_workloads.ocp4_workload_authentication_keycloak (Recommended)
  Purpose: Keycloak-based authentication with SSO support
  OR
✓ agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
  Purpose: Simple htpasswd authentication

**Showroom (Content Delivery):**
{% if infrastructure_type == 'ocp' %}
✓ agnosticd.showroom.ocp4_workload_showroom
  Purpose: OCP-based workshop/demo content platform
{% else %}
✓ agnosticd.showroom.showroom_deployer
  Purpose: VM-based workshop/demo content platform
{% endif %}

**{{ primary_category }} Stack (Recommended):**
{% for workload in recommended_workloads %}
✓ {{ workload.full_name }}
  Purpose: {{ workload.description }}
{% endfor %}

**Optional Workloads:**
{% for workload in optional_workloads %}
? {{ workload.full_name }}
  Purpose: {{ workload.description }}
  When to include: {{ workload.use_case }}
{% endfor %}

Include optional workloads? [All/Customize/Skip optional]
```

#### Keyword to Workload Mapping

**AI/ML Keywords** (ai, ml, llm, rag, model, inference, training):

**Core AI:**
- `agnosticd.ai_workloads.ocp4_workload_openshift_ai`
  - Purpose: OpenShift AI operator, notebook servers, data science pipelines
  - When: Any AI/ML workshop or demo
  - Variables: Enable GPU, monitoring, default notebook images

**LLM Access:**
- `rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys`
  - Purpose: LLM API proxy with virtual keys (Mistral, Granite, CodeLlama)
  - When: LLM inference, chatbots, RAG applications
  - Provides: `litellm_api_base_url`, `litellm_virtual_key`, `litellm_available_models`

**GPU Support:**
- `agnosticd.ai_workloads.ocp4_workload_nvidia_gpu_operator`
  - Purpose: NVIDIA GPU operator for model training
  - When: Training large models, GPU-accelerated workloads
  - Requires: AWS infrastructure (g6.4xlarge)

**AI Assistant:**
- `agnosticd.ai_workloads.ocp4_workload_ols`
  - Purpose: OpenShift Lightspeed (AI coding assistant)
  - When: Developer productivity demos

**DevOps/GitOps Keywords** (pipeline, gitops, ci/cd, tekton, argo, automation):

**Pipelines:**
- `agnosticd.core_workloads.ocp4_workload_pipelines`
  - Purpose: Tekton Pipelines (cloud-native CI/CD)
  - When: Pipeline workshops, CI/CD automation
  - Includes: Tekton operator, example pipelines

**GitOps:**
- `agnosticd.core_workloads.ocp4_workload_openshift_gitops`
  - Purpose: Argo CD for GitOps workflows
  - When: GitOps training, declarative deployments
  - Includes: Argo CD operator, sync policies

**Git Server:**
- `agnosticd.core_workloads.ocp4_workload_gitea_operator`
  - Purpose: Self-hosted Git server for labs
  - When: Disconnected environments, Git workflow training
  - Provides: Gitea instance with user repositories

**Developer Tools Keywords** (ide, vscode, dev-spaces, inner-loop):

**Dev Spaces:**
- `agnosticd.core_workloads.ocp4_workload_openshift_devspaces`
  - Purpose: Cloud-based IDE (Eclipse Che)
  - When: Developer onboarding, browser-based coding
  - Includes: Dev Spaces operator, workspace templates

**Security Keywords** (security, compliance, acs, stackrox, scanning):

**ACS (Advanced Cluster Security):**
- `agnosticd.core_workloads.ocp4_workload_acs`
  - Purpose: Kubernetes security platform
  - When: Security workshops, compliance demos
  - Includes: Central, Scanner, Admission Controller

**Observability Keywords** (monitoring, logging, observability, metrics):

**Monitoring:**
- `agnosticd.core_workloads.ocp4_workload_observability`
  - Purpose: OpenShift monitoring stack
  - When: Observability training, metrics workshops
  - Includes: Prometheus, Grafana, AlertManager

**Logging:**
- `agnosticd.core_workloads.ocp4_workload_logging`
  - Purpose: Cluster logging (Loki, Vector)
  - When: Log aggregation, troubleshooting demos
  - Includes: Logging operator, log forwarding

**Networking Keywords** (service-mesh, istio, networking, ingress):

**Service Mesh:**
- `agnosticd.core_workloads.ocp4_workload_service_mesh`
  - Purpose: Red Hat OpenShift Service Mesh (Istio)
  - When: Microservices workshops, traffic management
  - Includes: Service Mesh operator, control plane

**Serverless Keywords** (serverless, knative, functions, eventing):

**Serverless:**
- `agnosticd.core_workloads.ocp4_workload_serverless`
  - Purpose: Knative Serving and Eventing
  - When: Event-driven architectures, auto-scaling demos
  - Includes: Serverless operator, Knative components

#### Workload Variable Configuration

**When recommending a workload, also mention key variables:**

Example:
```
✓ agnosticd.ai_workloads.ocp4_workload_openshift_ai
  Purpose: OpenShift AI operator

  Key variables (optional):
  - ocp4_workload_openshift_ai_channel: "stable" (default: stable)
  - ocp4_workload_openshift_ai_enable_gpu: false (set true if GPU needed)
  - ocp4_workload_openshift_ai_enable_monitoring: true

  Configure? [Use defaults/Customize]
```

#### Passing Data Between Workloads

**Critical pattern for dependent workloads:**

**Scenario:** LiteLLM outputs API key → Next workload needs it

**Workload A (produces data):**
```yaml
# In workload tasks/main.yml:
- name: Save LiteLLM credentials
  agnosticd.core.agnosticd_user_info:
    data:
      litellm_api_base_url: "{{ litellm_url }}"
      litellm_virtual_key: "{{ generated_key }}"
```

**AgV config (passes data):**
```yaml
# In common.yaml:
workloads:
- rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys
- myorg.my_app.ocp4_workload_my_app

# Pass LiteLLM data to my_app workload:
ocp4_workload_my_app_api_url: "{{ lookup('agnosticd_user_data', 'litellm_api_base_url') }}"
ocp4_workload_my_app_api_key: "{{ lookup('agnosticd_user_data', 'litellm_virtual_key') }}"
```

**Workload B (consumes data):**
```yaml
# In workload defaults/main.yml:
ocp4_workload_my_app_api_url: ""
ocp4_workload_my_app_api_key: ""

# Data automatically available from AgV config
```

**Common patterns:**
- API keys, tokens, credentials
- Service URLs and endpoints
- Generated usernames/passwords
- Deployed application routes

#### Post-Creation Testing Workflow

**After catalog files created and PR submitted:**

```markdown
✓ Catalog created: agd_v2/{{ catalog_slug }}
✓ Branch pushed: {{ catalog_slug }}

**Next Steps:**

1. Create PR:
   gh pr create --title "Add {{ catalog_display_name }}"

2. PR will be automatically labelled for integration deployment

3. **Test in Integration** (BEFORE requesting PR merge):
   - Login to https://integration.demo.redhat.com
   - Search for your catalog by display name: "{{ catalog_display_name }}"
   - Order the catalog
   - Wait 1-2 hours for environment provisioning (can take longer)
   - Once successful, go to "My services" → Your service → "Details" tab
   - Expand "Advanced settings" section
   - Copy the UserInfo variables output (for showroom content)
   - Test workshop/demo content in deployed environment

4. After successful testing:
   - Share Advanced settings output (helps with showroom content creation)
   - Update PR with test results
   - Send PR to RHDP developers requesting merge
   - After merge, catalog will deploy to stage/production

5. Troubleshooting provision failures:
   - Check RHDP portal → My services → Your order → Logs
   - Common issues:
     * Missing collection dependency
     * Wrong workload variable name
     * Resource exhaustion
   - Contact RHDP developers if needed

**Timeline:**
- PR labelled for integration: Quick
- Environment provisioning: 1-2 hours after ordering (can take longer)
- Testing: Before requesting PR merge
- Stage deploy: ~4 hours after PR merge
- Production: After approval
```

#### AgV Testing Confirmation (REQUIRED before module creation)

**After AgV catalog is created/selected, MUST ask user:**

```
Q: Have you tested the AgV catalog in RHDP Integration?

If creating NEW catalog:
1. Create PR (it will be labelled for integration quickly)
2. Login to https://integration.demo.redhat.com
3. Search for your catalog by display name
4. Order the catalog on integration
5. Wait 1-2 hours for environment provisioning (can take longer)
6. Once successful, go to "My services" → Your service → "Details" tab
7. Expand "Advanced settings" section and copy UserInfo variables
8. Verify all workloads provision successfully
9. Test workshop/demo content
10. After successful testing, send PR to RHDP developers requesting merge

If using EXISTING catalog:
1. Catalog should already work in RHDP
2. Confirm you have access and can order it
3. If possible, share Advanced settings output from deployed environment

**Options:**
1. Yes, catalog tested and working (please share Advanced settings output if available) → Proceed to Step 3
2. No, I'll test it first → Pause here, user will test and come back
3. Skip testing (not recommended) → Proceed but warn about potential issues

Your choice? [1/2/3]
```

**CRITICAL**: Do NOT proceed to Step 3 (module creation) until user confirms AgV catalog is tested (option 1) or explicitly chooses to skip (option 3).

**If user chooses option 2 (test first):**
```
✓ Pausing workflow for AgV testing

Please:
1. Create PR (if not already done) - it will be labelled for integration quickly
2. Login to https://integration.demo.redhat.com
3. Search for your catalog by display name
4. Order the catalog on integration
5. Wait 1-2 hours for environment provisioning (can take longer)
6. Once successful, go to "My services" → Your service → "Details" tab
7. Expand "Advanced settings" section and copy UserInfo variables
8. Verify all workloads provision correctly
9. Test workshop/demo content
10. Share the Advanced settings output (helps with showroom content creation)
11. Come back when ready to create module content

When you're ready, say "ready to create module" and I'll continue from Step 3.
```

### Git Workflow Requirements (CRITICAL)

**Prerequisites**: User has provided valid AgV path in Access Check Protocol above.

**Pre-creation steps** (REQUIRED before creating catalog files):

1. **Navigate to AgnosticV repo:**
   ```bash
   cd {{ user_provided_agv_path }}
   ```

   Replace `{{ user_provided_agv_path }}` with the path user provided in Access Check.

2. **Switch to main branch:**
   ```bash
   git checkout main
   ```

3. **Pull latest changes:**
   ```bash
   git pull origin main
   ```

4. **Create new branch:**
   ```bash
   git checkout -b {{ catalog_slug }}
   ```

**Branch Naming Convention** (CRITICAL):

**Pattern:** `<catalog-slug>` or `<catalog-slug>-<variant>`

**IMPORTANT:** NO "feature/" prefix per AgV convention

**Examples:**
- ✓ `ocp-pipelines-workshop`
- ✓ `agentic-ai-summit-2025`
- ✓ `openshift-ai-gpu-aws`
- ✗ `feature/ocp-pipelines-workshop` (DON'T USE)
- ✗ `feature/ai-demo` (DON'T USE)

**Validation:**
- Lowercase only
- Hyphens for word separation
- No underscores, no slashes (except directory separator)
- Descriptive and matches catalog slug

### UUID Generation (REQUIRED BEFORE FILE CREATION)

**CRITICAL**: Generate UUID BEFORE creating catalog files so it can be inserted directly into common.yaml.

**Ask user to generate UUID:**

```
Q: Please generate a unique UUID for this catalog.

Run one of these commands:

macOS/Linux:
  uuidgen

OR

Python (any platform):
  python3 -c 'import uuid; print(uuid.uuid4())'

Paste the generated UUID here: [paste UUID]
```

**UUID Format Validation:**
- Must be standard UUID format: `XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
- Example: `5ac92190-6f0d-4c0e-a9bd-3b20dd3c816f`
- NOT valid: `gitops-openshift-2026-01` (this is not a UUID!)

**Store UUID for use in common.yaml template below.**

### Showroom Repository Detection (REQUIRED IF USING SHOWROOM)

**CRITICAL**: Auto-detect showroom git repository from current working directory instead of hardcoding.

**Detection workflow:**

```
Q: Detecting showroom repository...

Running: git -C $(pwd) remote get-url origin

{% if git_remote_found %}
✓ Found git remote: {{ git_remote_url }}

{% if git_remote_url is SSH format (git@github.com:...) %}
Converting SSH to HTTPS...
  SSH:   {{ git_remote_url }}
  HTTPS: {{ https_url }}
{% endif %}

Using showroom repo: {{ final_https_url }}
Confirm this is correct? [Yes/No/Enter different URL]

{% else %}
⚠️ No git remote found in current directory.

Please provide your showroom repository URL (HTTPS format):
Example: https://github.com/rhpds/showroom-agentic-ai-llamastack.git

Your showroom repo URL: [Enter URL]
{% endif %}
```

**URL Conversion Rules:**
- If SSH format `git@github.com:rhpds/showroom-name.git` → Convert to `https://github.com/rhpds/showroom-name.git`
- If HTTPS already → Use as-is
- Always ensure `.git` suffix is present

**Store detected/provided URL for use in common.yaml template below.**

**Post-creation steps:**

**⚠️ CRITICAL WARNING: Catalog files created but NOT pushed to git!**

The catalog files have been created locally in:
- `{{ agv_path }}/{{ selected_dir }}/{{ catalog_slug }}/`

**You MUST review, commit, and push these changes manually.**

---

**Step 1: Review changes locally**

```bash
cd {{ agv_path }}

# Review what files were created/modified
git status

# Review the actual changes
git diff

# Review the complete catalog configuration
cat {{ selected_dir }}/{{ catalog_slug }}/common.yaml
```

**Step 2: Add catalog files**

```bash
git add {{ selected_dir }}/{{ catalog_slug }}/
```

**Step 3: Commit with descriptive message**

```bash
git commit -m "Add {{ catalog_display_name }} catalog

- Multi-user: {{ multiuser }}
- Infrastructure: {{ infra_type }}
- Collections: {{ collections_list }}
- Target: {{ workshop_type }}"
```

**Step 4: Push branch to remote**

```bash
git push -u origin {{ catalog_slug }}
```

**Step 5: Create Pull Request**

After pushing:
- Create PR in AgnosticV repository
- Request review from RHDP developers
- After PR merge, test in RHDP Integration (~1 hour deployment time)

---

**⚠️ Remember: Changes are only local until you push! Review carefully before pushing.**

### AgV Directory Selection

**Recommended directories:**

1. **agd_v2/** - DEFAULT, most workshops/demos
2. **enterprise/** - Red Hat internal only
3. **summit-2025/** - Event-specific, time-bound
4. **ansiblebu/** - Ansible Automation Platform focus

**Ask user:** "Which directory? [1-4 or custom path]"

**Suggested path:** `agd_v2/{{ suggested_slug }}`

### AgnosticD v2 Pattern Enforcement

**Rule:** Creation workflow generates **agd_v2 patterns ONLY**

**What this means:**
- Use modern AgV includes (#include statements)
- Use component-based structure (cluster, workloads, metadata)
- Use `__meta__.catalog` section for display name, keywords, category
- Use `requirements.collections` for explicit collection dependencies
- Generate `common.yaml`, `description.adoc`, `dev.yaml` only

**Can still READ AgDv1 catalogs:**
- For UserInfo variable extraction
- For reference when user suggests existing catalog
- But **never generate AgDv1 patterns** for new configs

### Config File Generation

**REQUIRED: Create ALL THREE files** in `agd_v2/{{ catalog_slug }}/` or `openshift_cnv/{{ catalog_slug }}/`:

#### 1. common.yaml - Main Configuration

**Content includes**:
- AgnosticV includes (#include statements)
- Cluster configuration (CNV pools, SNO, or AWS)
- Requirements (collections list)
- Workload list with variables
- Authentication setup (htpasswd multi-user or Keycloak)
- Showroom integration (if selected)
- Metadata (`__meta__.catalog` section with display_name, keywords, category)
- **CRITICAL**: `__meta__.asset_uuid` - Must be unique for each catalog

**UUID Generation**:
- **ALWAYS ask user to generate a new UUID** when creating a catalog
- Command: `uuidgen` (on macOS/Linux) or `python3 -c 'import uuid; print(uuid.uuid4())'`
- Format: `asset_uuid: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
- Example: `asset_uuid: 5ac92190-6f0d-4c0e-a9bd-3b20dd3c816f`
- **NEVER reuse UUIDs** from other catalogs

**Template structure** (adapt based on infrastructure type):
```yaml
---
# AgnosticV includes
#include /includes/agd-v2-mapping.yaml
#include /includes/sandbox-api.yaml
#include /includes/catalog-icon-openshift.yaml
#include /includes/terms-of-service.yaml

#include /includes/parameters/purpose.yaml
#include /includes/parameters/salesforce-id.yaml
#include /includes/secrets/letsencrypt_with_zerossl_fallback.yaml

# Repository Tag
tag: main

cloud_provider: none
config: openshift-workloads  # OR cloud-vms-base for VM-based
clusters:
- default:
    api_url: "{{ openshift_api_url }}"
    api_token: "{{ openshift_api_key }}"

# Collections
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: main

# Workloads
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
- agnosticd.showroom.ocp4_workload_showroom_ocp_integration
- agnosticd.showroom.ocp4_workload_showroom

# Workload variables
common_user_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:10] }}"
common_admin_password: "{{ (guid[:5] | hash('md5') | int(base=16) | b64encode)[:16] }}"

ocp4_workload_authentication_htpasswd_admin_user: admin
ocp4_workload_authentication_htpasswd_admin_password: "{{ common_admin_password }}"
ocp4_workload_authentication_htpasswd_user_base: user
ocp4_workload_authentication_htpasswd_user_password: "{{ common_user_password }}"
ocp4_workload_authentication_htpasswd_user_count: "{{ (num_users | default('2')) | int }}"

ocp4_workload_showroom_content_git_repo: {{ detected_showroom_repo_url }}
ocp4_workload_showroom_content_git_repo_ref: main

# Metadata
__meta__:
  asset_uuid: {{ user_generated_uuid }}
  owners:
    maintainer:
    - name: Your Name
      email: your.email@redhat.com
  anarchy:
    namespace: babylon-anarchy-7
  deployer:
    scm_url: https://github.com/agnosticd/agnosticd-v2
    scm_ref: main
    execution_environment:
      image: quay.io/agnosticd/ee-multicloud:chained-2025-10-09
      pull: missing
  catalog:
    namespace: babylon-catalog-{{ stage | default('?') }}
    display_name: {{ catalog_display_name }}
    category: {{ category }}  # Workshops or Demos
    keywords:
    - {{ keyword1 }}
    - {{ keyword2 }}
    multiuser: {{ true_or_false }}
    parameters:
    - name: num_users
      description: Number of users to provision within the cluster.
      formLabel: OpenShift User Count
      openAPIV3Schema:
        type: integer
        default: 2
        minimum: 2
        maximum: 40
  components:
  - name: openshift-base
    display_name: OpenShift Cluster
    item: agd-v2/ocp-cluster-cnv-pools/prod  # OR other infrastructure
    parameter_values:
      cluster_size: multinode  # OR sno
      host_ocp4_installer_version: "4.20"
    propagate_provision_data:
    - name: openshift_api_ca_cert
      var: openshift_api_ca_cert
    - name: openshift_api_url
      var: openshift_api_url
    - name: openshift_cluster_admin_token
      var: openshift_api_key
```

#### 2. description.adoc - Catalog Description

**REQUIRED content**:

```asciidoc
= {{ catalog_display_name }}

{{ Brief 1-2 sentence description of workshop/demo purpose }}

{{ If multi-user: }}
This catalog supports {{ min }}-{{ max }} concurrent users.

{{ If showroom: }}
Workshop content is delivered via Red Hat Showroom platform.

== Prerequisites

* Basic knowledge of {{ technology }}
* {{ other prerequisites }}

== What You'll Learn

* {{ learning outcome 1 }}
* {{ learning outcome 2 }}
* {{ learning outcome 3 }}

== Environment Details

* OpenShift {{ ocp_version }}
* {{ Product 1 }} {{ version }}
* {{ Product 2 }} {{ version }}

{{ If multi-user: }}
== User Access

Each user receives:
* Unique username (user1, user2, etc.)
* Individual project/namespace
* Access to shared cluster resources
```

**Example**:
```asciidoc
= Agentic AI with Llama Stack

Learn to build agentic AI applications using Llama Stack framework on Red Hat OpenShift AI.

This catalog supports 2-40 concurrent users.

Workshop content is delivered via Red Hat Showroom platform.

== Prerequisites

* Basic knowledge of Python and AI/ML concepts
* Familiarity with container platforms

== What You'll Learn

* Deploy Llama Stack on OpenShift AI
* Build agentic workflows with tool integration
* Implement RAG patterns for enterprise data
* Monitor and optimize AI workloads

== Environment Details

* OpenShift 4.20
* OpenShift AI 2.8
* Llama Stack latest

== User Access

Each user receives:
* Unique username (user1, user2, etc.)
* Individual project namespace
* Access to shared AI infrastructure and models
```

#### 3. dev.yaml - Development Overrides

**REQUIRED content**:

```yaml
---
# Development overrides for testing
# Use this config for local testing before production deployment

purpose: development

# Override SCM ref for testing showroom content from feature branches
# Example: Change 'main' to your feature branch name
# ocp4_workload_showroom_content_git_repo_ref: feature-new-module

# Override collections for testing development versions
# requirements_content:
#   collections:
#   - name: https://github.com/agnosticd/core_workloads.git
#     type: git
#     version: develop

# Override num_users for smaller dev deployments
# num_users: 2

# Override workload versions for testing
# ocp4_workload_pipelines_channel: pipelines-1.20
```

**Example**:
```yaml
---
purpose: development

# Test with feature branch
ocp4_workload_showroom_content_git_repo_ref: feature-module-2

# Smaller deployment for dev
num_users: 2
```

### UserInfo Variable Extraction

**RECOMMENDED: Get Variables from Deployed Environment**

The most accurate way to get UserInfo variables is from a deployed environment:

**Ask user:**
```
Q: Do you have access to a deployed environment (on integration.demo.redhat.com or demo.redhat.com)?

If YES:
Please share the UserInfo variables from your deployed service:

1. Login to https://integration.demo.redhat.com (or demo.redhat.com)
2. Go to "Services" → Find your service
3. Click on "Details" tab
4. Expand "Advanced settings" section
5. Copy and paste the output here

This shows all available UserInfo variables like:
- openshift_cluster_console_url
- openshift_api_server_url
- openshift_cluster_admin_username
- openshift_cluster_admin_password
- gitea_console_url
- gitea_admin_username
- gitea_admin_password
- [custom workload variables]

If NO:
I can use common variables as placeholders:
- {openshift_console_url}
- {openshift_api_url}
- {user}
- {password}
- {bastion_public_hostname}
```

**When user provides Advanced settings output:**
- Extract all variables shown
- Map to Showroom attributes using same names
- Example: `openshift_cluster_console_url` → `{openshift_cluster_console_url}`

**Alternative: Extract from AgV Catalog (if no deployed environment)**

If user doesn't have deployed environment access:

1. **Read catalog configuration:**
   - Location: `{{ user_provided_agv_path }}/agd_v2/{{ catalog_slug }}/common.yaml`
   - Parse workload list

2. **Clone and read collections:**
   - Collections can be from ANY repository (agnosticd, rhpds, etc.)
   - Clone each collection to temp directory
   - Read workload roles to find `agnosticd_user_info` tasks
   - Extract variables from `data:` sections
   - **Note**: This is less reliable than deployed environment output

**Common variables (fallback):**
- `openshift_console_url` → `{openshift_console_url}`
- `openshift_api_url` → `{openshift_api_url}`
- `user_name` → `{user}`
- `user_password` → `{password}`
- `bastion_public_hostname` → `{bastion_public_hostname}`
- Custom workload-specific variables

**Result:** Use these as Showroom attributes in generated lab/demo content

### Summary and Transition

**After AgV assistance completes:**

```
✓ AgV Configuration Complete

**Selected catalog:** {{ catalog_name }}

**Next:**
- I'll extract UserInfo variables from this catalog's workloads
- Use these variables as Showroom attributes in your workshop/demo modules
- Example variables available:
  - {openshift_console_url}
  - {user}, {password}
  - {openshift_api_url}
  - [workload-specific variables]

→ Proceeding to Step 3: Module-Specific Details
```

