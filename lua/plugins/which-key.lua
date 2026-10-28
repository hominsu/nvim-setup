return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    win = { border = "rounded" },
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>s", group = "Split" },
      { "<leader>t", group = "Tabs/Terminal" },
      { "<leader>w", group = "Workspace" },
      { "<leader>h", group = "History" },
      { "<leader>n", group = "Notifications" },
    },
  },
}
