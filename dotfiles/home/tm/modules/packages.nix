{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      claude-code
      lazydocker
      lazygit
      pure-prompt
      uv

      # infra depends
      ansible
      just
    ];
  };
}
