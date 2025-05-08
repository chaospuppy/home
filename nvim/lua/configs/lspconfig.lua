-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "gopls", "bashls", "yamlls", "terraformls", "tflint" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Custom YAML configuration for Kubernetes
lspconfig.yamlls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemas = {
        -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        -- Add custom CRD schemas
        -- ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "*application-crd.yaml",
        -- ["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/certificate_v1.json"] = "*certificate.yaml",
        -- Use local schema files (if you've downloaded them)
        -- [vim.fn.expand("~/.config/nvim/schemas/crd-schemas/prometheus-operator.json")] = "*prometheus*.yaml",
      },
    },
  },
}

lspconfig.helm_ls.setup {
  cmd = { "helm_ls", "serve" },
  filetypes = { "helm" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern("Chart.yaml", "charts/", "chart/")(fname)
      or lspconfig.util.find_git_ancestor(fname)
  end,
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    ["helm-ls"] = {
      yamlls = {
        enabled = true,
        diagnosticsLimit = 50,
        showDiagnosticsDirectly = true,
      },
    },
  },
}

-- Specific configuration for tflint
-- lspconfig.terraformls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
