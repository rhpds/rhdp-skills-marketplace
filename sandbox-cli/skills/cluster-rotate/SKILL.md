---
name: sandbox-cli:cluster-rotate
description: This skill should be used when the user asks to "rotate a cluster", "replace a cluster", "swap clusters", "offboard old and onboard new cluster", "cluster rotation", "replace an old cluster with a new one", or "refresh cluster".
---

---
context: main
---

# Skill: cluster-rotate

**Name:** Sandbox Cluster Rotation
**Description:** Offboard an older OCP shared cluster and onboard a new replacement cluster in a single workflow.

---

## Purpose

Full end-to-end workflow for rotating a shared cluster: safely offboard an existing cluster and onboard its replacement. This is the most common operational workflow for maintaining shared cluster infrastructure on RHDP.

## Workflow

### Step 1: Verify Prerequisites

Check that sandbox-cli and oc are installed:

```bash
which sandbox-cli
which oc
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

### Step 4: Gather Information

Ask the user for:

1. **Old cluster** to offboard:
   - Cluster name (or help them identify it from `sandbox-cli cluster list`)
   - Admin credentials (oc login token) for the old cluster

2. **New cluster** to onboard:
   - API URL for the new cluster (e.g., `https://api.cluster-xxxxx.dynamic.redhatworkshops.io:6443`)
   - Admin credentials (oc login token or from OpenShift console)

3. **Cluster config** for the new cluster:
   - An existing config file (e.g., `cluster-config.json`, `cluster-config-cnv.json`)
   - Or details to create one (cloud, purpose, lab annotations, etc.)

### Step 5: List Current Clusters

```bash
sandbox-cli cluster list
```

Help the user identify the old cluster to offboard. Note:
- Cluster name
- Current placement count (warn if placements are active)
- VALID status

### Step 6: Offboard the Old Cluster

#### 6a. Login to the old cluster

```bash
oc login --token=<OLD_CLUSTER_TOKEN> --server=<OLD_CLUSTER_API_URL>
```

#### 6b. Run the offboard

```bash
sandbox-cli cluster offboard <OLD_CLUSTER_NAME>
```

If the old cluster is unreachable (VALID = NO):

```bash
sandbox-cli cluster offboard <OLD_CLUSTER_NAME> --force
```

Wait for completion. Expected output:

```
==> Offboarding cluster '<OLD_CLUSTER_NAME>'...
  Offboard started for cluster <OLD_CLUSTER_NAME>. N placement(s) to process.

==> Waiting for offboard to complete...
  Offboard completed successfully.
```

#### 6c. Verify offboard

```bash
sandbox-cli cluster list
```

Confirm the old cluster is no longer in the list.

### Step 7: Onboard the New Cluster

#### 7a. Login to the new cluster

```bash
oc login --token=<NEW_CLUSTER_TOKEN> --server=<NEW_CLUSTER_API_URL>
```

Accept insecure TLS if prompted.

Verify:
```bash
oc whoami
```

#### 7b. Prepare config file (if needed)

If the user doesn't have a config file, create one. Use the same annotations as the old cluster for a like-for-like replacement.

Example for CNV dedicated (lab-specific):

```json
{
  "annotations": {
    "cloud": "cnv-dedicated-shared",
    "purpose": "dev",
    "lab": "<lab-annotation>"
  },
  "deployer_admin_sa_token_ttl": "48h",
  "deployer_admin_sa_token_refresh_interval": "24h",
  "deployer_admin_sa_token_target_var": "cluster_admin_agnosticd_sa_token",
  "skip_quota": true
}
```

Example for general shared cluster:

```json
{
  "annotations": {
    "cloud": "cnv-dedicated-shared",
    "purpose": "events",
    "virt": "yes"
  },
  "deployer_admin_sa_token_ttl": "1h",
  "deployer_admin_sa_token_refresh_interval": "30m",
  "deployer_admin_sa_token_target_var": "cluster_admin_agnosticd_sa_token",
  "max_placements": 30,
  "settings": {
    "provision_rate_limit": 50,
    "provision_rate_window": "10m"
  }
}
```

#### 7c. Run the onboard

```bash
sandbox-cli cluster onboard <NEW_CLUSTER_NAME> --config <CONFIG_FILE>
```

The cluster name is optional -- extracted from the API URL if omitted.

Expected output:

```
==> Checking cluster access...
  API URL: https://api.cluster-xxxxx:6443
  Ingress: apps.cluster-xxxxx.example.com
  Name:    cluster-xxxxx

==> Creating service account...
  Creating namespace 'rhdp-serviceaccounts'...
  Creating service account 'sandbox-api-manager'...
  Granting cluster-admin to 'sandbox-api-manager'...
  Creating long-lived token (~10 years)...
  Token created successfully.

==> Registering cluster with sandbox API...
  OCP shared cluster configuration created

==> Cluster registered successfully.

AgnosticV cloud_selector:
  lab: <lab-annotation>
  purpose: dev
```

### Step 8: Verify the New Cluster

#### 8a. Check registration

```bash
sandbox-cli cluster get <NEW_CLUSTER_NAME>
```

Verify:
- `valid` is `true`
- `annotations` are correct
- `api_url` and `ingress_domain` look right

#### 8b. Test placement matching

```bash
sandbox-cli placement dry-run --selector 'lab=<LAB>,purpose=<PURPOSE>'
```

Or with an AgnosticV catalog file:

```bash
sandbox-cli placement dry-run -f <path-to-common.yaml>
```

Expected:

```
Result: MATCH
Matching clusters: 1
  - cluster-xxxxx
```

#### 8c. Confirm in cluster list

```bash
sandbox-cli cluster list
```

The new cluster should appear with VALID = yes and 0 placements.

### Step 9: Summary

Report to the user:
- Old cluster offboarded: `<OLD_CLUSTER_NAME>` (N placements cleaned up)
- New cluster onboarded: `<NEW_CLUSTER_NAME>`
- Placement dry-run result: MATCH / NO MATCH
- Any warnings or issues encountered

## Important Notes

- Always offboard the old cluster BEFORE onboarding the new one to avoid placement conflicts (especially for lab-specific annotations).
- If the old cluster has active placements, warn the user before proceeding -- offboarding will terminate those placements.
- A health check warning (HTTP 401) right after onboard is normal -- token rotation may not have completed yet.
- For like-for-like rotation, reuse the same config file / annotations so the new cluster matches the same AgnosticV catalog selectors.
- The `--force` flag for offboard should only be used when the old cluster is permanently unreachable.
- `deployer_admin_sa_token_*` fields are required if workloads need cluster-admin access.
