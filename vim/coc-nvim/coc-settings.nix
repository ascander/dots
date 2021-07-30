{ bash-language-server
, rnix-lsp
}:

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

  metals.serverVersion = "0.10.5";

  languageserver = {
    bash = {
      command = bash-language-server + "/bin/bash-language-server";
      args = [ "start" ];
      filetypes = [ "sh" ];
      ignoredRootPaths = [ "~" ];
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
