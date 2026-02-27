# Automation Namespace

AI-powered skills for automating RHDP workflows, operations, and intelligent testing.

---

## Overview

The **automation** namespace provides skills for automating RHDP operations, intelligent environment discovery, rapid testing, and workflow orchestration.

**Target Audience:** RHDP internal team, advanced developers, automation engineers, DevOps teams

**Focus:** Workflow automation, intelligent testing, environment discovery, orchestration

---

## Future Skills (Planned)

### /ftl (Full Test Lifecycle)

AI-powered skill for automated lab testing and validation based on [FTL grading system](https://github.com/redhat-gpte-devopsautomation/FTL).

**Planned Features:**
- Automatic generation of grader playbooks for workshop validation
- Solver playbook creation for automated lab completion testing
- Intelligent test role generation (package checks, service validation, file verification)
- Workshop success criteria validation with detailed feedback
- Self-assessment capabilities for learners
- Integration with RHDP catalog deployments for automated testing
- Pre-deployment validation: test labs before releasing to users

**Use Cases:**
- Generate automated graders for workshop labs (test what learners will do)
- Create solver playbooks to validate lab environment setup
- Test workshop modules before publishing to RHDP catalog
- Provide learners with self-assessment capabilities
- Validate catalog deployments meet workshop requirements
- Automate lab environment validation and readiness checks

**Technical Approach:**
- Based on Ansible playbooks for grading and solving
- Test roles for common checks (packages installed, services running, users exist, file content)
- Solver: Automates lab completion for testing
- Grader: Validates learner actions with feedback on failures

**Integration:**
- Repository: [redhat-gpte-devopsautomation/FTL](https://github.com/redhat-gpte-devopsautomation/FTL)
- RHDP Skills integration: Generate lab graders from workshop content
- Status: Future integration planned

**Status:** Planned for future release

---

### /automation

AI-powered skill for automating RHDP workflows and operations.

**Planned Features:**
- Automated deployment workflows and pipelines
- Smart remediation suggestions based on failure patterns
- Workflow orchestration across multiple catalogs
- Environment lifecycle automation (deploy, test, teardown)
- Integration with RHDP APIs and services
- Automated scaling and resource optimization
- Cost optimization recommendations
- Deployment scheduling and queue management

**Use Cases:**
- Automate repetitive RHDP operations
- Orchestrate complex multi-catalog deployments
- Implement self-healing deployment workflows
- Optimize resource utilization automatically
- Schedule and manage deployment queues
- Automate environment lifecycle management

**Status:** Planned for future release

---

### /field-automation-builder

AI-powered skill for integrating with field-sourced content repository.

**Planned Features:**
- Automatic catalog generation from [field-sourced-content](https://github.com/rhpds/field-sourced-content)
- Field team content validation and standardization
- Workshop template extraction and reuse
- Automated content migration to RHDP catalog
- Community content discovery and integration
- Quality scoring and recommendation engine

**Use Cases:**
- Import field-created workshops into RHDP catalog
- Standardize field content to Red Hat quality
- Discover reusable content patterns from field teams
- Automate catalog item creation from field demos
- Bridge field innovation with RHDP infrastructure

**Integration:**
- Repository: [rhpds/field-sourced-content](https://github.com/rhpds/field-sourced-content)
- Collaboration: RHDP Team
- Status: Future integration planned

**Status:** Planned for future release

---

## Vision

The automation namespace will provide intelligent automation capabilities that go beyond simple scripting:

### Intelligent Testing (/ftl - Full Test Lifecycle)
- **Generate Graders**: Create Ansible playbooks to validate learner actions
- **Create Solvers**: Build automated lab completion playbooks for testing
- **Validate Workshops**: Test what learners will do before publishing
- **Self-Assessment**: Enable learners to check their work with detailed feedback

### Workflow Automation (/automation)
- **Orchestrate**: Manage complex deployment workflows
- **Optimize**: Reduce costs and improve efficiency
- **Remediate**: Auto-fix common deployment issues
- **Scale**: Handle high-volume deployment scenarios

---

## Integration Points

### With Other Namespaces

**agnosticv (Provisioning):**
- Trigger automated deployments after catalog creation
- Validate catalog configurations before deployment
- Auto-generate deployment pipelines

**health (Validation):**
- Orchestrate validation role execution
- Aggregate health check results
- Auto-remediate failed validations

**showroom (Content):**
- Generate lab graders from workshop modules
- Create solver playbooks to validate workshop steps
- Test workshop content before publishing to catalog
- Enable learner self-assessment with automated grading

---

## Use Case Scenarios

### Scenario 1: Workshop Testing Before Release

```
Content creator finishes workshop:

1. /create-lab generates workshop modules
   └─ Multiple hands-on exercises created
   └─ Learning outcomes defined

2. /ftl generates grader playbooks
   └─ Creates validation tests for each exercise
   └─ Defines success criteria checks
   └─ Builds solver to test environment

3. Run solver to validate environment
   └─ Ensures all steps can be completed
   └─ Identifies missing dependencies
   └─ Confirms workshop is ready

4. Deploy to RHDP with graders
   └─ Learners can self-assess their work
   └─ Instant feedback on completion
```

### Scenario 2: Automated Deployment Pipeline

```
New catalog PR merged:

1. /automation triggers deployment workflow
   └─ Validates catalog configuration
   └─ Schedules deployment to Integration
   └─ Monitors provisioning progress

2. /ftl tests deployed environment
   └─ Validates all workloads healthy
   └─ Generates environment documentation
   └─ Confirms readiness

3. /automation promotes to production
   └─ Schedules production deployment
   └─ Notifies stakeholders
   └─ Creates deployment report
```

### Scenario 3: Intelligent Troubleshooting

```
Deployment fails in production:

1. /ftl analyzes failure patterns
   └─ Compares to successful deployments
   └─ Identifies root cause
   └─ Suggests remediation steps

2. /automation implements fix
   └─ Applies recommended changes
   └─ Re-runs deployment
   └─ Validates success

3. /automation prevents recurrence
   └─ Updates deployment guardrails
   └─ Documents failure pattern
   └─ Improves future deployments
```

---

## Technology Stack

### Planned Technologies

**AI/ML:**
- Environment pattern recognition
- Anomaly detection
- Intelligent test generation
- Predictive failure analysis

**Automation:**
- Ansible for orchestration
- Kubernetes operators for lifecycle management
- CI/CD integration (Tekton, GitHub Actions)
- RHDP API integration

**Testing:**
- Dynamic test generation
- Chaos engineering integration
- Performance testing automation
- Security scanning automation

---

## Development Roadmap

### Phase 1: Foundation (Q2 2026)
- [ ] Define /ftl core capabilities
- [ ] Design environment discovery engine
- [ ] Prototype intelligent test generation
- [ ] Build basic automation workflows

### Phase 2: Intelligence (Q3 2026)
- [ ] Implement AI-powered environment analysis
- [ ] Add pattern recognition for common issues
- [ ] Create learning path generation
- [ ] Build remediation suggestion engine

### Phase 3: Orchestration (Q4 2026)
- [ ] Full workflow automation
- [ ] Multi-catalog orchestration
- [ ] Self-healing deployments
- [ ] Cost optimization automation

### Phase 4: Integration (Q1 2027)
- [ ] Deep RHDP API integration
- [ ] Cross-namespace automation
- [ ] Enterprise features
- [ ] Production hardening

---

## Contributing Ideas

Have ideas for automation capabilities? We'd love to hear them!

**Areas of Interest:**
- Environment discovery algorithms
- Test generation strategies
- Workflow optimization patterns
- Remediation techniques
- Cost optimization methods

**Contact:**
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- GitHub: https://github.com/rhpds/rhdp-skills-marketplace/issues
- Email: rhdp-team@redhat.com

---

## Related Namespaces

- [**showroom**](../showroom/README.md) - Content creation for workshops and demos
- [**agnosticv**](../agnosticv/README.md) - RHDP provisioning and infrastructure
- [**health**](../health/README.md) - Post-deployment validation and testing

---

**Version:** v1.0.0 (Namespace created, skills in development)
**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team

---

## Status

🚧 **This namespace is under development**

Skills in this namespace are planned for future releases. Documentation reflects our vision and planned capabilities. Stay tuned for updates!

**Follow development:**
- GitHub: https://github.com/rhpds/rhdp-skills-marketplace
- Slack: [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- CHANGELOG: [View updates](../CHANGELOG.md)
