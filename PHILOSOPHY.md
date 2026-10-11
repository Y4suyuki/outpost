# OUTPOST DOCTRINE & PHILOSOPHY

> *"An outpost is not merely where you arrive; it is an engineered perimeter of immediate operational readiness."*

Modern software delivery frequently reduces deployment to "shipping code through CI." In contrast, mission-critical systems and expeditionary operations treat any deployment as establishing a secure, observable, and reproducible station in potentially hostile or unfamiliar territory.

`outpost` codifies this discipline into infrastructure-as-code and deterministic templates using **Nix**, **Ansible**, and automated **Continuous Readiness**.

---

## 1. Core Tenets

### I. Determinism Over Convenience
If an environment cannot be reproduced bit-for-bit from a clean slate, it does not exist. We reject implicit dependencies, global mutable state, and unpinned runtimes. Nix provides the cryptographic guarantee; Ansible provides the deterministic host bootstrap.

### II. The Perimeter Precedes the Workload
No code runs on an unfortified machine. In military doctrine, an outpost establishes defensive perimeters and early-warning observation posts before erecting quarters. In `outpost`, host hardening, root lockouts, zero-trust network baselines, and telemetry are prerequisites, never afterthoughts.

### III. Zero Environmental Drift
A machine is either in its declared state or it is compromised. Playbooks and flakes are executed to enforce idempotency (`changed = 0`). Any manual intervention is considered technical debt that must be back-ported to doctrine immediately.

### IV. The Ephemeral Mindset
Every machine—whether a remote VPS, a local VM, or a development sandbox—must be treated as disposable. Persistent data must be deliberately mounted or forwarded; the underlying machine can be destroyed and reconstructed at any moment without operational loss.

---

## 2. Priorities of Work

When establishing a new station, operations strictly follow this non-negotiable sequence:

1. **Perimeter & Security (Overwatch):**
   * SSH key pinning, root account lockout, strict firewall defaults (`nftables`/UFW).
   * Fail2ban or active defense mechanisms.
   * Zero-trust mesh networking (WireGuard/Tailscale) bound before public exposure.

2. **Communications & Routing (Signal):**
   * DNS configuration, internal mesh route advertisement, and strict egress policies.

3. **Telemetry & Observation (Early Warning):**
   * `node_exporter` or system metrics ingestion.
   * Centralized log shipping and health checks.
   * An unmonitored node is considered a blind outpost.

4. **Logistics & Runtime (Supply Depot):**
   * Declarative base package installation via Nix flakes or Ansible roles.
   * Container runtime setup and isolated persistent volume definitions.

5. **Mission Execution (Operations):**
   * Spawning target `devShells`, executing applications, or running sandbox experiments.

---

## 3. Inspection Standards: PCC & PCI

Before any deployment steps outside the wire, it passes two tiers of verification:

### Pre-Combat Checks (PCC) — Local Verification
Performed on the developer's workstation before pushing:
* **Syntax & Formatting:** Strict linting across Nix, Ansible, shell scripts, and Markdown.
* **Secret Hygiene:** Pre-commit scans to ensure zero keys, tokens, or credentials enter version control.
* **Flake Check:** Local `nix flake check` verifying buildability and lockfile integrity.

### Pre-Combat Inspections (PCI) — Automated Pipeline
Executed by CI runners prior to accepting changes into `main`:
* **Idempotency Gate:** Ansible playbooks run against fresh target containers twice. A non-zero change status on the second run fails the pipeline.
* **Hermetic Evaluation:** Flake builds evaluated in clean sandboxes without ambient network contamination.
* **Security Clearance:** Automated vulnerability and CVE scanning against base packages and flake inputs.

---

## 4. Operational Readiness Profiles

`outpost` segments environments into distinct clearance levels based on operational intent:

* **Profile: `recon` (Disposable Sandbox)**
  * Temporary scratchpads for evaluating untrusted code or rapid prototyping.
  * No access to host secrets or personal keys; strict egress restrictions; automated wipe on exit.

* **Profile: `tactical` (Project Development)**
  * Scoped development environments powered by Nix flakes and `direnv`.
  * Secrets scoped per-project; access to local database and testing harnesses.

* **Profile: `garrison` (Persistent Host / Infrastructure)**
  * Hardened servers, homelab nodes, or primary workstations.
  * Full telemetry, automated security updates, systemd service management, and durable backup policies.

---

## 5. PACE Resilience Planning

Every environment must maintain a PACE fallback for connectivity, updates, and recovery:

* **Primary (P):** GitHub repository flakes and automated CI pipelines.
* **Alternate (A):** Local Git mirror or self-hosted registry.
* **Contingency (C):** Pre-built Nix closure archives or standalone `ansible-pull` manifests.
* **Emergency (E):** Minimal, POSIX-compliant bootstrap shell script providing raw, secure SSH recovery.
