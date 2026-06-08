# Publishing House Automation Patterns

Guidance for the automation agent when creating AgnosticV catalogs and developing
environment automation. These supplement the agnosticv skill rules — do not duplicate them.

## When Automation Runs

The automation agent only runs when `lifecycle.phases.automation.needs_automation` is `true`
in the manifest. This is set during intake based on the user's answer about environment
automation needs.

If `needs_automation` is `false` or `null`, the orchestrator skips automation entirely
and marks the phase as `skipped`.

## Sub-Phase Ordering

Automation has four sub-phases tracked in the manifest:

| Sub-Phase | Manifest Key | Status | Description |
|-----------|-------------|--------|-------------|
| 7a: Automation Requirements | `substeps.requirements` | pending → completed | Reviewable scope document (what to automate) |
| 7b: Catalog Item | `substeps.catalog_item` | pending → completed | AgnosticV catalog configuration |
| 7c: Automation Code | `substeps.automation_code` | pending → completed | Ansible collection or GitOps repo |
| 7d: Testing | `substeps.testing` | pending → completed | Deploy and verify automation works |
| 7e: E2E Checks | `substeps.e2e_checks` | deferred | End-to-end validation (future) |

Sub-phases run in order: requirements first (captures the full automation scope upfront),
then catalog item (creates the AgnosticV catalog informed by those requirements — skipped
for self-published projects), then automation code (writes from the approved requirements),
then testing (human deploys and verifies the automation works on a real environment).

## Infrastructure Type Routing

The automation agent determines infrastructure type from two sources:

1. **Design spec** (`publishing-house/spec/design.md`) — infrastructure requirements section
2. **User confirmation** — the catalog-builder skill asks detailed infrastructure questions

| Infrastructure | AgnosticV Config | Automation Pattern |
|---------------|-----------------|-------------------|
| OCP cluster (CNV) | `config: openshift-workloads`, `cloud_provider: cnv` | OCP workloads via Ansible roles |
| OCP cluster (AWS) | `config: openshift-workloads`, `cloud_provider: ec2` | OCP workloads via Ansible roles |
| RHEL/AAP VMs | `config: cloud-vms-base` | Cloud VM provisioning + Ansible roles |
| Sandbox (Cluster) | `config: openshift-cluster` | Namespace-scoped workloads |
| Sandbox (Tenant) | `config: namespace` | Tenant-scoped workloads |

## Catalog Creation (7b) — Wrapping agnosticv:catalog-builder

### Input Mapping from PH Context

The catalog-builder skill asks its own questions interactively. Pre-fill answers from
the PH spec where possible:

| Catalog-Builder Question | PH Source |
|--------------------------|-----------|
| Catalog type (lab/demo/sandbox) | `project.type` in manifest |
| Event context | Ask user (not in PH spec) |
| Technologies | Products from design.md |
| Display name | `project.name` from manifest |
| Short name | `project.id` from manifest |
| Description | Problem statement from design.md |
| Maintainer | `project.owner_name` / `project.owner_github` from manifest |
| Infrastructure type | Infrastructure requirements from design.md |

Let the catalog-builder skill handle infrastructure-specific questions — it has
detailed reference docs for OCP, VMs, and Sandbox configurations.

### Post-Catalog Validation

After catalog-builder generates files, immediately invoke `agnosticv:validator`
at scope level 2 (Standard) to catch issues before moving to environment automation.

If validation fails:
- Present errors to user
- Offer to fix and re-validate
- Do not proceed to 7c until catalog validates cleanly

### Catalog Output Tracking

Record the AgnosticV catalog path in the manifest:

```yaml
automation:
  substeps:
    catalog_item: completed
  catalog_path: "published/lb1234-my-lab-cnv"  # AgV relative path (set by catalog-builder)
  agv_repo: "/path/to/agnosticv"                      # Local AgV repo path
```

## Automation Requirements (7a) and Automation Code (7c)

### Scope

This sub-phase creates the automation that configures the lab/demo environment.
The type of automation depends on the infrastructure:

| Infrastructure | Automation Type | Output Location |
|---------------|----------------|-----------------|
| OCP (any) | Ansible roles as OCP workloads | `automation/roles/` |
| RHEL/AAP VMs | Ansible roles for VM config | `automation/roles/` |
| Sandbox | Minimal — namespace setup only | `automation/roles/` |

### What Gets Automated

Read the design spec and module outlines to determine what needs to be set up:

- **Operators to install** — from infrastructure requirements
- **Applications to deploy** — from module detailed steps
- **User accounts and RBAC** — from multi-user configuration
- **Sample data and repos** — from module prerequisites
- **Network configuration** — from infrastructure notes

### Automation Code Standards

Two automation approaches are supported. See the detailed guides:

- **Ansible collections:** See `@rhdp-publishing-house/skills/automation/references/ansible-automation-guide.md`
  for collection structure, role patterns, variable conventions, templates, and AgnosticV integration.

- **GitOps (Helm + ArgoCD):** See `@rhdp-publishing-house/skills/automation/references/gitops-automation-guide.md`
  for the app-of-apps pattern, three deployment patterns, provision data, and AgnosticV integration.
  Clone from template: `rhpds/ci-template-gitops`.

Both guides include a "What to Automate vs What the Learner Does" section for
determining automation scope from lab content.

### Code Review Cycle

After writing automation code, the automation agent runs its own review cycle:

1. **Self-review** — check against automation standards above
2. **Invoke `code-review:code-review`** — automated PR-based review
3. **Fix issues** — address review findings
4. **Re-validate catalog** — run `agnosticv:validator` again to ensure workload
   references in common.yaml match the roles that were created

This review cycle is separate from the content security review (Phase 8).

## Human Modifications

Automation files may be modified by a human at any time. A human may:

- Edit common.yaml to add workloads or change configuration
- Modify Ansible roles based on hands-on testing
- Restructure Helm charts based on deployment experience

Always read automation files fresh. Respect human edits. Flag divergence from the
spec as informational, not errors.

## What the Automation Agent Does NOT Do

- Does not write Showroom content — that is the writer agent's job
- Does not review content quality — that is the editor agent's job
- Does not implement ZT grading or health checks — that is deferred (e2e_checks)
- Does not manage the AgnosticV repository — it writes files, the user manages git
- Does not deploy or test the catalog — deployment is outside Publishing House scope
- Does not advance the lifecycle phase — only updates substep status
