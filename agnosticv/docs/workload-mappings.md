# AgnosticV Workload Mappings

Quick reference for mapping workshop/demo keywords to AgnosticV workloads.

---

## How to Use This Guide

1. **Identify keywords** from your workshop/demo abstract
2. **Find matching category** below
3. **Select required workloads** from recommendations
4. **Add to AgV catalog** `common.yaml` workloads list

---

## Core Workloads (Always Required)

### Authentication

One unified workload — provider selected by variable:

| Workload | Provider var | Use For |
|----------|-------------|---------|
| `agnosticd.core_workloads.ocp4_workload_authentication` | `htpasswd` | Multi-user labs (simpler, faster) |
| `agnosticd.core_workloads.ocp4_workload_authentication` | `keycloak` | Demos, SSO required |

```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication

ocp4_workload_authentication_provider: htpasswd   # or: keycloak
ocp4_workload_authentication_admin_username: admin
ocp4_workload_authentication_num_users: "{{ num_users | default(0) }}"
ocp4_workload_authentication_remove_kubeadmin: true
```

⚠️ The old split roles (`ocp4_workload_authentication_htpasswd`, `ocp4_workload_authentication_keycloak`) are deprecated — the validator will ERROR on them.

### Showroom (Content Delivery)

Auto-selected based on infrastructure type:

| Infrastructure | Workload | Purpose |
|----------------|----------|---------|
| OCP-based (CNV/SNO) | `agnosticd.showroom.ocp4_workload_showroom_ocp_integration`<br>`agnosticd.showroom.ocp4_workload_showroom` | Workshop platform on OCP |
| VM-based (AWS) | `agnosticd.showroom.vm_workload_showroom` | Workshop platform on bastion |

**Variables:**
```yaml
ocp4_workload_showroom_content_git_repo: https://github.com/rhpds/<repo>.git
ocp4_workload_showroom_content_git_repo_ref: main
```

---

## Technology-Specific Workloads

### AI/ML Workloads

**Keywords:** `ai`, `ml`, `llm`, `rag`, `model`, `inference`, `training`, `openshift-ai`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.ai_workloads.ocp4_workload_openshift_ai`** | OpenShift AI operator, notebook servers, data science pipelines | Any AI/ML workshop or demo |
| **`rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys`** | LLM API proxy with virtual keys (Mistral, Granite, CodeLlama) | LLM inference, chatbots, RAG applications |
| `agnosticd.ai_workloads.ocp4_workload_nvidia_gpu_operator` | NVIDIA GPU operator for model training | Training large models, GPU workloads (requires AWS) |
| `agnosticd.ai_workloads.ocp4_workload_ols` | OpenShift Lightspeed (AI coding assistant) | Developer productivity demos |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: htpasswd
- agnosticd.ai_workloads.ocp4_workload_openshift_ai
- rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys
- agnosticd.showroom.ocp4_workload_showroom

# OpenShift AI configuration
ocp4_workload_openshift_ai_channel: stable
ocp4_workload_openshift_ai_enable_gpu: false  # Set true for GPU workloads
ocp4_workload_openshift_ai_enable_monitoring: true
```

**UserInfo Variables Provided:**
- `litellm_api_base_url` - API endpoint for LLM proxy
- `litellm_virtual_key` - API key for model access
- `litellm_available_models` - List of available models

---

### DevOps/GitOps Workloads

**Keywords:** `pipeline`, `gitops`, `ci/cd`, `tekton`, `argo`, `automation`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_pipelines`** | Tekton Pipelines (cloud-native CI/CD) | Pipeline workshops, CI/CD automation |
| **`agnosticd.core_workloads.ocp4_workload_openshift_gitops`** | Argo CD for GitOps workflows | GitOps training, declarative deployments |
| **`agnosticd.core_workloads.ocp4_workload_gitea_operator`** | Self-hosted Git server for labs | Disconnected environments, Git workflow training |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: htpasswd
- agnosticd.core_workloads.ocp4_workload_pipelines
- agnosticd.core_workloads.ocp4_workload_openshift_gitops
- agnosticd.core_workloads.ocp4_workload_gitea_operator
- agnosticd.showroom.ocp4_workload_showroom

# Pipelines configuration
ocp4_workload_pipelines_channel: pipelines-1.20
ocp4_workload_pipelines_tekton_chains_enabled: true
```

**UserInfo Variables Provided:**
- `gitea_console_url` - Git server URL
- `gitea_admin_username` - Git admin user
- `gitea_admin_password` - Git admin password

---

### Developer Tools Workloads

**Keywords:** `ide`, `vscode`, `dev-spaces`, `inner-loop`, `developer`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_openshift_devspaces`** | Cloud-based IDE (Eclipse Che) | Developer onboarding, browser-based coding |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: htpasswd
- agnosticd.core_workloads.ocp4_workload_openshift_devspaces
- agnosticd.showroom.ocp4_workload_showroom

# Dev Spaces configuration
ocp4_workload_openshift_devspaces_channel: stable
ocp4_workload_openshift_devspaces_postgres_pvc_size: 10Gi
```

---

### Security Workloads

**Keywords:** `security`, `compliance`, `acs`, `stackrox`, `scanning`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_acs`** | Advanced Cluster Security (Kubernetes security platform) | Security workshops, compliance demos |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: keycloak
- agnosticd.core_workloads.ocp4_workload_acs
- agnosticd.showroom.ocp4_workload_showroom

# ACS configuration
ocp4_workload_acs_central_admin_password: "{{ common_admin_password }}"
```

