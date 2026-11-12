return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true, animate = { enabled = true } },
    notifier = { enabled = true, timeout = 5000 },
    input = { enabled = true },
    words = {
      enabled = true,
      debounce = 100,
      modes = { "n", "i", "c" },
    },
    picker = {
      enabled = true,
      sources = {
        projects = {
          dev = { "~/workspace" },
          recent = true,
          max_depth = 3,
        },
      },
    },
    quickfile = { enabled = true },
  },
  keys = require("config.keymaps").plugins["snacks.nvim"],
}
