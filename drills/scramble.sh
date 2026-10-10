#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-recon}"
echo "==> [BATTLE DRILL: SCRAMBLE] Engaging profile: ${PROFILE}"

case "${PROFILE}" in
  recon)
    echo "==> Spawning ephemeral recon sandbox..."
    nix develop ./loadouts/recon
    ;;
  workshop)
    echo "==> Spawning workshop development environment..."
    nix develop ./loadouts/workshop
    ;;
  *)
    echo "Error: Unknown profile '${PROFILE}'. Available: recon, workshop, sentinel"
    exit 1
    ;;
esac
