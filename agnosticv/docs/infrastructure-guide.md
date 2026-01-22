# AgnosticV Infrastructure Selection Guide

Decision trees and guidelines for choosing between CNV, SNO, and AWS infrastructure.

---

## Quick Decision Tree

```
Start: What infrastructure do I need?
│
├─ Do you need GPU acceleration? ──→ YES ──→ ✅ AWS (g6.4xlarge instances)
│                                   │
│                                   NO
│                                   ↓
├─ Is this an edge computing demo? ──→ YES ──→ ✅ SNO (Single Node OpenShift)
│                                     │
│                                     NO
│                                     ↓
├─ Do you need >128Gi RAM? ──→ YES ──→ ✅ AWS (large instances)
│                             │
│                             NO
│                             ↓
├─ Is this multi-user? ──→ YES ──→ ✅ CNV (multi-node, auto-scaling)
│                         │
│                         NO
│                         ↓
└─ Single user demo? ──→ YES ──→ ✅ CNV (fast, cost-effective) or SNO (lightweight)
```

---

## Infrastructure Options

### CNV (Container-Native Virtualization) - **DEFAULT CHOICE**

**Best For:**
- Multi-user workshops (5-40 users)
- Standard OpenShift workloads
- Most labs and demos
- Cost-effective deployments

**Specifications:**
- Provision time: 10-15 minutes
- Max resources per worker: 64Gi RAM, 32 cores
- Auto-scaling support: Yes
- Cost: $$

**When to Use:**
- Default choice for OpenShift-based content
- No special hardware requirements (GPU, edge)
- Multi-user scenarios
- Standard AI/ML workloads (no GPU)

**Example AgV Configuration:**
```yaml
__meta__:
  components:
  - name: openshift-base
    display_name: OpenShift Cluster
    item: agd-v2/ocp-cluster-cnv-pools/prod
    parameter_values:
      cluster_size: multinode
      host_ocp4_installer_version: "4.20"
```

**Workloads:**
- Most core workloads supported
- Showroom: `agnosticd.showroom.ocp4_workload_showroom`

---

### SNO (Single Node OpenShift)

**Best For:**
- Edge computing demos
- Lightweight platform overviews
- Single-user quick demos
- Resource-constrained scenarios

**Specifications:**
- Provision time: 5-10 minutes
- Resources: Single node (32Gi RAM, 16 cores typical)
- Auto-scaling support: No (single node)
- Cost: $

**When to Use:**
- Edge computing demonstrations
- Quick OpenShift platform tours
- Single presenter demos
- Lightweight workloads
- Fast provisioning needed

**Limitations:**
- NOT for multi-user labs
- Limited total resources
- No high availability
- Some workloads may not fit

**Example AgV Configuration:**
```yaml
__meta__:
  components:
  - name: openshift-base
    display_name: OpenShift Cluster (SNO)
    item: agd-v2/ocp-cluster-cnv-pools/prod
    parameter_values:
      cluster_size: sno
      host_ocp4_installer_version: "4.20"
```

**Workloads:**
- Use SNO-specific Showroom: `agnosticd.showroom.ocp4_workload_showroom_sno`
- Lighter workloads recommended

---

### AWS (Cloud-Specific)

**Best For:**
- GPU-accelerated AI/ML workloads
- Large memory requirements (>128Gi)
- Cloud-native service integration
- Production-scale demonstrations

**Specifications:**
- Provision time: 30-45 minutes
- GPU instances: g6.4xlarge (NVIDIA L4, 24Gi GPU RAM)
- Memory: Up to 384Gi+ per instance
- Cost: $$$

**When to Use:**
- GPU required for model training
- Large language model inference (local)
- High memory workloads
- AWS service integration (S3, ELB, etc.)

**Limitations:**
- Slower provisioning (30-45 min vs 10-15 min)
- Higher cost - reserve for GPU needs
- Requires AWS-specific configuration

