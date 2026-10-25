return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    columns = {},
    view_options = {
      show_hidden = true,
    },
  },
  keys = require("config.keymaps").plugins["oil.nvim"],
}
