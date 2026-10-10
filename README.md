# outpost

> Deterministic operational baselines, deployment templates, and continuous readiness harnesses powered by Nix and Ansible.

outpost treats every environment—from a local sandbox to an ephemeral cloud node—as an engineered station that must be secure, observable, and reproducible from a cold start.

For doctrinal principles and architecture rules, see PHILOSOPHY.md.

---

## Loadout Catalog

Pre-configured blueprints ready to initialize via: nix flake init -t

- recon (loadouts/recon)
  Ephemeral sandbox & playground: isolated TMPDIR, zero host secrets, auto-clean hook.

- workshop (loadouts/workshop)
  Primary software development: direnv integration, toolchains, formatters, local dev hooks.

- sentinel (loadouts/sentinel)
  Headless host / server node: base utilities, node_exporter, log shipping, SSH key lockdown.

---

## Quickstart

1. Initialize a Project Loadout
   mkdir my-project && cd my-project
   nix flake init -t github:<your-username>/outpost#workshop
   direnv allow

2. Enter a Disposable Sandbox (recon)
   nix develop github:<your-username>/outpost#recon

3. Bootstrap a Non-Nix Target (Ubuntu / Debian)
   ansible-playbook -i "target-ip," materiel/playbooks/site.yml --extra-vars "profile=sentinel"

---

## Operational Structure

outpost/
├── doctrine/          # Standards, rules of engagement (ROE), and PACE plans
├── drills/            # Executable operations (scramble, comms-check, sanitize)
├── loadouts/          # Flake blueprints for nix flake init -t (recon, workshop, sentinel)
├── materiel/          # Reusable building blocks (flakes, playbooks)
└── pci/               # CI test harnesses (Pre-Combat Inspections)

---

## Readiness Drills & Quality Gates

All changes must pass local Pre-Combat Checks (PCC) before merge, verified by automated Pre-Combat Inspections (PCI) in CI.

- Run local Pre-Combat Checks: just pcc
- Verify Ansible playbook syntax: ansible-lint materiel/playbooks
- Run cold-start simulation: just scramble target=recon

---

## License

MIT