**Example AgV Configuration:**
```yaml
cloud_provider: ec2
config: ocp-workloads

__meta__:
  components:
  - name: openshift-base
    display_name: OpenShift Cluster (AWS)
    item: agd-v2/ocp-cluster-aws/prod
    parameter_values:
      cluster_size: default
      host_ocp4_installer_version: "4.20"
      worker_instance_type: g6.4xlarge  # For GPU
      worker_instance_count: 2
```

**Workloads:**
- GPU operator: `agnosticd.ai_workloads.ocp4_workload_nvidia_gpu_operator`
- Standard OCP workloads
- Showroom: `agnosticd.showroom.ocp4_workload_showroom`

---

## Comparison Matrix

| Feature | CNV (Multi-node) | SNO | AWS |
|---------|------------------|-----|-----|
| **Provision Time** | 10-15 min | 5-10 min | 30-45 min |
| **Multi-user** | ✅ Yes (5-40 users) | ❌ No | ✅ Yes |
| **GPU Support** | ❌ No | ❌ No | ✅ Yes |
| **Auto-scaling** | ✅ Yes | ❌ No | ✅ Yes |
| **Max RAM per worker** | 64Gi | 32Gi (total) | 384Gi+ |
| **Cost** | $$ | $ | $$$ |
| **Edge Computing** | ❌ No | ✅ Yes | ❌ No |
| **High Availability** | ✅ Yes | ❌ No | ✅ Yes |
| **Best For** | Labs, workshops | Demos, edge | GPU, large memory |

---

## Use Case Examples

### AI/ML Workshops

**Scenario:** OpenShift AI workshop with notebook servers and model deployment

**Decision:**
- No GPU needed for inference → ✅ **CNV**
- Multi-user (20 attendees) → ✅ **CNV**
- LiteLLM for model access → ✅ **CNV**

**Configuration:**
```yaml
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: multinode
```

---

**Scenario:** AI model training with local GPUs

**Decision:**
- GPU required → ✅ **AWS**
- Training large models → ✅ **AWS g6.4xlarge**

**Configuration:**
```yaml
cloud_provider: ec2
item: agd-v2/ocp-cluster-aws/prod
parameter_values:
  worker_instance_type: g6.4xlarge
  worker_instance_count: 2
```

---

### Pipeline/GitOps Workshops

**Scenario:** CI/CD workshop with Tekton and Argo CD

**Decision:**
- No special hardware → ✅ **CNV**
- Multi-user (30 attendees) → ✅ **CNV**
- Standard OCP workloads → ✅ **CNV**

**Configuration:**
```yaml
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: multinode
```

---

### Edge Computing Demos

**Scenario:** Edge platform demonstration, single presenter

**Decision:**
- Edge focus → ✅ **SNO**
- Single user demo → ✅ **SNO**
- Lightweight → ✅ **SNO**

**Configuration:**
```yaml
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: sno
```

---

### Executive/Sales Demos

**Scenario:** C-level briefing, pre-configured environment

**Decision:**
- Single presenter → **CNV or SNO**
- Production-like experience → ✅ **CNV** (if budget allows)
- Quick setup → ✅ **SNO** (if lightweight)

**Configuration (CNV):**
```yaml
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: multinode  # More production-like
```

---

## Multi-User Configuration

### CNV Multi-User Setup

**Authentication:** htpasswd (simple) or Keycloak (advanced)

```yaml
workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd

ocp4_workload_authentication_htpasswd_user_count: 40
ocp4_workload_authentication_htpasswd_user_base: user
ocp4_workload_authentication_htpasswd_user_password: "{{ common_user_password }}"

__meta__:
  catalog:
    multiuser: true
    parameters:
    - name: num_users
      description: Number of users to provision
      formLabel: OpenShift User Count
      openAPIV3Schema:
        type: integer
        default: 2
        minimum: 2
        maximum: 40
```

