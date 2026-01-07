{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      claude-code
      github-copilot-cli
      lazydocker
      lazygit
      pure-prompt

      # programming
      cargo
      R
      rustc
      uv

      # infra depends
      ansible
      just
    ];
  };
}
