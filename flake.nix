{
  description = "Tree-sitter grammar for jj template language";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          src = pkgs.lib.cleanSource ./.;
        in
        {
          default = pkgs.tree-sitter.buildGrammar {
            language = "jjtemplate";
            version = "0.1.0";
            inherit src;
            postInstall = ''
              mv $out/parser $out/jjtemplate.so
            '';
          };
        }
      );

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            tree-sitter
            nodejs
            python3
          ];
        };
      });
    };
}
