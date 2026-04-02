# Example: Cluster Rotation with `/sandbox-cli:cluster-rotate`

This example shows a real cluster rotation workflow executed via Claude Code using the `sandbox-cli:cluster-rotate` skill.

## Scenario

Rotate a CNV dedicated cluster for the `lb1401-sec-genai-guardrails-service` lab:
- **Old cluster:** `cluster-tdsqt` (2 active placements)
- **New cluster:** `cluster-ld7tc`

## User Prompt

```
/sandbox-cli:cluster-rotate
```

Then provide the details when asked:

```
old cluster name cluster-tdsqt admin password is <ADMIN_PASSWORD>
new cluster name cluster-ld7tc admin password is <ADMIN_PASSWORD> and api is: https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443
clusterconfig.json :
{
  "annotations": {
    "cloud": "cnv-dedicated-shared",
    "purpose": "dev",
    "lab": "lb1401-sec-genai-guardrails-service"
  },
  "deployer_admin_sa_token_ttl": "48h",
  "deployer_admin_sa_token_refresh_interval": "24h",
  "deployer_admin_sa_token_target_var": "cluster_admin_agnosticd_sa_token",
  "skip_quota": true
}
```

## What Claude Does

### Step 1: Verify Prerequisites

Claude checks that `sandbox-cli` and `oc` are installed, verifies VPN connectivity via `host squid.redhat.com`, and confirms authentication with `sandbox-cli status`.

### Step 2: List Clusters and Confirm

Claude runs `sandbox-cli cluster list` and identifies the old cluster:

```
NAME             VALID  API_URL                                                    CREATED_BY  PLACEMENTS
cluster-tdsqt    yes    https://api.cluster-tdsqt.dynamic.redhatworkshops.io:6443  ritesh         2 /    ?
```

Since `cluster-tdsqt` has 2 active placements, Claude warns:

> I can see cluster-tdsqt has 2 active placements. Offboarding will clean these up. Do you confirm?

### Step 3: Offboard Old Cluster

After confirmation, Claude logs in and offboards:

```bash
$ oc login -u admin -p <ADMIN_PASSWORD> --server=https://api.cluster-tdsqt.dynamic.redhatworkshops.io:6443 --insecure-skip-tls-verify

$ sandbox-cli cluster offboard cluster-tdsqt
```

Output:

```
==> Offboarding cluster 'cluster-tdsqt'...
  Offboard started for cluster cluster-tdsqt. 2 placement(s) to process.
  Poll GET /api/v1/ocp-shared-cluster-configurations/cluster-tdsqt/offboard for status.

==> Waiting for offboard to complete...
  Offboard completed successfully.
```

Claude verifies removal with `sandbox-cli cluster list`.

### Step 4: Onboard New Cluster

Claude writes the config file, logs in to the new cluster, and onboards:

```bash
$ oc login -u admin -p <ADMIN_PASSWORD> --server=https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443 --insecure-skip-tls-verify

$ sandbox-cli cluster onboard cluster-ld7tc --config clusterconfig.json
```

Output:

```
==> Checking cluster access...
  API URL: https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443
  Ingress: apps.cluster-ld7tc.dynamic.redhatworkshops.io
  Name:    cluster-ld7tc

==> Creating service account...
  Creating namespace 'rhdp-serviceaccounts'...
  Creating service account 'sandbox-api-manager'...
  Granting cluster-admin to 'sandbox-api-manager'...
  Creating long-lived token (~10 years)...
  Token created successfully.

==> Registering cluster with sandbox API...
  OCP shared cluster configuration created

==> Validating cluster health...
  WARNING: health check returned HTTP 401

==> Cluster registered successfully.

AgnosticV cloud_selector:
  lab: lb1401-sec-genai-guardrails-service
  purpose: dev
```

> **Note:** The HTTP 401 warning is normal immediately after onboarding -- the sandbox API token rotation hasn't completed yet.

### Step 5: Verify and Test

Claude runs verification:

```bash
$ sandbox-cli cluster get cluster-ld7tc
# Confirms: valid=true, annotations correct, ingress_domain set

$ sandbox-cli placement dry-run --selector 'lab=lb1401-sec-genai-guardrails-service,purpose=dev'
```

Output:

```
Result: MATCH
Selector: lab=lb1401-sec-genai-guardrails-service,purpose=dev

  Matching OCP shared clusters found
  Matching clusters: 1
    - cluster-ld7tc
```

### Step 6: Summary

Claude provides a final summary:

| Step | Result |
|------|--------|
| **Offboarded** | `cluster-tdsqt` -- 2 placements cleaned up |
| **Onboarded** | `cluster-ld7tc` -- registered successfully |
| **Valid** | `true` |
| **Placement dry-run** | **MATCH** |
| **Token rotation** | Pending (48h TTL, 24h refresh configured) |

## Total Time

The entire rotation took approximately **2 minutes** end-to-end, including the offboard polling wait.
