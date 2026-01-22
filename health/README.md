# Health Namespace

AI-powered skills for RHDP post-deployment validation and health checks.

---

## Overview

The **health** namespace provides skills for validating deployed RHDP environments, creating health check validation roles, and ensuring workloads are functioning correctly after deployment.

**Target Audience:** RHDP internal team, advanced developers, QA engineers, automation developers

**Focus:** Post-deployment validation, health checks, automated testing

---

## Included Skills

### /deployment-health-checker

Create Ansible validation roles for RHDP workloads and deployed environments.

**Features:**
- Post-deployment validation task generation
- OpenShift resource health checks
- Workload-specific validation logic
- Idempotent validation tasks
- Integration with AgV testing workflows
- CI/CD pipeline integration

**Use When:**
- Creating validation for new workloads
- Need automated post-deploy health checks
- Building CI/CD for catalog testing
- Ensuring deployment success before handoff

**Output:** Ansible role with comprehensive validation tasks

[📚 Documentation](https://rhpds.github.io/rhdp-skills-marketplace/skills/deployment-health-checker.html)

---

## Typical Workflows

### Creating Validation for New Workload

```
1. /deployment-health-checker
   └─ Specify workload name and type

2. Review generated validation role
   └─ tasks/main.yml with health checks

3. Customize validation logic
   └─ Add workload-specific checks

4. Test validation role
   └─ Run against deployed environment

5. Integrate with AgV catalog
   └─ Add to catalog testing workflow
```

### Post-Deployment Health Check

```
1. Deploy catalog via RHDP

2. Run validation role
   └─ Verify all workloads healthy

3. Check validation output
   └─ All tasks should pass (green)

4. Debug failures if any
   └─ Use validation output to identify issues

5. Confirm environment ready
   └─ Hand off to users/customers
```

---

## Validation Role Structure

### Generated Files

After running `/deployment-health-checker`, you'll have:

```
validation-role-name/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   └── main.yml              # Validation tasks
├── meta/
│   └── main.yml              # Role metadata
└── README.md                 # Role documentation
```

### Validation Task Pattern

Each validation task follows this pattern:

```yaml
- name: Verify deployment is ready
  kubernetes.core.k8s_info:
    api_version: v1
    kind: Deployment
    name: "{{ deployment_name }}"
    namespace: "{{ namespace }}"
  register: deployment_info
  retries: 30
  delay: 10
  until:
    - deployment_info.resources is defined
    - deployment_info.resources | length > 0
    - deployment_info.resources[0].status.conditions | selectattr('type', 'equalto', 'Available') | map(attribute='status') | list | first == 'True'

- name: Verify pods are running
  kubernetes.core.k8s_info:
    api_version: v1
    kind: Pod
    namespace: "{{ namespace }}"
    label_selectors:
      - "app={{ app_label }}"
  register: pod_info
  failed_when: pod_info.resources | length == 0

- name: Verify route is accessible
  uri:
    url: "https://{{ route_hostname }}"
    validate_certs: false
    status_code: 200
  retries: 10
  delay: 5
```

---

## Common Validation Checks

### OpenShift Resources

- **Deployments:** Ready replicas match desired
- **Pods:** Running and ready
- **Services:** Endpoints available
- **Routes:** Accessible and returning expected status
- **ConfigMaps/Secrets:** Present and mounted
- **PVCs:** Bound and attached

### Workload-Specific

- **OpenShift AI:** Notebook servers ready, DSP pipelines accessible
- **Pipelines:** Tekton operator running, example pipelines exist
- **GitOps:** Argo CD accessible, applications synced
- **Showroom:** Content loaded, terminal pods ready

### Application-Level

- **API endpoints:** Returning expected responses
- **Database connections:** Successful and queryable
- **Authentication:** Login flows working
- **Data persistence:** Can write and read data

---

## Integration with AgV

### Adding Validation to Catalog

In your AgnosticV catalog `common.yaml`:

```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
- agnosticd.showroom.ocp4_workload_showroom
- your_org.validation_roles.validate_deployment  # Health check

# Run validation after all workloads
validate_deployment: true
```

### Testing Workflow

```
1. Deploy catalog to Integration
   └─ Wait for provisioning

2. Validation role runs automatically
   └─ Post-deployment health checks

3. Check validation results
   └─ RHDP Events tab shows validation output

4. Environment ready if validation passes
   └─ Green checks = ready for users
```

---

## Future Skills (Planned)

Additional health check and validation skills may be added in future releases.

**Potential areas:**
- Advanced workload-specific validators
- Performance testing automation
- Security scanning integration
- Compliance checking automation

**Related Skills:**
- See [automation namespace](../automation/README.md) for /ftl and workflow automation
- See [agnosticv namespace](../agnosticv/README.md) for catalog validation

---

## Best Practices

### Validation Design

1. **Idempotent checks** - Can run multiple times safely
2. **Retries with delays** - Allow time for resources to become ready
3. **Clear failure messages** - Help debug issues quickly
4. **Minimal dependencies** - Use built-in Ansible modules
5. **Fast execution** - Complete within 5 minutes

### Testing

1. **Test on clean environment** - Verify checks work from scratch
2. **Test failure scenarios** - Ensure failures are detected
3. **Test with delays** - Verify retries work correctly
4. **Document expected state** - Clear pass/fail criteria
5. **Version validation roles** - Track changes over time

### Integration

1. **Run after workload deployment** - Post-deployment validation
2. **Don't block provisioning** - Validation is informational
3. **Log to RHDP events** - Visible in portal
4. **Fail gracefully** - Clear error messages
5. **Optional for demos** - Required for production

---

## Troubleshooting

### Validation Role Fails

**Symptom:** Validation tasks report failures

**Solution:**
1. Check RHDP Events tab for specific errors
2. Verify resources exist: `oc get all -n <namespace>`
3. Check pod logs: `oc logs <pod-name>`
4. Increase retries/delays if timing issue
5. Update validation logic if requirements changed

### Validation Takes Too Long

**Symptom:** Validation runs for >10 minutes

**Solution:**
1. Reduce retry counts (max 30)
2. Decrease delay intervals (5-10 seconds)
3. Parallelize independent checks
4. Remove unnecessary validations
5. Check for stuck resources

### Validation Passes But Environment Broken

**Symptom:** Validation green but users report issues

**Solution:**
1. Add missing checks for reported issues
2. Verify checks test actual functionality
3. Add application-level tests (API calls, etc.)
4. Test validation against known-bad environment
5. Update validation role version

---

## Support

- **Documentation:** https://rhpds.github.io/rhdp-skills-marketplace
- **GitHub Issues:** https://github.com/rhpds/rhdp-skills-marketplace/issues
- **Slack:** #forum-rhdp or #forum-rhdp-automation
- **Ansible Collections:** https://github.com/agnosticd

---

## Related Namespaces

- [**showroom**](../showroom/README.md) - Content creation for workshops and demos
- [**agnosticv**](../agnosticv/README.md) - RHDP provisioning and infrastructure

---

**Version:** v1.0.0
**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
