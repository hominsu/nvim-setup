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
    picker = { enabled = true },
    quickfile = { enabled = true },
  },
  keys = require("config.keymaps").plugins["snacks.nvim"],
}
