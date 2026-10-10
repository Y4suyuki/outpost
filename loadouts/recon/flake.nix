{
  description = "outpost: recon profile (disposable isolated sandbox)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "recon-sandbox";

          packages = with pkgs; [
            curl
            jq
            ripgrep
            fd
            tree
          ];

          shellHook = ''
            export OUTPOST_PROFILE="recon"
            export TMPDIR=$(mktemp -d -t outpost-recon-XXXXXX)

            echo "=========================================================="
            echo " [OUTPOST] Profile: RECON (Condition 4 - Isolated Sandbox)"
            echo " Ephemeral scratchpad: $TMPDIR"
            echo "=========================================================="

            trap 'rm -rf "$TMPDIR"; echo " [OUTPOST] Recon sandbox wiped."' EXIT
          '';
        };
      });
}
