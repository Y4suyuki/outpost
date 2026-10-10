{
  description = "outpost: sentinel profile (headless server & telemetry node)";

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
          name = "sentinel-node";

          packages = with pkgs; [
            # Host & Network Diagnostics
            curl
            htop
            nmap
            iftop
            iotop
            tcpdump

            # Telemetry & Process Watch
            prometheus-node-exporter
          ];

          shellHook = ''
            export OUTPOST_PROFILE="sentinel"

            echo "=========================================================="
            echo " [OUTPOST] Profile: SENTINEL (Overwatch & Telemetry Node)"
            echo " Available: node_exporter, nmap, tcpdump, htop, iftop"
            echo " Run: node_exporter --web.listen-address=127.0.0.1:9100 &"
            echo "=========================================================="
          '';
        };
      });
}
