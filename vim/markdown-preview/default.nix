{ buildVimPluginFrom2Nix, fetchFromGitHub, mkYarnPackage, nodejs, src, substituteAll }:

let
  app = mkYarnPackage {
    name = "markdown-preview-app";
    src = "${src}/app";
    packageJSON = src + "/package.json";
    yarnLock = src + "/yarn.lock";
    installPhase = ''
      mkdir $out
      mv node_modules $out/node_modules
      mv deps $out/deps
    '';
    distPhase = ''
      true
    '';
  };
in buildVimPluginFrom2Nix {
  pname = "markdown-preview";
  src = src;
  version = src.rev;
  patches = [
    (substituteAll {
      src = ./node-path.patch;
      node = "${nodejs}/bin/node";
    })
  ];
  buildPhase = ''
    rm -r app
    ln -s ${app}/deps/markdown-preview-vim app
  '';
}

