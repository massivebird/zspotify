{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    {
      overlay = import ./overlay.nix;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # nix build .#hello
        packages.hello = pkgs.hello;

        # nix build
        defaultPackage = self.packages.${system}.hello;

        # nix develop .#hello or nix shell .#hello
        devShells.hello = pkgs.mkShell {buildInputs = [ pkgs.python312Packages.ffmpy ];};

        # nix develop or nix shell
        devShell = pkgs.mkShell {buildInputs = [
          pkgs.python312Packages.ffmpy
          pkgs.python312Packages.mutagen # editing metadata
          pkgs.python312Packages.music-tag
          pkgs.python312Packages.pillow
          pkgs.protobuf
          pkgs.python312Packages.tabulate
          pkgs.python312Packages.tqdm
          pkgs.python312Packages.librespot
        ];};
      }
    );
}

