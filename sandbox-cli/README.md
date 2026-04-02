# Sandbox CLI Plugin

Claude Code plugin for managing OCP shared clusters via [sandbox-cli](https://github.com/rhpds/sandbox).

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| Setup | `/sandbox-cli:sandbox-setup` | Install and configure sandbox-cli |
| Onboard | `/sandbox-cli:cluster-onboard` | Onboard a new OCP shared cluster |
| Offboard | `/sandbox-cli:cluster-offboard` | Offboard an existing cluster |
| Rotate | `/sandbox-cli:cluster-rotate` | Offboard old + onboard new cluster |

## Examples

- [Cluster List & Get Details](examples/cluster-list-and-get-example.md) — View all registered clusters and inspect a specific cluster's configuration
- [Cluster Rotation](examples/cluster-rotate-example.md) — End-to-end example of offboarding an old cluster and onboarding a new one using `/sandbox-cli:cluster-rotate`

## Prerequisites

- Red Hat VPN connection (verified automatically by each skill)
- `oc` CLI installed
- Admin access to target OCP cluster(s)
- A sandbox API login token (JWT) with `shared-cluster-manager` or `admin` role
