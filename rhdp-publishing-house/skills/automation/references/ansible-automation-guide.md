# Ansible Automation Guide

How to create Ansible collections that automate RHDP lab/demo environments.

## Collection Structure

Every automation collection follows standard Ansible collection layout:

```
rhpds.<collection_name>/
├── galaxy.yml                    # Collection metadata
├── README.md                     # Usage, dependencies, variables
└── roles/
    └── <role_name>/
        ├── defaults/
        │   └── main.yml          # All variables with sensible defaults
        ├── meta/
        │   └── main.yml          # Role metadata and dependencies
        ├── tasks/
        │   ├── main.yml          # Entry point — routes by ACTION variable
        │   ├── workload.yml      # Install/configure (ACTION=create)
        │   └── remove_workload.yml  # Cleanup (ACTION=destroy)
        ├── templates/            # Jinja2 templates for K8s manifests
        │   └── *.yaml.j2
        └── README.md             # Role documentation
```

A collection can contain multiple roles. Each role handles one logical component
of the lab environment.

## galaxy.yml

```yaml
namespace: rhpds
name: <collection_name>             # e.g., openshift_lightspeed_demo
version: 1.0.0
description: "<Description> Workloads Collection"
license:
  - Apache-2.0
authors:
  - <Name> (<email>)
repository: https://github.com/rhpds/rhpds.<collection_name>
tags:
  - openshift
  - <relevant-tags>
dependencies: {}
```

## Role Entry Point (tasks/main.yml)

Every role uses an ACTION variable to determine what to do:

```yaml
- name: Run workload
  when: ACTION == "create" or ACTION == "provision"
  ansible.builtin.include_tasks: workload.yml

- name: Remove workload
  when: ACTION == "destroy" or ACTION == "remove"
  ansible.builtin.include_tasks: remove_workload.yml
```

This is the only pattern for `main.yml`. Do not add other logic here.

## Workload Tasks (tasks/workload.yml)

This is where the environment gets configured. Common patterns:

### Create Namespaces

```yaml
- name: Create namespace for the lab
  kubernetes.core.k8s:
    state: present
    definition:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: "{{ my_role_namespace }}"
```

### Deploy Kubernetes Resources from Templates

```yaml
- name: Deploy application
  kubernetes.core.k8s:
    state: present
    definition: "{{ lookup('template', 'deployment.yaml.j2') }}"
```

### Wait for Resources

```yaml
- name: Wait for deployment to be available
  kubernetes.core.k8s_info:
    api_version: apps/v1
    kind: Deployment
    name: my-app
    namespace: "{{ my_role_namespace }}"
  register: r_deployment
  until: r_deployment.resources | length > 0
         and r_deployment.resources[0].status.availableReplicas is defined
         and r_deployment.resources[0].status.availableReplicas > 0
  retries: 30
  delay: 10
```

### Patch Existing Resources

```yaml
- name: Patch operator configuration
  kubernetes.core.k8s_json_patch:
    api_version: example.io/v1
    kind: ExampleConfig
    name: cluster
    namespace: "{{ my_role_namespace }}"
    patch:
      - op: add
        path: /spec/feature
        value:
          enabled: true
```

### Conditional Sub-Tasks

```yaml
- name: Deploy optional component
  when: my_role_enable_feature | bool
  ansible.builtin.include_tasks: deploy_feature.yml
```

### Return User Information

Use `agnosticd.core.agnosticd_user_info` to pass connection details back to RHDP:

```yaml
- name: Set user info for the lab
  agnosticd.core.agnosticd_user_info:
    data:
      app_url: "https://my-app-{{ my_role_namespace }}.{{ deployer.domain }}"
      app_user: "{{ my_role_user }}"
      app_password: "{{ my_role_password }}"
```

## Removal Tasks (tasks/remove_workload.yml)

Reverse the workload in the opposite order. Key patterns:

```yaml
- name: Remove application resources
  kubernetes.core.k8s:
    state: absent
    api_version: apps/v1
    kind: Deployment
    name: my-app
    namespace: "{{ my_role_namespace }}"

- name: Remove namespace
  kubernetes.core.k8s:
    state: absent
    definition:
      apiVersion: v1
      kind: Namespace
      metadata:
        name: "{{ my_role_namespace }}"
    wait: true
    wait_timeout: 120
```

Use `failed_when: false` for resources that may not exist (idempotent cleanup):

```yaml
- name: Remove optional feature configuration
  kubernetes.core.k8s_json_patch:
    api_version: example.io/v1
    kind: ExampleConfig
    name: cluster
    patch:
      - op: remove
        path: /spec/feature
  failed_when: false
```

## Variable Conventions

### Naming

All variables use a consistent prefix matching the role name:

