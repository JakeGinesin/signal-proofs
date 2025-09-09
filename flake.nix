{
  description = "on god, signal flake";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname   = "signal proofs";
          src     = ./.;
        };

        devShells.default = pkgs.mkShellNoCC rec {
          buildInputs = with pkgs; [
            proverif
          ];

          shellHook = ''
            echo "Switching to signal dev-shell... :D"
          '';
        };
      }
    );
}
