{ pkgs, ... }:

{
  imports = [
    ./modules/dotfiles.nix
    ./modules/packages.nix
  ];

  home = {
    username = "tmaetzold_gcp";
    homeDirectory = "/home/tmaetzold_gcp";
    stateVersion = "25.05";
    packages = with pkgs; [
      bitbucket-cli
      jira-cli-go
      jiratui
    ];
    shellAliases = {
      jt = "jiratui ui";
    };
    sessionVariables = {
      NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };

  nixpkgs.config.allowUnfree = true;

  xdg.configFile = {
    "jiratui/config.yaml".text = ''
      jira_api_username: "tmaetzold_gcp"
      jira_api_token: ''${JIRA_API_TOKEN}
      jira_api_base_url: "https://jira.gardacp.com"
      jira_api_version: 2
      cloud: False
    '';
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Trent Maetzold";
          email = "trent.maetzold@gardacp.com";
        };
      };
    };
  };
}
