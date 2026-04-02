# Example: List All Clusters and Get Cluster Details

These examples show how to use `sandbox-cli` via Claude Code to view all registered clusters and inspect a specific cluster's configuration.

## List All Clusters

### User Prompt

```
Can you list all the sandbox clusters?
```

### What Claude Does

Claude verifies VPN and authentication, then runs:

```bash
$ sandbox-cli cluster list
```

Output:

```
NAME                VALID  API_URL                                                    CREATED_BY  PLACEMENTS
cluster-9nj2n       yes    https://api.cluster-9nj2n.dynamic.redhatworkshops.io:6443  gucore         0 /   40
cluster-nlkxj       yes    https://api.cluster-nlkxj.dynamic.redhatworkshops.io:6443  judd           2 /   10
cluster-mxq6k       yes    https://api.cluster-mxq6k.dynamic.redhatworkshops.io:6443  ankay          0 /   25
ocpv08              yes    https://api.ocpv08.dal10.infra.demo.redhat.com:6443                     310 /    ?
cluster-dpbwq       yes    https://api.ocp.dpbwq.sandbox5562.opentlc.com:6443         ritesh         2 /    ?
cnv-us-south-ocp-1  NO     https://api.cnv-us-south-ocp-1.rhdp.net:6443                              1 /    ?
ocpvdev01           yes    https://api.ocpvdev01.dal13.infra.demo.redhat.com:6443                   33 /    ?
cnv-us-south-ocp-4  yes    https://api.cnv-us-south-ocp-4.rhdp.net:6443                              4 /    ?
cluster-l8hjq       yes    https://api.cluster-l8hjq.dynamic.redhatworkshops.io:6443  ankay          0 /   25
cluster-rw7lf       yes    https://api.cluster-rw7lf.dynamic.redhatworkshops.io:6443  jboeselm       3 /   30
cluster-ld7tc       yes    https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443  ritesh         0 /    ?
ocpv09              yes    https://api.ocpv09.dal13.infra.demo.redhat.com:6443                     325 /    ?
ocpv03              yes    https://api.ocpv03.dal10.infra.demo.redhat.com:6443                      63 /    ?
ocpv06              yes    https://api.ocpv06.dal10.infra.demo.redhat.com:6443                     290 /    ?
```

### Output Columns

| Column | Description |
|--------|-------------|
| **NAME** | Cluster identifier |
| **VALID** | Whether the cluster is reachable (`yes` / `NO`) |
| **API_URL** | The OCP API endpoint |
| **CREATED_BY** | Who onboarded the cluster |
| **PLACEMENTS** | Current active placements (e.g., `3 / 30` means 3 active out of 30 max) |

### Key Things to Note

- Clusters with `VALID = NO` are unreachable -- they may need `--force` offboarding or investigation
- Clusters with `? ` as max placements have no max_placements limit configured
- Clusters with `0` placements are idle and available for workloads

---

## Get Cluster Details

### User Prompt

```
Can you show me the details of cluster-ld7tc?
```

### What Claude Does

```bash
$ sandbox-cli cluster get cluster-ld7tc
```

Output:

```json
{
  "annotations": {
    "cloud": "cnv-dedicated-shared",
    "lab": "lb1401-sec-genai-guardrails-service",
    "purpose": "dev"
  },
  "api_url": "https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443",
  "created_at": "2026-04-02T05:24:02.783263Z",
  "created_by": "ritesh",
  "data": {
    "connection_last_success_at": "2026-04-02T05:25:14.123456Z",
    "connection_status_at": "2026-04-02T05:25:14.123456Z",
    "deployer_admin_sa_token_updated_at": "2026-04-02T05:25:14.123456Z"
  },
  "deployer_admin_sa_token_refresh_interval": "24h",
  "deployer_admin_sa_token_target_var": "cluster_admin_agnosticd_sa_token",
  "deployer_admin_sa_token_ttl": "48h",
  "ingress_domain": "apps.cluster-ld7tc.dynamic.redhatworkshops.io",
  "name": "cluster-ld7tc",
  "quota_required": false,
  "skip_quota": true,
  "valid": true
}
```

> **Note:** Sensitive fields like `token` are included in the full output but omitted here for security.

### Key Fields

| Field | Description |
|-------|-------------|
| **annotations** | Labels used for placement matching (cloud, purpose, lab) |
| **api_url** | OCP API server endpoint |
| **ingress_domain** | Wildcard domain for routes (e.g., `apps.cluster-xxxxx...`) |
| **valid** | `true` if the cluster is reachable and healthy |
| **created_by** | User who onboarded the cluster |
| **skip_quota** | Whether ResourceQuota enforcement is skipped |
| **deployer_admin_sa_token_ttl** | How long the admin SA token is valid |
| **deployer_admin_sa_token_refresh_interval** | How often the token is refreshed |
| **data.connection_last_success_at** | Last successful API health check |
| **data.deployer_admin_sa_token_updated_at** | Last time the deployer token was rotated |

### Checking Cluster Health

If `data.connection_last_success_at` shows `0001-01-01T00:00:00Z`, the sandbox API hasn't successfully connected yet. This is normal immediately after onboarding -- wait a few minutes for the first health check cycle.

If `valid` is `false`, the cluster is unreachable. Common causes:
- Cluster has been decommissioned
- Network/firewall issues
- API certificate expired
