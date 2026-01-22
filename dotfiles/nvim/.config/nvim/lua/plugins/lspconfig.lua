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
                include = {},
                exclude = { ".venv", "venv", "**/__pycache__", ".pytest_cache", ".mypy_cache" },
                ignore = {},
                -- |--------------------------------------------------------------------|
                -- | Setting | Files Analyzed? | Errors Shown? | Available for Imports? |
                -- |---------|-----------------|---------------|------------------------|
                -- | include | ✅ Yes          | ✅ Yes        | ✅ Yes                 |
                -- | exclude | ❌ No           | ❌ No         | ⚠️ Only if imported    |
                -- | ignore  | ✅ Yes          | ❌ No         | ✅ Yes                 |
                -- |--------------------------------------------------------------------|
                inlayHints = {
                  callArgumentNames = false,
                  callArgumentNamesMatching = false,
                  functionReturnTypes = false,
                  genericTypes = false,
                  variableTypes = false,
                },
              },
            },
          },
        },
        r_language_server = { mason = false },
      },
    },
  },
}
