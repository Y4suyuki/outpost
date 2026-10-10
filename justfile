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
