---
name: sandbox-cli:cluster-details
description: This skill should be used when the user asks to "show cluster details", "get cluster info", "describe cluster", "cluster details", "inspect cluster", or "show cluster configuration".
---

---
context: main
---

# Skill: cluster-details

**Name:** Sandbox Cluster Details
**Description:** Get detailed configuration and status of a specific OCP shared cluster registered with the RHDP Sandbox API.

---

## Purpose

Display the full configuration, annotations, health status, token rotation state, and quota settings for a specific cluster. This is useful for debugging cluster issues, verifying onboard configuration, or checking token rotation health.

## Workflow

### Step 1: Verify Prerequisites

Check that sandbox-cli is installed:

```bash
which sandbox-cli
```

If sandbox-cli is not installed, tell the user to run `/sandbox-cli:sandbox-setup` first and stop.

### Step 2: Verify Red Hat VPN Connection

**CRITICAL:** Always verify VPN connectivity before any sandbox-cli operation.

```bash
host squid.redhat.com
```

**If the DNS resolves** (returns an IP address like `10.x.x.x`), the user is on VPN. Proceed.

**If it fails** with `NXDOMAIN`, `not found`, or `connection timed out`, STOP and tell the user:

> You are NOT connected to the Red Hat VPN. The sandbox API is IP-restricted and all commands will fail with EOF errors. Please connect to the Red Hat VPN before proceeding.

Do NOT proceed until VPN is confirmed.

### Step 3: Check Authentication

```bash
sandbox-cli status
```

If not authenticated or token expired, tell the user to re-login:
```bash
sandbox-cli login --server <SERVER_URL> --token <TOKEN>
```

### Step 4: Identify the Cluster

If the user hasn't specified a cluster name, list all clusters to help them choose:

```bash
sandbox-cli cluster list
```

Ask the user which cluster they want details for.

### Step 5: Get Cluster Details

```bash
sandbox-cli cluster get <CLUSTER_NAME>
```

Expected output:

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

### Step 6: Summarize for the User

Present the key information in a readable format:

| Field | Value |
|-------|-------|
| **Name** | cluster name |
| **Valid** | yes/no |
| **API URL** | the API endpoint |
| **Ingress Domain** | the wildcard domain for routes |
| **Created By** | who onboarded it |
| **Created At** | when it was onboarded |
| **Annotations** | cloud, purpose, lab labels |
| **Skip Quota** | whether quota enforcement is skipped |
| **Token TTL** | deployer admin SA token lifetime |
| **Token Refresh** | how often the token is refreshed |
| **Last Connection** | last successful health check |
| **Token Last Updated** | last token rotation timestamp |

Also flag any potential issues:
- If `valid` is `false`, the cluster is unreachable
- If `data.connection_last_success_at` is `0001-01-01T00:00:00Z`, the sandbox API hasn't connected yet
- If `data.deployer_admin_sa_token_updated_at` is `0001-01-01T00:00:00Z`, token rotation hasn't completed

## Key Fields

| Field | Description |
|-------|-------------|
| **annotations** | Labels used for placement matching (`cloud`, `purpose`, `lab`) |
| **api_url** | OCP API server endpoint |
| **ingress_domain** | Wildcard domain for routes (e.g., `apps.cluster-xxxxx...`) |
| **valid** | `true` if the cluster is reachable and healthy |
| **created_by** | User who onboarded the cluster |
| **skip_quota** | Whether ResourceQuota enforcement is skipped |
| **deployer_admin_sa_token_ttl** | How long the admin SA token is valid |
| **deployer_admin_sa_token_refresh_interval** | How often the token is refreshed |
| **deployer_admin_sa_token_target_var** | Variable name used to pass the token to deployers |
| **data.connection_last_success_at** | Last successful API health check |
| **data.deployer_admin_sa_token_updated_at** | Last time the deployer token was rotated |

## Important Notes

- The full output includes the cluster's service account `token` -- this is sensitive and should not be shared.
- If `data.connection_last_success_at` shows `0001-01-01T00:00:00Z`, the sandbox API hasn't successfully connected yet. This is normal immediately after onboarding -- wait a few minutes for the first health check cycle.
- If `valid` is `false`, the cluster is unreachable. Common causes: cluster decommissioned, network/firewall issues, or API certificate expired.
- To test if a cluster matches specific workload selectors, use `sandbox-cli placement dry-run --selector 'key=value'`.
