{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      claude-code
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
