{
  description = "outpost: operational infrastructure, deployment templates, and automated readiness";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # Maintenance shell for working on outpost itself
        devShells.default = pkgs.mkShell {
          name = "outpost-maint";
          packages = with pkgs; [
            just
            git
            nixpkgs-fmt
            ansible
            ansible-lint
          ];
        };
      }) // {
        # Template registry for nix flake init -t
        templates = {
          recon = {
            path = ./loadouts/recon;
            description = "Disposable, isolated scratchpad for testing untrusted code";
          };
          workshop = {
            path = ./loadouts/workshop;
            description = "Full development environment with toolchains, treefmt, and runtime hooks";
          };
          sentinel = {
            path = ./loadouts/sentinel;
            description = "Lightweight headless server node baseline with telemetry & diagnostics";
          };
        };
      };
}
