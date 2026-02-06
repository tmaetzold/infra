{
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  home = {
    packages =
      with pkgs;
      [
        claude-code
        github-copilot-cli
        harlequin
        htop
        just
        lazydocker
        lazygit
        pure-prompt

        # programming
        cargo
        nodejs_24
        R
        rustc
        uv

        # formatters
        nixfmt
        ruff
        rustfmt
      ]
      ++ lib.optionals (
        osConfig ? virtualisation.docker.enable && osConfig.virtualisation.docker.enable
      ) (with pkgs; [ distrobox ])
      ++ lib.optionals (osConfig ? services.xserver.enable && osConfig.services.xserver.enable) (
        with pkgs;
        [
          # GUI applications
          ghostty
          zoom-us

          # Editors and IDEs
          code-cursor
          vscode

          # 3D printing and design
          orca-slicer
          blender
        ]
      );
  };
}
