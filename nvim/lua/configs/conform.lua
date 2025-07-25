local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    xml = { "xmlformatter" },
    yaml = { "yamlfmt" },
    terraform = { "tofu_fmt" },
    ["terraform-vars"] = { "tofu_fmt" },
    -- python = { "black" },
  },

  -- Prettier configuration options
  formatters = {
    yamlfmt = {
      prepend_args = {
        "-formatter",
        "retain_line_breaks_single=true",
      },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