**UserInfo Variables Provided:**
- `acs_central_url` - ACS Central console URL
- `acs_admin_username` - Admin user
- `acs_admin_password` - Admin password

---

### Observability Workloads

**Keywords:** `monitoring`, `logging`, `observability`, `metrics`, `prometheus`, `grafana`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_observability`** | OpenShift monitoring stack (Prometheus, Grafana, AlertManager) | Observability training, metrics workshops |
| **`agnosticd.core_workloads.ocp4_workload_logging`** | Cluster logging (Loki, Vector) | Log aggregation, troubleshooting demos |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: htpasswd
- agnosticd.core_workloads.ocp4_workload_observability
- agnosticd.core_workloads.ocp4_workload_logging
- agnosticd.showroom.ocp4_workload_showroom
```

---

### Networking Workloads

**Keywords:** `service-mesh`, `istio`, `networking`, `ingress`, `traffic`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_service_mesh`** | Red Hat OpenShift Service Mesh (Istio) | Microservices workshops, traffic management |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: keycloak
- agnosticd.core_workloads.ocp4_workload_service_mesh
- agnosticd.showroom.ocp4_workload_showroom

# Service Mesh configuration
ocp4_workload_service_mesh_control_plane_name: basic
```

---

### Serverless Workloads

**Keywords:** `serverless`, `knative`, `functions`, `eventing`, `event-driven`

| Workload | Purpose | When to Use |
|----------|---------|-------------|
| **`agnosticd.core_workloads.ocp4_workload_serverless`** | Knative Serving and Eventing | Event-driven architectures, auto-scaling demos |

**Example Configuration:**
```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication  # provider: htpasswd
- agnosticd.core_workloads.ocp4_workload_serverless
- agnosticd.showroom.ocp4_workload_showroom

# Serverless configuration
ocp4_workload_serverless_channel: stable
```

---

## Collections and Versions

### Required Collections

Always include in `requirements_content.collections`:

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: "{{ tag }}"  # Or specific version
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: main
```

### AI/ML Collections

If using AI workloads:

```yaml
requirements_content:
  collections:
  - name: https://github.com/agnosticd/core_workloads.git
    type: git
    version: main
  - name: https://github.com/agnosticd/ai_workloads.git
    type: git
    version: main
  - name: https://github.com/rhpds/litellm_virtual_keys.git
    type: git
    version: main
  - name: https://github.com/agnosticd/showroom.git
    type: git
    version: main
```

---

## Passing Data Between Workloads

Some workloads produce data needed by subsequent workloads.

### Pattern: LiteLLM → Custom App

**LiteLLM workload produces:**
```yaml
# In litellm_virtual_keys workload:
- name: Save credentials
  agnosticd.core.agnosticd_user_info:
    data:
      litellm_api_base_url: "{{ litellm_url }}"
      litellm_virtual_key: "{{ generated_key }}"
```

**Consume in catalog:**
```yaml
# In common.yaml:
workloads:
- rhpds.litellm_virtual_keys.ocp4_workload_litellm_virtual_keys
- myorg.my_app.ocp4_workload_my_app

# Pass LiteLLM data to my_app:
ocp4_workload_my_app_api_url: "{{ lookup('agnosticd_user_data', 'litellm_api_base_url') }}"
ocp4_workload_my_app_api_key: "{{ lookup('agnosticd_user_data', 'litellm_virtual_key') }}"
```

**Common patterns:**
- API keys, tokens, credentials
- Service URLs and endpoints
- Generated usernames/passwords
- Deployed application routes

---

## Quick Selection Guide

### By Workshop Type

| Type | Recommended Workloads |
|------|----------------------|
| **AI/ML Workshop** | authentication_htpasswd, openshift_ai, litellm_virtual_keys, showroom |
| **Pipeline Workshop** | authentication_htpasswd, pipelines, gitea_operator, showroom |
| **GitOps Workshop** | authentication_htpasswd, openshift_gitops, pipelines, showroom |
| **Security Demo** | authentication_keycloak, acs, showroom |
| **Developer Demo** | authentication_keycloak, devspaces, pipelines, showroom |

### By Keywords

| Keywords | Add Workloads |
|----------|---------------|
| AI, ML, LLM | openshift_ai, litellm_virtual_keys |
| Pipeline, CI/CD | pipelines, gitea_operator |
| GitOps, Argo | openshift_gitops |
| Security, ACS | acs |
| Monitoring | observability, logging |
| Service Mesh | service_mesh |
| Serverless | serverless |
| Developer, IDE | devspaces |

---

## Troubleshooting

### Collection Not Found

**Error:** `Collection <name> not found in requirements`

**Fix:** Add collection to `requirements_content.collections` in `common.yaml`

### Workload Dependency Missing

**Error:** `Workload X requires workload Y`

**Fix:** Check workload documentation for dependencies and add missing workloads

### Variable Not Defined

**Error:** `Variable <name> is not defined`

**Fix:** Add workload-specific variables to `common.yaml` or use defaults

---

## Related Documentation

- [Infrastructure Guide](infrastructure-guide.md) - CNV/SNO/AWS selection
- [AGV Common Rules](AGV-COMMON-RULES.md) - Full AgV configuration contract
- [AgnosticD Core Workloads](https://github.com/agnosticd/core_workloads) - Workload source code

---

**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
