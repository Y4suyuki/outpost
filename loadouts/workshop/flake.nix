{
  description = "outpost: workshop profile (engineering workstation baseline)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixpkgs-fmt.enable = true;
            shfmt.enable = true;
            yamlfmt.enable = true;
          };
        };
      in
      {
        formatter = treefmtEval.config.build.wrapper;
        checks.formatting = treefmtEval.config.build.check self;

        devShells.default = pkgs.mkShell {
          name = "workshop-station";

          packages = with pkgs; [
            # Workflow & Task Runners
            just
            git
            jq
            ripgrep
            fd

            # Formatting & Quality Control
            treefmtEval.config.build.wrapper
            yamlfmt
            shfmt
            nixpkgs-fmt
          ];

          shellHook = ''
            export OUTPOST_PROFILE="workshop"

            echo "=========================================================="
            echo " [OUTPOST] Profile: WORKSHOP (Condition 1 - Active Dev)"
            echo " Tools: just, git, treefmt, nixpkgs-fmt, ripgrep"
            echo " Run 'just' or 'nix fmt' to verify project hygiene."
            echo "=========================================================="
          '';
        };
      });
}
