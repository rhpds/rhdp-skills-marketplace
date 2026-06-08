# Spec Quality Guidelines

Guidelines for evaluating and generating project specs. Used by the intake agent.

## Required Sections in design.md

A complete spec MUST have all of these:

1. **Project Name** — clear, descriptive
2. **Problem Statement** — what gap this fills, why it's needed (2-3 sentences)
3. **Target Audience** — role, experience level, what they already know
4. **Learning Objectives** — action-verb list (Configure, Deploy, Create, Troubleshoot)
5. **Content Type** — workshop or demo
6. **Products & Technologies** — official Red Hat product names
7. **Module Map** — table with module number, title, estimated duration
8. **Prerequisites** — what the learner needs before starting
9. **Environment** — what the learner sees when the lab starts (pre-deployed resources, no installs), plus whether automation is needed and what it must provision

## Optional Sections

- Design Principles — pedagogical approach, constraints
- Success Criteria — how to measure effectiveness
- Differentiation — how this differs from existing content (especially after RCARS vetting)

## Quality Checks

### Learning Objectives
- Start with action verbs: Configure, Deploy, Create, Implement, Troubleshoot, Monitor, Scale
- NOT: Understand, Learn, Know, Be familiar with (too vague)
- Each objective should be testable — could you write a validation check for it?

### Problem Statement
- Specific, not generic — "Platform engineers need to configure ServiceMesh mTLS but existing docs only cover Istio basics" NOT "People need to learn ServiceMesh"
- References a real persona with a real need

### Module Map
- Each module should be 10-30 minutes
- Total duration should match content type (workshop: 1-4 hours, demo: 15-45 minutes)
- Modules should build on each other logically

### Products & Technologies
- Use official Red Hat product names (Red Hat OpenShift, not just OpenShift)
- Include version if relevant to the content
- List upstream projects separately if the content covers them

### Environment
- **Learner view first** — describe what exists when the lab starts: "Pre-deployed: OCP cluster, RHBK via Operator, Quarkus sample app. Participants configure and use — no installs."
- **Automation scope second** — state whether automation is needed and what it must provision: "Automation needed: Yes — RHBK Operator, Quarkus app deployment, starter realm with intentional gaps for the break/fix exercise."
- Be specific about cluster requirements: "OCP 4.14+ cluster with 3 worker nodes" not just "OpenShift cluster"
- If automation is not needed, say so explicitly: "Automation needed: No — all resources are pre-existing on the shared cluster."
