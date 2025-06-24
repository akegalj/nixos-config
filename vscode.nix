{ config, pkgs, ... }:
let
  vsCode = with pkgs; (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        justusadam.language-haskell
        haskell.haskell
        mkhl.direnv
        eamodio.gitlens
        shardulm94.trailing-spaces
        davidlday.languagetool-linter
        ms-vsliveshare.vsliveshare
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "run-on-save";
          publisher = "pucelle";
          version = "1.9.0";
          sha256 = "5EsWgfbHLUILfPfn/nJygfi3z76DGTG+xyytV7Gz5eg=";
        }
        {
          name = "open-in-browser";
          publisher = "techer";
          version = "2.0.0";
          sha256 = "3XYRMuWEJfhureHmx1KfT+N9aBuqDagj0FErJQF/teg=";
        }
        {
          name = "language-purescript";
          publisher = "nwolverson";
          version = "0.2.8";
          sha256 = "2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.26.6";
          sha256 = "zYLAcPgvfouMQj3NJlNJA0DNeayKxQhOYNloRN2YuU8=";
        }
        {
          name = "bruno";
          publisher = "bruno-api-client";
          version = "3.1.0";
          sha256 = "jLQincxitnVCCeeaoX0SOuj5PJyR7CdOjK4Kl52ShlA=";
        }
      ];
    });
in
{
  users.users.akegalj.packages = [vsCode];
}
