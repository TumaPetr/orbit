---
marp: true
theme: default
paginate: true
style: |
  h1 { color: #0078D4; }
  li { margin-bottom: 0.5em; }
  .mermaid { display: flex; justify-content: center; height: 450px; }
---

# Building a Scalable Cloud Foundation
## Azure Landing Zones & Infrastructure as Code
**Speaker:** Petr Tůma
**Client:** Contoso Stakeholders

---

# The Challenge of Enterprise Cloud Adoption

- **Organic growth = Chaos:** Unorganized resources across departments.
- **Risks:** Security breaches and skyrocketing, untracked costs.
- **Maintenance Nightmares:** Manual configurations are impossible to scale.
- **The Goal:** We need a solid, secure foundation *before* we build the applications.

---

# What is an Azure Landing Zone?

Think of it as the plumbing, roads, and security of a new city.

- **Pre-configured environment:** Centralized Network, Security, Identity, and Governance.
- **Hub & Spoke Architecture:** A central control hub connecting to isolated application spokes.
- **Guardrails for Developers:** Azure Policies automatically enforce security rules.
- **Scalability:** Add new departments in minutes, fully secured.

---

# Architecture & Workflow Overview

<div class="mermaid">
graph TD
    classDef highlight fill:#d4e6f1,stroke:#2874a6,stroke-width:2px;
    classDef security fill:#fadbd8,stroke:#e74c3c,stroke-width:2px;

    subgraph IaC ["1. IaC Workflow"]
        Dev["Engineer"] -->|Code| Git["GitHub"]
        Git -->|CI/CD| ARM["Azure API"]
    end

    subgraph ALZ ["2. Landing Zone Foundation"]
        ARM --> RootMG["Root Management Group"]
        RootMG --> PlatformMG["Platform (Shared)"]
        RootMG --> WorkloadMG["Workloads (Apps)"]

        PlatformMG --> HubVNet["Hub VNet\n(Firewall, DNS)"]:::highlight
        PlatformMG --> LAW["Central Logging"]:::security
        
        WorkloadMG --> Spoke1["Spoke VNet 1"]:::highlight
        WorkloadMG --> Spoke2["Spoke VNet 2"]:::highlight
    end

    HubVNet <-->|Peering| Spoke1
    HubVNet <-->|Peering| Spoke2
</div>

---

# Why Infrastructure as Code (IaC)?

We do not build this foundation by clicking in a portal. We write it as software.

- **Consistency & Standardization:** No "snowflake" or undocumented environments.
- **Speed & Agility:** Deploy a full department's environment in 5 minutes.
- **Disaster Recovery:** Rebuild the entire foundation from code if compromised.
- **Auditability:** Every change is tracked, reviewed, and approved via Git.

---

# IaC Options in Azure

- **ARM Templates:** The legacy native way (JSON-based, very complex).
- **Azure Bicep:** The modern native way (Microsoft specific, great day-0 support).
- **Terraform (HashiCorp):** **The Industry Standard.** Multi-cloud, massive community, and officially supported Microsoft Landing Zone modules.
- **Pulumi:** Developer-focused (uses standard programming languages like Python/C#).

*Recommendation: Terraform for standardizing Contoso's infrastructure.*

---

# Pros, Cons, and Prerequisites

### **Pros**
Repeatable, inherently secure, blazingly fast, and testable.

### **Cons**
Initial learning curve; requires a strict cultural shift (zero manual portal changes).

### **Prerequisites for Contoso**
- Version Control System (GitHub / Azure DevOps).
- CI/CD Pipelines for automated deployments.
- Upskilling the operations team to a developer mindset.

---

# Conclusion & Next Steps

1. **Adopt an Enterprise-Scale Landing Zone architecture.**
2. **Choose Terraform** as the standard IaC tool across Contoso.
3. **Start Small & Iterate:** Deploy the core Hub network and security policies first, then onboard the first application workload.

## Thank you. Questions?