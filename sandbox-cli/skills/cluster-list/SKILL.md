---
name: sandbox-cli:cluster-list
description: This skill should be used when the user asks to "list clusters", "show all clusters", "list sandbox clusters", "show registered clusters", "what clusters are available", or "cluster list".
---

---
context: main
---

# Skill: cluster-list

**Name:** Sandbox Cluster List
**Description:** List all OCP shared clusters registered with the RHDP Sandbox API.

---

## Purpose

Display all registered OCP shared clusters with their status, API URLs, owners, and active placement counts. This is useful for getting an overview of cluster inventory, identifying idle or unreachable clusters, and finding a cluster to onboard/offboard/rotate.

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

### Step 4: List All Clusters

```bash
sandbox-cli cluster list
```

Expected output:

```
NAME                VALID  API_URL                                                    CREATED_BY  PLACEMENTS
cluster-9nj2n       yes    https://api.cluster-9nj2n.dynamic.redhatworkshops.io:6443  gucore         0 /   40
cluster-nlkxj       yes    https://api.cluster-nlkxj.dynamic.redhatworkshops.io:6443  judd           2 /   10
ocpv08              yes    https://api.ocpv08.dal10.infra.demo.redhat.com:6443                     310 /    ?
cnv-us-south-ocp-1  NO     https://api.cnv-us-south-ocp-1.rhdp.net:6443                              1 /    ?
cluster-ld7tc       yes    https://api.cluster-ld7tc.dynamic.redhatworkshops.io:6443  ritesh         0 /    ?
```

### Step 5: Summarize for the User

Present the cluster list and highlight:

- **Total cluster count**
- **Healthy clusters** (`VALID = yes`)
- **Unreachable clusters** (`VALID = NO`) -- flag these for attention
- **Clusters with active placements** vs idle clusters
- **Clusters at or near capacity** (placements close to max)

## Output Columns

| Column | Description |
|--------|-------------|
| **NAME** | Cluster identifier |
| **VALID** | Whether the cluster is reachable (`yes` / `NO`) |
| **API_URL** | The OCP API server endpoint |
| **CREATED_BY** | Who onboarded the cluster (blank for infrastructure clusters) |
| **PLACEMENTS** | Active placements vs max (e.g., `3 / 30`). `?` means no max configured |

## Important Notes

- Clusters with `VALID = NO` are unreachable and may need investigation or forced offboarding.
- Clusters with `?` as max placements have no `max_placements` limit configured.
- Clusters with `0` placements are idle and available for workloads.
- If the user wants more details about a specific cluster, suggest using `/sandbox-cli:cluster-details`.
