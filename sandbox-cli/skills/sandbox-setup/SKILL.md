---
name: sandbox-cli:sandbox-setup
description: This skill should be used when the user asks to "install sandbox-cli", "setup sandbox", "configure sandbox-cli", "get sandbox-cli working", "download sandbox-cli", or "I don't have sandbox-cli installed".
---

---
context: main
---

# Skill: sandbox-setup

**Name:** Sandbox CLI Setup
**Description:** Install and configure the sandbox-cli tool for managing OCP shared clusters via the RHDP Sandbox API.

---

## Purpose

Guide the user through installing sandbox-cli and authenticating with the Sandbox API. This skill handles platform detection, binary download, VPN verification, and initial login.

## Workflow

### Step 1: Detect Platform

Determine the user's OS and architecture:

```bash
uname -s   # Darwin or Linux
uname -m   # arm64 or x86_64
```

Map to binary name:
- macOS Apple Silicon: `sandbox-cli-darwin-arm64`
- macOS Intel: `sandbox-cli-darwin-amd64`
- Linux x86_64: `sandbox-cli-linux-amd64`
- Linux ARM: `sandbox-cli-linux-arm64`

### Step 2: Check if Already Installed

```bash
which sandbox-cli && sandbox-cli version
```

If already installed, check if it's up to date by running `sandbox-cli status` and skip to Step 4.

### Step 3: Download and Install

Download the latest release from GitHub:

```bash
# Get latest release URL
PLATFORM="darwin-arm64"  # adjust based on Step 1
curl -sL "https://github.com/rhpds/sandbox/releases/latest/download/sandbox-cli-${PLATFORM}" -o /usr/local/bin/sandbox-cli
chmod +x /usr/local/bin/sandbox-cli
```

If `/usr/local/bin` requires sudo, suggest:
```bash
curl -sL "https://github.com/rhpds/sandbox/releases/latest/download/sandbox-cli-${PLATFORM}" -o ~/bin/sandbox-cli
chmod +x ~/bin/sandbox-cli
# Ensure ~/bin is in PATH
```

Verify installation:
```bash
sandbox-cli version
```

### Step 4: Verify Red Hat VPN Connection

**CRITICAL:** The sandbox API is IP-restricted. The user MUST be on Red Hat VPN. Always verify VPN connectivity before any sandbox-cli operation.

Run this check:

```bash
host squid.redhat.com
```

**If the DNS resolves** (returns an IP address like `10.x.x.x`), the user is on VPN. Proceed.

**If it fails** with `NXDOMAIN`, `not found`, or `connection timed out`, the user is NOT on VPN. Stop and tell them:

> You are NOT connected to the Red Hat VPN. The sandbox API is IP-restricted and all commands will fail with EOF errors. Please connect to the Red Hat VPN before proceeding.

Do NOT proceed with login or any sandbox-cli commands until VPN is confirmed.

### Step 5: Login

Ask the user for:
1. **Server URL** - The sandbox API endpoint (default: `https://restricted-babylon-sandbox-api.apps.infra-us-east-1.infra.demo.redhat.com`)
2. **Login Token** - A JWT token issued by a sandbox admin

Then run:
```bash
sandbox-cli login --server <SERVER_URL> --token <TOKEN>
```

Expected output on success:
```
Authenticating with <SERVER_URL>...
Using Red Hat VPN proxy (squid.redhat.com:3128)
Login successful. Access token saved to ~/.local/sandbox-cli/config.json
Token expires: <date>
```

If you get an `EOF` error, the VPN check in Step 4 may have given a false positive. Ask the user to verify their VPN connection and retry.

### Step 6: Verify

```bash
sandbox-cli status
```

This shows client version, server connection, proxy status, and authentication state.

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `EOF` error on login | Not on VPN | Connect to Red Hat VPN, verify with `host squid.redhat.com` |
| `authentication failed` | Invalid or expired token | Get a new token from a sandbox admin |
| `command not found` | Binary not in PATH | Check install location and PATH |
| `permission denied` | Binary not executable | Run `chmod +x /path/to/sandbox-cli` |

## Important Notes

- Configuration is saved to `~/.local/sandbox-cli/config.json`
- Access tokens auto-refresh when expired
- The CLI auto-detects Red Hat VPN and uses squid proxy (`squid.redhat.com:3128`)
- Requires Go 1.22+ if building from source
