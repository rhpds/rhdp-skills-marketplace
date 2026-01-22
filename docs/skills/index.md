---
layout: default
title: Skills Reference
---

# Skills Reference

Complete guide to all RHDP Skills Marketplace skills.

---

## Showroom Skills (Content Creation)

For creating Red Hat Showroom workshops and demos.

### [/create-lab](create-lab.html)
Generate workshop lab modules with Know/Do/Check structure.

**Before you start:** Create repository from Showroom template

**Use when:** Creating hands-on workshop content

---

### [/create-demo](create-demo.html)
Generate presenter-led demo content with Know/Show structure.

**Before you start:** Create repository from Showroom template

**Use when:** Creating presenter-led demonstrations

---

### [/verify-content](verify-content.html)
Validate content quality and Red Hat standards compliance.

**Before you start:** Have workshop content ready in current directory

**Use when:** Checking content before publishing

---

### [/blog-generate](blog-generate.html)
Transform workshop content into blog post format.

**Before you start:** Complete workshop content ready

**Use when:** Publishing content to Red Hat Developer blog

---

## AgnosticV Skills (RHDP Provisioning)

For creating and managing RHDP catalog items.

### [/agnosticv-catalog-builder](agnosticv-catalog-builder.html)
Create or update AgnosticV catalog files (unified skill).

**Before you start:** Clone agnosticv repo, verify RHDP access

**Use when:** Creating catalogs, updating descriptions, or generating info templates

---

### [/agv-validator](agv-validator.html)
Validate catalog configurations and best practices.

**Before you start:** Have catalog files in agnosticv repo

**Use when:** Validating before creating PR

---

## Health Skills (Post-Deployment Validation)

For creating validation and health check roles.

### [/validation-role-builder](validation-role-builder.html)
Create Ansible validation roles for post-deployment checks.

**Before you start:** Know what to validate (packages, services, etc.)

**Use when:** Building automated health checks

---

### [/ftl](ftl.html)
Generate automated graders and solvers for workshop testing.

**Before you start:** Have workshop content with clear success criteria

**Use when:** Creating automated workshop validation

---

## Quick Reference

| Skill | Namespace | Platform | Prerequisites |
|-------|-----------|----------|---------------|
| create-lab | Showroom | All | Showroom template repo |
| create-demo | Showroom | All | Showroom template repo |
| verify-content | Showroom | All | Workshop content |
| blog-generate | Showroom | All | Complete workshop |
| agnosticv-catalog-builder | AgnosticV | All | AgnosticV repo + access |
| agv-validator | AgnosticV | All | Catalog files |
| validation-role-builder | Health | All | Validation requirements |
| ftl | Health | All | Workshop with success criteria |

---

## Getting Help

- [Troubleshooting Guide](../reference/troubleshooting.html)
- [GitHub Issues](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- Slack: #forum-rhdp or #forum-rhdp-content

---

[← Back to Home](../index.html) | [Setup Guide →](../setup/)
