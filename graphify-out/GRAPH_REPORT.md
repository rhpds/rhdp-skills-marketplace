# Graph Report - .  (2026-05-31)

## Corpus Check
- 3 files · ~307,184 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 61 nodes · 89 edges · 10 communities detected
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 14 edges (avg confidence: 0.9)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]

## God Nodes (most connected - your core abstractions)
1. `agnosticv:catalog-builder` - 14 edges
2. `ftl:rhdp-lab-validator` - 14 edges
3. `Sandbox CLI Plugin` - 7 edges
4. `showroom:create-lab` - 7 edges
5. `FTL Plugin` - 6 edges
6. `showroom:create-demo` - 6 edges
7. `health:deployment-validator` - 6 edges
8. `ftl:validate-writer` - 6 edges
9. `AgnosticV Catalog System` - 6 edges
10. `Showroom Plugin` - 5 edges

## Surprising Connections (you probably didn't know these)
- `showroom:create-lab` --conceptually_related_to--> `ftl:rhdp-lab-validator`  [INFERRED]
  showroom/skills/create-lab/SKILL.md → ftl/skills/rhdp-lab-validator/SKILL.md
- `AgnosticV Catalog System` --references--> `Red Hat Demo Platform (RHDP)`  [INFERRED]
  agnosticv/README.md → README.md
- `FTL E2E Lab Testing Framework` --references--> `Red Hat Demo Platform (RHDP)`  [INFERRED]
  ftl/skills/rhdp-lab-validator/SKILL.md → README.md
- `Sandbox API CI Pattern` --conceptually_related_to--> `sandbox-cli:cluster-onboard`  [INFERRED]
  agnosticv/skills/catalog-builder/SKILL.md → sandbox-cli/skills/cluster-onboard/SKILL.md
- `AgnosticV Plugin` --references--> `RHDP Marketplace`  [EXTRACTED]
  agnosticv/.claude-plugin/plugin.json → .claude-plugin/marketplace.json

## Communities

### Community 0 - "Community 0"
Cohesion: 0.23
Nodes (15): ftl:content-reader, ftl:env-connector, ftl:solve-writer, ftl:validate-writer, FTL E2E Lab Testing Framework, Playwright UI Automation, solve.yml / validate.yml Playbooks, rhpds.ftl.validation_check Plugin (+7 more)

### Community 1 - "Community 1"
Cohesion: 0.22
Nodes (9): RHDP Marketplace, Health Plugin, Sandbox CLI Plugin, sandbox-cli:cluster-details, sandbox-cli:cluster-list, sandbox-cli:cluster-offboard, sandbox-cli:cluster-onboard, sandbox-cli:cluster-rotate (+1 more)

### Community 2 - "Community 2"
Cohesion: 0.25
Nodes (8): Sandbox API CI Pattern, AGV Common Rules, Cloud VMs Base Catalog Questions, AgnosticV Developer Guidelines, OCP Catalog Questions Reference, Sandbox Cluster CI Questions, Sandbox Tenant CI Questions, agnosticv:catalog-builder

### Community 3 - "Community 3"
Cohesion: 0.5
Nodes (8): Showroom Plugin, AsciiDoc Rules Reference, Demo Content Rules Reference, Showroom Skill Common Rules, showroom:blog-generate, showroom:create-demo, showroom:create-lab, showroom:verify-content

### Community 4 - "Community 4"
Cohesion: 0.4
Nodes (0): 

### Community 5 - "Community 5"
Cohesion: 0.4
Nodes (5): AsciiDoc Lab Modules, Deployment Health Validation, Know/Show Demo Structure, Red Hat Demo Platform (RHDP), Red Hat Showroom Platform

### Community 6 - "Community 6"
Cohesion: 0.4
Nodes (5): agnosticd_user_info Plugin, AgnosticV Plugin, Health FTL Patterns, agnosticv:validator, health:deployment-validator

### Community 7 - "Community 7"
Cohesion: 0.5
Nodes (4): AgnosticV Catalog System, common.yaml Catalog Config, LiteMaaS / LiteLLM Integration, ocp4_workload Ansible Roles

### Community 8 - "Community 8"
Cohesion: 1.0
Nodes (0): 

### Community 9 - "Community 9"
Cohesion: 1.0
Nodes (0): 

## Knowledge Gaps
- **21 isolated node(s):** `Deployment Health Validation`, `agnosticd_user_info Plugin`, `Playwright UI Automation`, `OCP Catalog Questions Reference`, `Cloud VMs Base Catalog Questions` (+16 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 8`** (1 nodes): `web-app-form-submit.js`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 9`** (1 nodes): `ocp-console-label-resource.js`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ftl:rhdp-lab-validator` connect `Community 0` to `Community 3`, `Community 5`, `Community 7`?**
  _High betweenness centrality (0.311) - this node is a cross-community bridge._
- **Why does `agnosticv:catalog-builder` connect `Community 2` to `Community 5`, `Community 6`, `Community 7`?**
  _High betweenness centrality (0.255) - this node is a cross-community bridge._
- **Why does `RHDP Marketplace` connect `Community 1` to `Community 0`, `Community 3`, `Community 6`?**
  _High betweenness centrality (0.192) - this node is a cross-community bridge._
- **What connects `Deployment Health Validation`, `agnosticd_user_info Plugin`, `Playwright UI Automation` to the rest of the system?**
  _21 weakly-connected nodes found - possible documentation gaps or missing edges._