{
  description = "Python DevShell with dependencies for the gpt-cli script";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported (not tested)
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper to provide system-specific attributes
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      forAllSystems = f: genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      });
    in
    {
      devShells = forAllSystems ({ pkgs, system }: {
        devShell.${system} =
          let
            python = pkgs.python310;
          in
          pkgs.mkShell {
            packages = [
              (python.withPackages (ps: with ps; [
                # ipython
                # python-lsp-server
                openai
                python-dotenv
              ]))
            ];
          };
      });
    };
}
