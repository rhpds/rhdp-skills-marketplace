# RHDP Developer Guidelines for Event Labs (Summit / RH1)

## Naming Standards

`event-name` is `summit-2026` or `rh1-2026`. All GitHub repos in `github.com/rhpds`.

| Type | Pattern | Example |
|------|---------|---------|
| AgnosticV config | `summit-2026/lbXXXX-<short>-<cloud>` | `summit-2026/lb1234-ocp-fish-swim-cnv` |
| Showroom repo | `<short-name>-showroom` | `ocp-fish-swim-showroom` |
| Automation repo | `<short-name>-automation` | `ocp-fish-swim-automation` |
| Slack channel | `<event>-lbXXXX-<short>` | `summit-2026-lb1234-ocp-fish-swim` |

## AgnosticV `__meta__` Key Variables

| Variable | Requirement |
|----------|-------------|
| `anarchy.namespace` | **NEVER define** |
| `deployer.actions.*.disable` | Set `true` to DISABLE. Default false. Set start/stop true if base component handles cluster lifecycle |
| `deployer.ee` | Use current chained EE: `quay.io/agnosticd/ee-multicloud:chained-2026-02-16` |
| `sandbox_api.actions.destroy.catch_all` | Set `false` if remove_workloads should run on destroy |
| `catalog.reportingLabels.primaryBU` | **Always define**: Hybrid_Platforms, Artificial_Intelligence, Automation, Application_Developer, RHEL, Edge, RHDP |
| `catalog.labels.Brand_Event` | `Red_Hat_Summit_2026` or `Red_Hat_One_2026` for event catalogs |
| `catalog.keywords` | Add `summit-2026`/`rh1-2026` + Lab ID. Max 3-4 keywords. No generics |
| `catalog.multiuser` | Set `true` for multi-user CIs |
| `catalog.workshopLabUiRedirect` | Set `true` if `lab_ui_url` defined and you want redirect to Showroom |

## FTL Requirement

All event labs MUST have FTL grader/solver playbooks. Use `/ftl:lab-validator`.

## Development Cycle Rule

Complete each module fully (automation + Showroom + FTL) before moving to the next.