```yaml
# Role: ocp4_workload_my_lab
ocp4_workload_my_lab_namespace: my-lab
ocp4_workload_my_lab_app_name: my-application
ocp4_workload_my_lab_replicas: 2
ocp4_workload_my_lab_enable_feature: true
```

### Categories

| Category | Pattern | Example |
|----------|---------|---------|
| Namespaces | `*_namespace` | `ocp4_workload_my_lab_namespace: my-lab` |
| Resource names | `*_name` | `ocp4_workload_my_lab_app_name: my-app` |
| Container images | `*_image` | `ocp4_workload_my_lab_image: quay.io/org/app:v1.0` |
| Feature flags | `*_enable_*` or `*_create_*` | `ocp4_workload_my_lab_enable_monitoring: true` |
| Resource sizing | `*_cpu_*`, `*_memory` | `ocp4_workload_my_lab_memory: 2Gi` |
| Credentials | `*_user`, `*_password` | `ocp4_workload_my_lab_admin_password: CHANGEME` |

### Defaults File

Every variable must have a default in `defaults/main.yml`. Defaults should be
sensible for a development/demo environment. Document each variable with a comment.

```yaml
# Namespace for lab resources
ocp4_workload_my_lab_namespace: my-lab

# Container image for the application (pin to specific tag)
ocp4_workload_my_lab_image: quay.io/org/app:v1.2.3

# Number of application replicas
ocp4_workload_my_lab_replicas: 1

# Enable monitoring stack (requires prometheus operator)
ocp4_workload_my_lab_enable_monitoring: false
```

## Jinja2 Templates

Place Kubernetes manifest templates in `templates/`. Use `.yaml.j2` extension.

```yaml
# templates/deployment.yaml.j2
apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{ ocp4_workload_my_lab_app_name }}"
  namespace: "{{ ocp4_workload_my_lab_namespace }}"
  labels:
    app: "{{ ocp4_workload_my_lab_app_name }}"
spec:
  replicas: {{ ocp4_workload_my_lab_replicas }}
  selector:
    matchLabels:
      app: "{{ ocp4_workload_my_lab_app_name }}"
  template:
    metadata:
      labels:
        app: "{{ ocp4_workload_my_lab_app_name }}"
    spec:
      containers:
        - name: "{{ ocp4_workload_my_lab_app_name }}"
          image: "{{ ocp4_workload_my_lab_image }}"
          ports:
            - containerPort: 8080
              protocol: TCP
```

## AgnosticV Integration

The collection is consumed in AgnosticV common.yaml:

### Requirements

```yaml
requirements_content:
  collections:
    - name: https://github.com/rhpds/<collection-repo>.git
      type: git
      version: main
```

### Workload Ordering

```yaml
workloads:
  - agnosticd.core_workloads.ocp4_workload_authentication_htpasswd  # Auth first
  - agnosticd.core_workloads.ocp4_workload_openshift_virtualization  # Operators
  - rhpds.<collection_name>.<role_name>                              # Your role
  - agnosticd.core_workloads.ocp4_workload_showroom                  # Showroom last
```

Order matters — list dependencies before dependents. Auth and operators before
application workloads. Showroom always last.

### Variable Overrides

Override role defaults in the common.yaml:

```yaml
ocp4_workload_my_lab_namespace: custom-namespace
ocp4_workload_my_lab_replicas: 3
ocp4_workload_my_lab_enable_monitoring: true
```

## What to Automate vs What the Learner Does

When reading module outlines and content to determine automation scope, distinguish:

### Automate (environment must have this before the lab starts)

- Operators the learner will USE but not install
- Applications the learner will CONFIGURE but not deploy from scratch
- Sample data, repositories, or databases the learner needs pre-populated
- User accounts, RBAC roles, and namespace setup
- Network policies or routes the learner needs in place
- Any "given that..." or "assuming..." prerequisites in the module steps

### Do NOT automate (the learner does this as part of the exercise)

- Steps where the learner runs commands (`oc apply`, `helm install`, etc.)
- Resources the learner creates, modifies, or troubleshoots
- Configuration changes that ARE the learning objective
- Deployments the learner scales, updates, or debugs

### How to Tell the Difference

Read each step in the module outline:

- **"Navigate to the console and observe..."** → The console must exist. Automate it.
- **"Run `oc apply -f deployment.yaml`"** → The learner does this. Do NOT automate.
- **"Open the application at https://..."** → The application must be deployed. Automate it.
- **"Edit the deployment to add a sidecar"** → The deployment must exist. Automate base deployment.
  The learner edits it. Do NOT automate the sidecar.
- **"Troubleshoot why the pod is failing"** → The broken pod must exist. Automate the broken state.

When in doubt, ask the user: "Should the learner deploy [X] themselves, or should
it be pre-configured?"
