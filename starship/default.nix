# Starship shell prompt with custom configuration
#
# See:  https://starship.rs
{ starship, symlinkJoin, makeWrapper, writeTextFile }:

with
  {
    starshipConfig = writeTextFile {
      name = "starship-config";
      text = builtins.readFile ./starship.toml;
      destination = "/starship.toml";
    };
  };

symlinkJoin {
  name = "starship";
  buildInputs = [makeWrapper];
  paths = [ starship ];
  postBuild = ''
    wrapProgram "$out/bin/starship" \
    --set STARSHIP_CONFIG "${starshipConfig}/starship.toml"
  '';
}
