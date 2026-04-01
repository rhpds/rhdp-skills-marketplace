# Sandbox Plugin

Claude Code plugin for managing OCP shared clusters via [sandbox-cli](https://github.com/rhpds/sandbox).

## Skills

| Skill | Invoke | Description |
|-------|--------|-------------|
| Setup | `/sandbox:sandbox-setup` | Install and configure sandbox-cli |
| Onboard | `/sandbox:cluster-onboard` | Onboard a new OCP shared cluster |
| Offboard | `/sandbox:cluster-offboard` | Offboard an existing cluster |
| Rotate | `/sandbox:cluster-rotate` | Offboard old + onboard new cluster |

## Prerequisites

- Red Hat VPN connection (verified automatically by each skill)
- `oc` CLI installed
- Admin access to target OCP cluster(s)
- A sandbox API login token (JWT) with `shared-cluster-manager` or `admin` role
