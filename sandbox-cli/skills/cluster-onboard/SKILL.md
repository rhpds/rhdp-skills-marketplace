---
name: sandbox-cli:cluster-onboard
description: This skill should be used when the user asks to "onboard a cluster", "add a cluster to sandbox", "register a cluster", "onboard OCP cluster", "sandbox onboard", or "add a new shared cluster".
---

---
context: main
---

# Skill: cluster-onboard

**Name:** Sandbox Cluster Onboard
**Description:** Onboard a new OCP shared cluster to the RHDP Sandbox API.

---

## Purpose

Walk the user through onboarding a new OpenShift cluster to the Sandbox API. This includes verifying prerequisites, checking VPN, logging in to the target cluster, creating the onboard config, running the onboard command, and verifying the result.

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

### Step 4: Gather Information

Ask the user for:

1. **New cluster API URL** - e.g., `https://api.cluster-xxxxx.dynamic.redhatworkshops.io:6443`
2. **Admin credentials** - `oc login` token or kubeconfig for the new cluster
3. **Cluster config** - Either:
   - An existing config file path (e.g., `cluster-config.json` or `cluster-config-cnv.json`)
   - Or the following details to create one:
     - `cloud` annotation (e.g., `cnv-dedicated-shared`, `aws-shared`)
     - `purpose` annotation (e.g., `dev`, `events`, `prod`)
     - `lab` annotation (e.g., `lb1401-sec-genai-guardrails-service`)
     - Any additional annotations (`virt`, `keycloak`, etc.)
     - `skip_quota` (true/false, default false)
     - `max_placements` (0 = unlimited)
     - Deployer admin SA token settings (ttl, refresh interval, target var)
     - Rate limiting settings (optional)

### Step 5: Login to Target Cluster

The user must be logged into the target OCP cluster as admin:

```bash
oc login --token=<ADMIN_TOKEN> --server=<CLUSTER_API_URL>
```

If certificate warning appears, the user may need to accept insecure connections.

Verify login:
```bash
oc whoami
oc cluster-info
```

### Step 6: Prepare Config (config file or inline flags)

There are two ways to pass cluster configuration:

#### Option A: Inline flags (simple cases)

For simple onboards, use CLI flags directly -- no config file needed:

```bash
sandbox-cli cluster onboard my-cluster --purpose dev --annotations '{"cloud":"cnv-shared","lab":"my-lab"}'
```

Available inline flags:

| Flag | Description | Example |
|------|-------------|---------|
| `--purpose` | Purpose annotation (default "dev") | `--purpose events` |
| `--annotations` | Extra annotations as JSON | `--annotations '{"cloud":"cnv-shared","virt":"yes"}'` |
| `--max-placements` | Maximum placements (0 = no limit) | `--max-placements 30` |
| `--kubeconfig` | Path to kubeconfig file | `--kubeconfig /path/to/kubeconfig` |
| `--context` | Kubeconfig context to use | `--context my-cluster-admin` |
| `--force` | Bypass annotation validation | `--force` |

#### Option B: JSON config file (advanced settings)

For advanced settings (deployer tokens, rate limiting, quotas), create a JSON config file.

Example for CNV dedicated:

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

Example for general shared cluster with rate limiting:

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

### Step 7: Onboard the Cluster

Run the onboard command:

```bash
# With config file
sandbox-cli cluster onboard <CLUSTER_NAME> --config <CONFIG_FILE>

# With inline flags (simple cases)
sandbox-cli cluster onboard <CLUSTER_NAME> --purpose dev --annotations '{"cloud":"cnv-shared","lab":"my-lab"}'
```

The cluster name is optional -- if omitted, it's extracted from the API URL (e.g., `cluster-tdsqt` from `https://api.cluster-tdsqt.dynamic.redhatworkshops.io:6443`).

**IMPORTANT:** When the API URL has a pattern like `api.ocp.XXXXX.sandboxNNN.opentlc.com`, the auto-extracted name will be `ocp` (not the unique identifier). Always provide an explicit cluster name in these cases (e.g., `cluster-XXXXX`).

**What this does automatically:**
1. Connects to target OCP cluster via current kubeconfig context
2. Creates namespace `rhdp-serviceaccounts`
3. Creates service account `sandbox-api-manager`
4. Grants `cluster-admin` to the service account
5. Creates a long-lived token (~10 years)
6. Registers the cluster with the sandbox API
7. Validates cluster health

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

==> Validating cluster health...

==> Cluster registered successfully.
```

### Step 8: Verify Registration

```bash
sandbox-cli cluster get <CLUSTER_NAME>
```

Check that:
- `valid` is `true`
- `annotations` match the config
- `api_url` and `ingress_domain` are correct
- `deployer_admin_sa_token_ttl` and related fields are set (if configured)

### Step 9: Test Placement Matching

Run a dry-run to confirm the cluster matches expected selectors:

```bash
sandbox-cli placement dry-run --selector 'lab=<LAB>,purpose=<PURPOSE>'
```

Or test against an AgnosticV catalog file:

```bash
sandbox-cli placement dry-run -f <path-to-common.yaml>
```

Expected output:
```
Result: MATCH
Matching clusters: 1
  - cluster-xxxxx
```

### Step 10: Verify Deployer Admin Token (if configured)

Wait ~10 seconds for the sandbox API to generate the deployer admin token, then:

```bash
sandbox-cli cluster get <CLUSTER_NAME>
```

Check `data.deployer_admin_sa_token_updated_at` is no longer `0001-01-01T00:00:00Z`.

## Important Notes

- The `--dry-run` flag can be used to preview the onboard payload without sending it
- The `--skip-validation` flag skips the post-onboard health check
- A health check warning (HTTP 401) right after onboard is normal -- the sandbox API token rotation may not have completed yet
- The service account token auto-renews via the sandbox API's token rotation goroutine
- `deployer_admin_sa_token_*` fields are REQUIRED if workloads need cluster-scoped access (e.g., creating namespaces, installing operators)
