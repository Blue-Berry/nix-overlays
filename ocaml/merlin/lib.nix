{ fetchFromGitHub
, lib
, ocaml
, buildDunePackage
, yojson
, csexp
, result
, merlin
}:

let
  merlinVersion = "4.12";

  ocamlVersionShorthand = lib.concatStrings
    (lib.take 2 (lib.splitVersion ocaml.version));

  version = "${merlinVersion}-${ocamlVersionShorthand}";
  isFlambda2 = lib.hasSuffix "flambda2" ocaml.version;
in

buildDunePackage {
  pname = "merlin-lib";
  version = version;
  src =
    if isFlambda2 then
      fetchFromGitHub
        {
          owner = "janestreet";
          repo = "merlin-jst";
          rev = "105231128fbba145a42a59c88d2507805a4de9ed";
          hash = "sha256-duqR9WJHQcdzH8T5m/W7nQ7G7ztslgzceia9V5LjKJk=";
        }
    else if lib.versionOlder "5.3" ocaml.version
    then
      builtins.fetchurl
        {
          url = "https://github.com/ocaml/merlin/releases/download/v5.4-503/merlin-5.4-503.tbz";
          sha256 = "1g1cmxscpygk2ig76khcmvz3lgd31xzgzrwj6904r9cwk867ir7j";
        }
    else if lib.versionOlder "5.2" ocaml.version
    then
      builtins.fetchurl
        {
          url = "https://github.com/ocaml/merlin/releases/download/v5.3-502/merlin-5.3-502.tbz";
          sha256 = "1g14maryp5aw02a0chj9xqbdkky125g4y38cxwqnxylp4gqldsic";
        }
    else if lib.versionOlder "5.1" ocaml.version
    then
      builtins.fetchurl
        {
          url = "https://github.com/ocaml/merlin/releases/download/v4.17.1-501/merlin-4.17.1-501.tbz";
          sha256 = "0055n11ghrxypd6fjx67fnnwj8csp3jgplsnjiiyj28zhym0frrp";
        }
    else if lib.versionOlder "5.0" ocaml.version
    then
      builtins.fetchurl
        {
          url = "https://github.com/ocaml/merlin/releases/download/v4.14-500/merlin-4.14-500.tbz";
          sha256 = "03nps5mbh5lzf88d850903bz75g5sk33qc3zi7c0qlkmz0jg68zc";
        }
    else
      builtins.fetchurl {
        url = "https://github.com/ocaml/merlin/releases/download/v4.18-414/merlin-4.18-414.tbz";
        sha256 = "1h8cwdzvcyxdr6jkpsj7sn2r31aw2g4155l63a63a7hlcsiggmpn";
      };

  patches = if isFlambda2 then [../flambda2-patchs/merlin-lib.patch] else [];
  buildInputs = [ yojson csexp result ];
}