---

## Resource Planning

### Workload Resource Requirements

| Workload | RAM (per user) | CPU (per user) | Notes |
|----------|----------------|----------------|-------|
| OpenShift AI | 8-16Gi | 2-4 cores | Notebook servers |
| Pipelines | 2-4Gi | 1-2 cores | Pipeline runs |
| Dev Spaces | 4-8Gi | 2 cores | IDE workspaces |
| Service Mesh | 4-8Gi | 2 cores | Control plane |
| Gitea | 1-2Gi | 0.5 cores | Git server |

### Capacity Calculations

**Example:** 20-user AI workshop

- OpenShift AI: 20 × 12Gi = 240Gi RAM
- Pipelines: 20 × 3Gi = 60Gi RAM
- Overhead: ~50Gi RAM
- **Total:** ~350Gi RAM

**Infrastructure Choice:**
- CNV multi-node: 6 workers × 64Gi = 384Gi ✅ **Fits**
- SNO: 32Gi total ❌ **Does not fit**

---

## Common Patterns

### Pattern 1: Standard Multi-User Lab

```yaml
# CNV multi-node
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: multinode
  host_ocp4_installer_version: "4.20"

workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
- agnosticd.showroom.ocp4_workload_showroom
- [technology-specific workloads]
```

### Pattern 2: GPU AI/ML Workload

```yaml
# AWS with GPU
cloud_provider: ec2
config: ocp-workloads

item: agd-v2/ocp-cluster-aws/prod
parameter_values:
  cluster_size: default
  host_ocp4_installer_version: "4.20"
  worker_instance_type: g6.4xlarge
  worker_instance_count: 2

workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_htpasswd
- agnosticd.ai_workloads.ocp4_workload_nvidia_gpu_operator
- agnosticd.ai_workloads.ocp4_workload_openshift_ai
- agnosticd.showroom.ocp4_workload_showroom
```

### Pattern 3: Edge Demo (SNO)

```yaml
# SNO
item: agd-v2/ocp-cluster-cnv-pools/prod
parameter_values:
  cluster_size: sno
  host_ocp4_installer_version: "4.20"

workloads:
- agnosticd.core_workloads.ocp4_workload_authentication_keycloak
- agnosticd.showroom.ocp4_workload_showroom_sno
- [lightweight workloads only]
```

---

## Troubleshooting

### Workload Doesn't Fit on SNO

**Symptom:** SNO deployment fails with resource errors

**Solution:** Switch to CNV multi-node

### Slow Provisioning

**Symptom:** AWS takes 45+ minutes

**Solution:**
- This is normal for AWS
- Use CNV for faster provisioning (unless GPU required)

### Multi-User Capacity Issues

**Symptom:** Users report performance degradation

**Solution:**
- Reduce user count
- Add more CNV workers via parameters
- Use lighter workloads

### GPU Not Available

**Symptom:** GPU operator fails, no GPUs detected

**Solution:**
- Verify AWS instance type is g6.4xlarge or similar
- Check GPU operator logs
- Ensure NVIDIA drivers loaded

---

## Best Practices

1. **Default to CNV** unless you have specific needs (GPU, edge)
2. **Test capacity** in RHDP Integration before production
3. **Start with fewer users** then scale up
4. **Use SNO sparingly** - only for single-user demos or edge
5. **Reserve AWS for GPU** - it's more expensive and slower
6. **Plan resources** - calculate total RAM/CPU needs before choosing infrastructure

---

## Related Documentation

- [Workload Mappings](workload-mappings.md) - Technology to workload mapping
- [AGV Common Rules](AGV-COMMON-RULES.md) - Full AgV configuration contract
- [CNV Pools Documentation](https://github.com/rhpds/agnosticv/tree/main/agd_v2/ocp-cluster-cnv-pools)

---

**Last Updated:** 2026-01-22
**Maintained By:** RHDP Team
