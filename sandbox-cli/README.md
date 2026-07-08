# Sandbox CLI Plugin

Claude Code plugin for managing OCP shared clusters via [sandbox-cli](https://github.com/rhpds/sandbox).

**CLI Version:** 1.1.22+

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| Setup | `/sandbox-cli:sandbox-setup` | Install and configure sandbox-cli |
| Onboard | `/sandbox-cli:cluster-onboard` | Onboard a new OCP shared cluster |
| Offboard | `/sandbox-cli:cluster-offboard` | Offboard an existing cluster |
| Rotate | `/sandbox-cli:cluster-rotate` | Offboard old + onboard new cluster (most common) |

## Onboard Options

The `cluster onboard` command supports two modes:

**Inline flags** (simple cases -- no config file needed):
```bash
sandbox-cli cluster onboard my-cluster --purpose dev --annotations '{"cloud":"cnv-shared","lab":"my-lab"}'
```

**JSON config file** (advanced settings -- deployer tokens, rate limiting, quotas):
```bash
sandbox-cli cluster onboard my-cluster --config cluster-config.json
```

### Available Inline Flags

| Flag | Description | Default |
|------|-------------|---------|
| `--purpose` | Purpose annotation | `dev` |
| `--annotations` | Extra annotations as JSON | -- |
| `--max-placements` | Maximum placements (0 = no limit) | `0` |
| `--kubeconfig` | Path to kubeconfig file | current context |
| `--context` | Kubeconfig context to use | current context |
| `--force` | Bypass annotation validation | `false` |
| `--dry-run` | Print payload without sending | `false` |
| `--skip-validation` | Skip post-onboard health check | `false` |

### Cluster Naming

When the API URL has a pattern like `api.ocp.XXXXX.sandboxNNN.opentlc.com`, the auto-extracted name will be `ocp` (not the unique identifier). Always provide an explicit cluster name in these cases:
```bash
sandbox-cli cluster onboard cluster-XXXXX --config cluster-config.json
```

## Locked Clusters

Clusters can be locked (disabled) by admins. A locked cluster cannot be offboarded until unlocked:

```
Error: HTTP 409: cluster is locked. Unlock the cluster first.
```

To unlock (requires `admin` role):
```bash
sandbox-cli cluster enable <CLUSTER_NAME>
```

## Admin-Only Commands

| Command | Description |
|---------|-------------|
| `sandbox-cli cluster enable <NAME>` | Unlock/enable a cluster |
| `sandbox-cli cluster disable <NAME>` | Lock/disable a cluster |
| `sandbox-cli cluster health <NAME>` | Check cluster connectivity |
| `sandbox-cli cluster delete <NAME>` | Delete a cluster config (prefer offboard) |
| `sandbox-cli cluster create` | Create/update a cluster config directly |

## Examples

- [Cluster List & Get Details](examples/cluster-list-and-get-example.md) — View all registered clusters and inspect a specific cluster's configuration
- [Cluster Rotation](examples/cluster-rotate-example.md) — End-to-end example of offboarding an old cluster and onboarding a new one using `/sandbox-cli:cluster-rotate`

## Prerequisites

- Red Hat VPN connection (verified automatically by each skill)
- `oc` CLI installed
- Admin access to target OCP cluster(s)
- A sandbox API login token (JWT) with `shared-cluster-manager` or `admin` role
