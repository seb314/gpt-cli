{
  description = "Python DevShell with dependencies for the gpt-cli script";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python-with-deps = (pkgs.python310.withPackages (ps:
              with ps; [
                # ipython
                # python-lsp-server
                openai
                python-dotenv
              ]));
        devShellDefault = pkgs.mkShell {
          packages = [ python-with-deps ];
        };
        package = pkgs.stdenv.mkDerivation rec {
          name = "gpt-cli";
          src = ./gpt-cli;
          phases = [ "installPhase" ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            echo "#!${python-with-deps}/bin/python3" > $out/bin/gpt-cli
            cat $src >> $out/bin/gpt-cli
            chmod +x $out/bin/gpt-cli
            runHook postInstall
          '';
        };
      in {
        devShells.default = devShellDefault;
        devShell = devShellDefault; # add the same under another path because nix-direnv or nix versions seem to expect different paths, or so

        packages.default = package;
        apps.default = {type = "app"; program = "${package}/bin/gpt-cli";};
      });
}
