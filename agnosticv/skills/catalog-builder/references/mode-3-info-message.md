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

### Step 2: User Data Configuration

```
📧 Info Message Template

This template uses data from agnosticd_user_info.

Q: Does your workload share data via agnosticd_user_info? [Y/n]
```

**If YES:**
```
Q: List the data keys your workload shares (comma-separated):

Examples:
  - litellm_api_base_url, litellm_virtual_key
  - grafana_url, grafana_password
  - custom_service_url, custom_api_key

Data keys:
```

**Generate template** (same as Mode 1, Step 10.4)

**Write file and optionally commit**

---

