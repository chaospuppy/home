-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "bashls", "terraformls", "tflint", "pyright" }

vim.lsp.enable(servers)
