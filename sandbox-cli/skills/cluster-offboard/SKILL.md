---
name: sandbox-cli:cluster-offboard
description: This skill should be used when the user asks to "offboard a cluster", "remove a cluster from sandbox", "decommission a cluster", "sandbox offboard", "take a cluster offline", or "remove a shared cluster".
---

---
context: main
---

# Skill: cluster-offboard

**Name:** Sandbox Cluster Offboard
**Description:** Offboard an existing OCP shared cluster from the RHDP Sandbox API.

---

## Purpose

Walk the user through safely offboarding an OCP shared cluster from the Sandbox API. This includes verifying VPN connectivity, identifying the cluster, checking active placements, running the offboard, and verifying cleanup.

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

### Step 4: Identify the Cluster to Offboard

List all clusters to help the user identify which one to offboard:

```bash
sandbox-cli cluster list
```

Output columns:
- **NAME** - Cluster identifier
- **VALID** - Whether the cluster is reachable (`yes` / `NO`)
- **CREATED_BY** - Who onboarded it
- **PLACEMENTS** - Current active placements (e.g., `3 / 10`)

Ask the user which cluster to offboard. Note the cluster name and current placement count.

**IMPORTANT:** If the cluster has active placements, warn the user that offboarding will clean them up. The user should confirm they want to proceed.

### Step 5: Get Cluster Details (Optional)

For additional context before offboarding:

```bash
sandbox-cli cluster get <CLUSTER_NAME>
```

This shows full configuration, annotations, and connection status.

### Step 6: Login to the Cluster (if reachable)

If the cluster is still reachable (VALID = yes), login to it so the offboard can clean up resources:

```bash
oc login --token=<ADMIN_TOKEN> --server=<CLUSTER_API_URL>
```

If the cluster is unreachable (VALID = NO), the `--force` flag will be needed in Step 7.

### Step 7: Run the Offboard

```bash
sandbox-cli cluster offboard <CLUSTER_NAME>
```

If the cluster is unreachable, use force mode:

```bash
sandbox-cli cluster offboard <CLUSTER_NAME> --force
```

**What this does:**
1. Disables scheduling on the cluster
2. Cleans up all active placements (namespaces, service accounts, quotas, etc.)
3. Removes the cluster configuration from the sandbox API
4. Polls for completion (up to 6 minutes, checking every 3 seconds)

Expected output:
```
==> Offboarding cluster '<CLUSTER_NAME>'...
  Offboard started for cluster <CLUSTER_NAME>. N placement(s) to process.
  Poll GET /api/v1/ocp-shared-cluster-configurations/<CLUSTER_NAME>/offboard for status.

==> Waiting for offboard to complete...
  Offboard completed successfully.
```

If the offboard is taking long, check status manually:

```bash
sandbox-cli cluster offboard-status <CLUSTER_NAME>
```

### Step 8: Verify Offboard

Confirm the cluster is no longer listed:

```bash
sandbox-cli cluster list
```

The offboarded cluster should no longer appear in the list.

## Troubleshooting

### HTTP 409: Cluster is locked

If offboard returns:

```
Error: HTTP 409: {"http_code":409,"message":"cluster \"<CLUSTER_NAME>\" is locked. Unlock the cluster first."}
```

The cluster has been locked (disabled) by an admin. To unlock it:

```bash
sandbox-cli cluster enable <CLUSTER_NAME>
```

**NOTE:** The `enable` command requires the `admin` role. If your token has `shared-cluster-manager` role, you will need to ask an admin to unlock the cluster before you can offboard it.

### Offboard taking too long

If the offboard seems stuck, check status manually:

```bash
sandbox-cli cluster offboard-status <CLUSTER_NAME>
```

## Admin-Only Commands Reference

These commands require the `admin` role and are useful for cluster management:

| Command | Description |
|---------|-------------|
| `sandbox-cli cluster enable <NAME>` | Unlock/enable a cluster (required before offboarding a locked cluster) |
| `sandbox-cli cluster disable <NAME>` | Lock/disable a cluster (prevents new placements and offboarding) |
| `sandbox-cli cluster health <NAME>` | Check cluster connectivity and health status |
| `sandbox-cli cluster delete <NAME>` | Delete a cluster configuration (use offboard instead when possible) |

## Important Notes

- **Force offboard** (`--force`) should only be used when the target cluster is permanently unreachable or decommissioned. It leaves orphaned resources (namespaces, service accounts, Ceph resources, Keycloak users) on the cluster.
- Only `admin` and `shared-cluster-manager` (for own clusters) can offboard.
- Offboarding is asynchronous -- it may return HTTP 202 and poll for completion.
- If offboard fails partway through, some placements may require manual cleanup. The output will list these.
- Always verify with `sandbox-cli cluster list` after offboarding.
- A locked cluster cannot be offboarded -- it must be unlocked first by an admin using `sandbox-cli cluster enable`.
