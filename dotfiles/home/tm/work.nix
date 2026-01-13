_:

{
  imports = [
    ./modules/dotfiles.nix
    ./modules/packages.nix
  ];

  home = {
    username = "tmaetzold_gcp";
    homeDirectory = "/home/tmaetzold_gcp";
    stateVersion = "25.05";
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
      jira_api_base_url: "https://.gardacp.com"
      jira_api_version: 2
    '';
  };

  programs.git = {
    enable = true;
    userName = "Trent Maetzold";
    userEmail = "trent.maetzold@gardacp.com";
  };
}
