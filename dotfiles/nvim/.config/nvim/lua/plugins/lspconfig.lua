return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = false, -- Disable regular pyright
        basedpyright = {
          enabled = true,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                ignore = { ".venv", "venv", "**/__pycache__", ".pytest_cache", ".mypy_cache" },
              },
            },
          },
        },
      },
    },
  },
}
