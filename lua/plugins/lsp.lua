local lsp = {
  event = { "BufReadPre", "BufNewFile" },
  server = {
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
      },
    },
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          codeLens = { enable = true },
          completion = { callSnippet = "Replace" },
          doc = {
            privateName = { "^_" },
          },
          hint = {
            enable = true,
            setType = true,
          },
          diagnostics = {
            unusedLocalExclude = { "_*" },
          },
        },
      },
    },
  },
}

local function root_dir(server)
  return function(bufnr, on_dir)
    local name = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.root(bufnr, vim.lsp.config[server].root_markers or {}) or (name ~= "" and vim.fs.dirname(name)) or vim.fn.getcwd())
  end
end

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = lsp.event,
    config = function()
      for name, config in pairs(lsp.server) do
        config.root_markers = vim.list_extend(config.root_markers or {}, vim.lsp.config[name].root_markers or {})
        config.root_dir = root_dir(name)
        vim.lsp.config(name, config)
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    event = lsp.event,
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = lsp.event,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = vim.tbl_keys(lsp.server),
      automatic_enable = vim.tbl_keys(lsp.server),
    },
  },
}
