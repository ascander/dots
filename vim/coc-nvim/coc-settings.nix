{ bash-language-server, metals, rnix-lsp }:

{
  coc.preferences = {
    extensionUpdateCheck = "never";
  };

  codeLens.enable = true;

  diagnostic = {
    errorSign = "💀 ";
    warningSign = "⚡";
    infoSign = "Ⓘ";
  };

  languageserver = {
    bash = {
      command = bash-language-server + "/bin/bash-language-server";
      args = [ "start" ];
      filetypes = [ "sh" ];
      ignoredRootPaths = [ "~" ];
    };
    metals = {
      command = metals + "/bin/metals-vim";
      rootPatterns = [ "build.sbt" ];
      filetypes = [ "scala" "sbt" "sc" ];
    };
    nix = {
      command = rnix-lsp + "/bin/rnix-lsp";
      filetypes = [ "nix" ];
    };
  };

  suggest = {
    autoTrigger = "trigger";
    noselect = false;
    enablePreview = true;
  };
}
