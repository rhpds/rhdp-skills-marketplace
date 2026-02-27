---
layout: default
title: Glossary
---

# Glossary

Common terms used in RHDP Skills Marketplace, explained in plain language.

---

## General Terms

### Agent Skills
AI-powered helpers that run inside Claude Code (a text editor). You type a command like `/showroom:create-demo` and the AI generates content for you.

**Example:** `/showroom:create-lab` is a skill that creates workshop content.

### Claude Code
An AI-powered text editor made by Anthropic. Think of it like Microsoft Word, but for creating technical content with AI help.

**Download:** [https://claude.ai/download](https://claude.ai/download)

### Cursor
An alternative text editor (similar to Claude Code) that can also run these skills. Currently experimental support.

### Namespace
A grouping of related skills. Think of it like folders:
- **showroom** folder = skills for creating demos/workshops
- **agnosticv** folder = skills for RHDP internal catalog work
- **health** folder = skills for testing deployments

**Why it matters:** You only install the namespace you need (most people want "showroom").

### Skill
A command you run in Claude Code that uses AI to help you. Skills start with `/` like `/showroom:create-demo`.

**Think of it as:** A specialized AI assistant for specific tasks.

---

## Content Creation Terms

### AsciiDoc
A text format for writing documentation (like Microsoft Word's ".docx" but simpler). Don't worry - the AI writes this for you.

**What you see:** Plain text with some symbols like `=` for headings
**What customers see:** Nicely formatted web pages

### Demo
Content where **you present** and customers watch. Like a PowerPoint presentation but interactive.

**Use `/showroom:create-demo` for this.**

### Know/Do/Check Structure
A teaching pattern used in workshops:
- **Know:** Explain the concept
- **Do:** Customer tries it hands-on
- **Check:** Verify they did it right

### Lab (or Workshop)
Content where **customers follow along** hands-on. They click buttons, run commands, etc.

**Use `/showroom:create-lab` for this.**

### Module
One section of a workshop or demo. Like a chapter in a book.

**Example:** A 3-module workshop = 3 chapters customers complete.

### Red Hat Showroom
Red Hat's platform for hosting workshops and demos. Customers access your content through a web browser.

**Website:** [https://red.ht/showroom](https://red.ht/showroom)

### Template
A pre-made starting point. Instead of creating everything from scratch, you copy a template and fill in your content.

**Think of it as:** Like using a PowerPoint template instead of blank slides.

---

## Technical Terms (RHDP Internal)

### AgnosticV
Red Hat Demo Platform's system for deploying workshop infrastructure (servers, databases, etc.).

**Who uses this:** RHDP internal team
**Skills:** `/agnosticv:catalog-builder`, `/agnosticv:validator`

### Bastion
A "jump server" - a computer you connect to first before accessing other systems.

**Why it exists:** Security - you can't directly access production systems.

### Catalog
In RHDP, a catalog item is a deployable workshop/demo configuration.

**Think of it as:** A recipe that tells RHDP what infrastructure to create.

### CNV (OpenShift Virtualization)
Red Hat's technology for running virtual machines on OpenShift. Used for multi-user workshops.

**Why it matters:** Lets multiple students use the same cluster without interfering with each other.

### Collection (Ansible)
A package of automation code. Like an app on your phone, but for IT automation.

### Deployment
The process of setting up infrastructure (servers, databases, apps) for a workshop or demo.

**Example:** "We deployed the OpenShift workshop to AWS."

### HCP (Hosted Control Plane)
A way to run OpenShift clusters more efficiently.

**For most users:** Don't worry about this - it's an infrastructure choice.

### Infrastructure
The underlying computers, networks, and storage needed to run a workshop.

**Example:** "We need AWS infrastructure for this GPU demo."

### Provisioning
Setting up infrastructure automatically. Instead of manually creating servers, RHDP provisions them.

**Think of it as:** Like ordering food delivery vs. cooking - provisioning does it for you.

### RHDP
**R**ed **H**at **D**emo **P**latform - Red Hat's internal system for deploying workshops and demos.

**Website:** [https://demo.redhat.com](https://demo.redhat.com)

### SNO (Single Node OpenShift)
A lightweight OpenShift cluster running on one machine instead of many.

**Use case:** Edge computing demos, single-user workshops.

### UserInfo
Variables that get passed from deployed infrastructure to your workshop content.

**Example:** API keys, URLs, usernames that customers need.

### Validation Role
Automated tests to check if infrastructure deployed correctly.

**Example:** "Does the database exist? Is the web server running?"

### Workload
A component or service you want to deploy (like a database, monitoring tool, etc.).

**Example:** "We're deploying these workloads: OpenShift AI, Ansible Automation Platform, Showroom."

---

## Git Terms (Optional Knowledge)

**Note:** You don't need to know Git to create demos with Showroom skills, but these terms may appear.

### Clone
Making a copy of code from GitHub to your computer.

**Command:** `git clone <url>`
**Think of it as:** Downloading a project folder.

### Commit
Saving changes with a description of what you changed.

**Think of it as:** Hitting "Save" in Word, but with a note saying what you changed.

### Git
A system for tracking changes to files. Like "Track Changes" in Microsoft Word but for code/text.

**Why it exists:** So teams can collaborate without overwriting each other's work.

### GitHub
A website for storing and sharing Git projects. Like Dropbox but for code.

**Website:** [https://github.com](https://github.com)

### Pull
Getting the latest changes from GitHub to your computer.

**Command:** `git pull`
**Think of it as:** Syncing Dropbox to get the latest files.

### Push
Sending your changes from your computer to GitHub.

**Command:** `git push`
**Think of it as:** Uploading files to Dropbox.

### Repository (Repo)
A project folder tracked by Git. Contains all files and history.

**Example:** "The Ansible workshop repository has 50 files."

---

## Platform Comparison

| Term | Claude Code | Cursor |
|------|-------------|--------|
| **Type** | AI-powered text editor | AI-powered code editor |
| **Skill Support** | ✅ Native (works perfectly) | ⚠️ Experimental (may not work) |
| **Best For** | Creating demos/workshops | Developers writing code |
| **Recommended?** | ✅ Yes | ⚠️ For developers only |

---

## Namespace Comparison

| Namespace | Who Uses It | What It Does | Skills |
|-----------|-------------|--------------|--------|
| **showroom** | Salespeople, SAs, content creators | Create demos & workshops | create-lab, create-demo, verify-content, blog-generate |
| **agnosticv** | RHDP internal team | Deploy workshop infrastructure | agnosticv-catalog-builder, agnosticv-validator |
| **health** | RHDP internal team | Deployment health validation | deployment-validator |
| **ftl** | RHDP internal team | Full Test Lifecycle lab grading | ftl:lab-validator |

---

## Still Confused?

- **Slack:** [#forum-demo-developers](https://redhat.enterprise.slack.com/archives/C04MLMA15MX)
- **GitHub Issues:** [Report unclear documentation](https://github.com/rhpds/rhdp-skills-marketplace/issues)
- **Email:** Ask your Red Hat contact

---

[← Back to Home](../) | [Quick Reference →](quick-reference.html) | [Troubleshooting →](troubleshooting.html)
