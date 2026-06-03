{
  description = "Word list generator";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      trezor-rev = "ec21884db9f3af236732121e7ccf97435b924915";

      data = pkgs.fetchurl {
        url =
          "https://raw.githubusercontent.com/trezor/python-mnemonic/"
          + trezor-rev
          + "/mnemonic/wordlist/english.txt";
        sha256 = "1nnv4hxyv8pkxzw9yvb40f2yb47wkqckz3qdi3w4nyvjli9yspig";
      };

      src = ./.;

      haskell = pkgs.haskellPackages.ghcWithPackages (p: [
        p.base
        p.containers
        p.MonadRandom
        p.optparse-applicative
        p.text
        p.vector
      ]);

    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          haskell
          pkgs.cabal-install
        ];
      };
      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        name = "wordlist";
        inherit src;
        buildInputs = [
          pkgs.makeWrapper
          haskell
        ];
        installPhase = ''
          cd wordlist
          runhaskell Setup.hs configure
          runhaskell Setup.hs build
          mkdir -p $out/bin
          cp ./dist/build/wordlist/wordlist $out/bin
          wrapProgram $out/bin/wordlist --set WORD_LIST_PATH ${data}
        '';
      };
    };
}
