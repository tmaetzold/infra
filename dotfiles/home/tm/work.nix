_:

{
  imports = [ ./base.nix ];

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
