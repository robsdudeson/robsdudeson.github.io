{
  description = "Development shell for the GitHub Pages site";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              ruby_3_3
              bundler
              gnumake
              gcc
              pkg-config
              libxml2
              libxslt
              zlib
            ];
          };
        });
    };
}
