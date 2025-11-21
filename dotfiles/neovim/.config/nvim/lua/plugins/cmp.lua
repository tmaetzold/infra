return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Override the default mapping for Enter
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<CR>"] = cmp.mapping(function(fallback)
          -- Don't accept completion with Enter, just insert a newline
          fallback()
        end, { "i", "s" }),

        -- Use Shift-Enter to accept completion
        ["<S-CR>"] = cmp.mapping.confirm({ select = true }),
      })

      return opts
    end,
  },
}
