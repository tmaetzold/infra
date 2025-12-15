{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      claude-code
      lazygit
      pure-prompt
      uv

      # infra depends
      ansible
      just
    ];
  };
}
