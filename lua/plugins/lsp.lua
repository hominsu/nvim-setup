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
    dependencies = { "saghen/blink.cmp" },
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
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-dictionary",
    },
    opts = {
      enabled = function()
        return vim.bo.filetype ~= "oil" and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end,
      keymap = require("config.keymaps").plugins["blink.cmp"],
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = { border = "rounded" },
        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
          window = { border = "rounded" },
        },
        list = {
          selection = { preselect = false, auto_insert = true },
        },
        ghost_text = { enabled = false },
      },
      fuzzy = {
        sorts = { "exact", "score", "sort_text" },
      },
      signature = {
        enabled = true,
        trigger = { show_on_insert = true },
        window = { border = "rounded" },
      },
      sources = {
        min_keyword_length = 2,
        default = { "lsp", "path", "snippets", "lazydev", "buffer" },
        per_filetype = {
          cpp = { "lsp", "path", "snippets", "buffer" },
          markdown = { "lsp", "snippets", "path", "buffer", "dictionary" },
        },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            fallbacks = {
              "buffer",
            },
            score_offset = 5,
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 2,
            score_offset = -5,
          },
          snippets = {
            score_offset = -5,
            min_keyword_length = 2,
            opts = {
              friendly_snippets = true, -- default
              extended_filetypes = {
                markdown = { "jekyll" },
                sh = { "shelldoc" },
              },
            },
          },
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            min_keyword_length = 1,
            opts = {},
            score_offset = 10,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 0,
          },
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" or type == "@" then
            return { "cmdline", "buffer" }
          end
          return {}
        end,
        completion = {
          trigger = {},
          list = {
            selection = {
              preselect = true,
              auto_insert = true,
            },
          },
          menu = {
            auto_show = function(ctx, _)
              return ctx.mode == "cmdwin"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
    },
  },
}
