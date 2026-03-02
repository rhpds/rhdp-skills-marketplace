# Mode 3: Info Message Template

## MODE 3: Info Message Template Only

**When selected:** User chose option 3 (Info Message Template)

### Step 1: Locate Catalog

**Ask directly for the path. DO NOT try to find it or ask about subdirectories:**

```
📂 Catalog Location

Q: What is the path to your AgV catalog directory?

   Examples:
   - ~/work/code/agnosticv/agd_v2/my-catalog
   - /path/to/agnosticv/catalogs/demo-catalog

Path:
```

### Step 2: Discover Actual User Data Keys

**Do NOT ask the user to type key names from memory.** First try to read the actual workload code to find the real keys.

**Step 2a — Search workload tasks for agnosticd_user_info calls:**
Read the catalog's `common.yaml` to get the workload list, then search each collection role's tasks for `agnosticd_user_info` calls:

```bash
grep -r "agnosticd_user_info\|agnosticd.core.agnosticd_user_info" \
  {collection_path}/roles/*/tasks/ -A 10 | grep -A 5 "data:"
```

Extract every key name under `data:` — these are the REAL variable names (e.g. `litellm_api_base_url`, `gitea_admin_password`, `openshift_console_url`).

**Step 2b — Confirm with user:**
```
I found these data keys in your workloads:

  - litellm_api_base_url
  - litellm_virtual_key
  - gitea_admin_username

Are these correct? Any to add or remove?
```

**If workload code is not available**, ask — but require exact names:
```
Q: What data keys does your workload share via agnosticd_user_info?
   Use the EXACT key names from your workload's agnosticd_user_info data: dict.
   Do not use generic names — check your workload tasks first.

   Common real examples:
   - litellm_api_base_url, litellm_virtual_key   (LiteMaaS)
   - gitea_admin_username, gitea_admin_password   (Gitea)
   - openshift_console_url                        (OCP cluster)

Data keys (exact names):
```

**Generate template using REAL key names only** — never use generic placeholders like `{data_key_1}`, `{user}`, or `{api_key}`. Every `{variable}` in the template must correspond to an actual key from the workload.

**Write file and optionally commit**

---

