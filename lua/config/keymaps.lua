local M = {}

M.defaults = {
  n = {
    ["："] = { ":", { desc = "Fullwidth colon -> command-line mode" } },
    ["？"] = { "?", { desc = "Fullwidth question mark -> backward search" } },

    ["<C-H>"] = { "<C-W>h", { desc = "Focus left window" } },
    ["<C-J>"] = { "<C-W>j", { desc = "Focus lower window" } },
    ["<C-K>"] = { "<C-W>k", { desc = "Focus upper window" } },
    ["<C-L>"] = { "<C-W>l", { desc = "Focus right window" } },

    ["<leader>sv"] = { "<C-w>v", { desc = "Split window vertically" } },
    ["<leader>sh"] = { "<C-w>s", { desc = "Split window horizontally" } },
    ["<leader>se"] = { "<C-w>=", { desc = "Equalize split sizes" } },
    ["<leader>sx"] = { ":close<Return>", { desc = "Close current split" } },

    ["<C-S-Up>"] = { ":resize -2<Return>", { desc = "Decrease window height" } },
    ["<C-S-Down>"] = { ":resize +2<Return>", { desc = "Increase window height" } },
    ["<C-S-Left>"] = { ":vertical resize -2<Return>", { desc = "Decrease window width" } },
    ["<C-S-Right>"] = { ":vertical resize +2<Return>", { desc = "Increase window width" } },

    ["<leader>to"] = {
      function()
        vim.cmd "tabnew"
        vim.cmd("tcd " .. vim.fn.fnameescape(vim.fn.getcwd()))
      end,
      { desc = "Open a new tab in cwd" },
    },
    ["<leader>tx"] = { ":tabclose<Return>", { desc = "Close current tab" } },
  },
  i = {},
  v = {},
  x = {},
  c = {},
  t = {
    ["<C-j>"] = { "<C-\\><C-N><C-w>j", { desc = "Move to lower window" } },
    ["<C-k>"] = { "<C-\\><C-N><C-w>k", { desc = "Move to upper window" } },
  },
}

M.plugins = {
  ["snacks.nvim"] = {
    -- search
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fs", function() Snacks.picker.grep() end, desc = "Grep Text" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    -- lsp
    { "gO", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
    { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "Calls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Calls Outgoing" },
    -- utils
    { "<leader>hs", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>tt", function() Snacks.terminal(nil, { count = 1, win = { position = "float", border = "rounded" } }) end, desc = "Toggle Terminal (Float)" },
    { "<leader>th", function() Snacks.terminal(nil, { count = 2, win = { position = "bottom" } }) end, desc = "Toggle Terminal (Bottom)" },
    { "<leader>tv", function() Snacks.terminal(nil, { count = 3, win = { position = "right" } }) end, desc = "Toggle Terminal (Right)" },
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
  },
  ["oil.nvim"] = {
    { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory (Oil)" },
  },
}

function M.load_defaults()
  for mode, mappings in pairs(M.defaults) do
    for lhs, mapping in pairs(mappings) do
      vim.keymap.set(mode, lhs, mapping[1], mapping[2] or {})
    end
  end
end

return M
