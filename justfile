default:
@just --list

# Pre-Combat Check: Run all local linters and tests
pcc:
nix flake check
@if command -v ansible-lint >/dev/null; then ansible-lint materiel/playbooks; fi
@echo "PCC passed: Operational readiness verified."

# Execute cold-start simulation locally
scramble target="recon":
@./drills/scramble.sh --profile {{target}}

# Bootstrap Nix onto a non-Nix station target (run from the commander).
#   just bootstrap host=192.168.1.20 user=y4suyuki profile=garrison
# Requires materiel/playbooks/inventory/hosts.ini to name the host.
bootstrap host profile="garrison":
@ansible-playbook -i materiel/playbooks/inventory/hosts.ini \
  materiel/playbooks/site.yml \
  --limit "{{host}}" \
  --extra-vars "profile={{profile}}"
