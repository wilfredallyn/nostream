{
  description = "nostream";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });

      mkcertDerivation = system: 
        let 
          pkgs = import nixpkgs { inherit system; };
        in pkgs.stdenv.mkDerivation {
          name = "mkcert-setup";
          buildInputs = [ pkgs.mkcert ];

          unpackPhase = "true";

          installPhase = ''
            mkdir -p $out/certs
            HOME=$out mkcert \
              -cert-file $out/certs/nostream.localtest.me.pem \
              -key-file $out/certs/nostream.localtest.me-key.pem \
              nostream.localtest.me
          '';
        };

    in utils.lib.eachSystem supportedSystems (system: 
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            postgresql
            redis
            (mkcertDerivation system)
          ];
        };

        packages.nostream = pkgs.callPackage ./nostream.nix { };
        # Define other services and configurations as required
      }
    );
}
