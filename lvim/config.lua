-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.leader = ","
lvim.colorscheme = "gruvbox-material"
lvim.plugins = {
  { "tomasiser/vim-code-dark" },
  { "sainnhe/gruvbox-material" },
  { "fatih/vim-go" },
  { "David-Kunz/gen.nvim",
    opts = {
      host = "10.0.0.151",
      model = "gemma3:12b",
      port = "11434"
    }
  },
  { "airblade/vim-gitgutter" },
  -- { "iamcco/markdown-preview.nvim",
  --   build = "cd app && npx --yes yarn install"
  -- },
  { "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    -- build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
        local g = vim.g
        g.mkdp_filetypes = { "markdown" }
        g.mkdp_auto_start = 0
        g.mkdp_auto_close = 1
        g.mkdp_refresh_slow = 0
        g.mkdp_command_for_global = 0
        g.mkdp_open_to_the_world = 0
        g.mkdp_open_ip = ''
        g.mkdp_browser = 'firefox'
        g.mkdp_echo_preview_url = 0
        g.mkdp_browserfunc = ''
        g.mkdp_theme = 'dark'
        g.mkdp_echo_preview_url = 1
    end,
    ft = { "markdown" },
  },
}

require('lvim.lsp.manager').setup('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
      },
      schemas = {
        "https://json.schemastore.org/yamllint.json" == "*.yaml"
      }
      -- default
      -- schemas = require("schemastore").yaml.schemas(),
    },
  }
}
)

require'lspconfig'.terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
