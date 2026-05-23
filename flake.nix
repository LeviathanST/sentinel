{
  description: "Project Sentinel: The First-Principles Life Advisor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          requests
          beautifulsoup4
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # The Brain (Zig)
            zig
            zls

            # The Data Engine (Python)
            pythonEnv

            # Tools
            git
            curl
          ];

          shellHook = ''
            echo "--- Sentinel Life-Kernel Environment Loaded ---"
            echo "Zig version: $(zig version)"
            echo "Python: $(python --version)"
            echo "Run 'python scripts/crawler.py' to ingest data."
            echo "Run 'zig build' to compile the kernel (once implemented)."
          '';
        };
      }
    );
}
