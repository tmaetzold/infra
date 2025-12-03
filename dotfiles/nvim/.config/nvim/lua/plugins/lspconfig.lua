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
              importStrategy = "useBundled",
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                exclude = { ".venv", "venv", "**/__pycache__", ".pytest_cache", ".mypy_cache" },
              },
            },
          },
        },
      },
    },
  },
}
