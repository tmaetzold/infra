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
        lazydocker
        lazygit
        pure-prompt

        # programming
        cargo
        R
        rustc
        uv

        # formatters
        nixfmt
        ruff
        rustfmt

        # infra depends
        ansible
        just
      ]
      ++ lib.optionals osConfig.virtualisation.docker.enable [ distrobox ]
      ++ lib.optionals osConfig.services.xserver.enable (
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
