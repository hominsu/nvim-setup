local fish = vim.fn.exepath "fish"
if fish ~= "" then
  vim.opt.shell = fish
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true

vim.opt.mouse = "a"
-- vim.opt.mousemoveevent = true

vim.opt.showmode = false

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes:2"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.confirm = true

vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.background = "dark"

if vim.g.neovide then
  vim.g.neovide_theme = "dark"
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 1.0

  vim.o.guifont = "Maple Mono NF CN:12"
  vim.opt.linespace = 1

  vim.g.neovide_input_ime = false

  local ime_group = vim.api.nvim_create_augroup("neovide_ime", { clear = true })
  local ime_rules = {
    { events = { "InsertEnter", "InsertLeave" }, pattern = "*" },
    { events = { "TermEnter", "TermLeave" }, pattern = "*" },
    { events = { "CmdlineEnter", "CmdlineLeave" }, pattern = "[/?]" },
  }

  for _, rule in ipairs(ime_rules) do
    vim.api.nvim_create_autocmd(rule.events, {
      group = ime_group,
      pattern = rule.pattern,
      callback = function(args)
        vim.g.neovide_input_ime = vim.endswith(args.event, "Enter")
      end,
    })
  end

  local function save() vim.cmd.write() end
  local function copy() vim.cmd [[normal! "+y]] end
  local function paste() vim.api.nvim_paste(vim.fn.getreg "+", true, -1) end

  vim.keymap.set({ "n", "i", "v" }, "<D-s>", save, { desc = "Save" })
  vim.keymap.set("v", "<D-c>", copy, { silent = true, desc = "Copy" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<D-v>", paste, { silent = true, desc = "Paste" })

  local modes = { "n", "i", "v" }
  local scale = {
    default = 1.0,
    min = 0.5,
    max = 2.0,
    step = 1.05,
  }

  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor or scale.default

  local function change_scale(factor)
    vim.g.neovide_scale_factor = math.max(scale.min, math.min(scale.max, vim.g.neovide_scale_factor * factor))
  end

  vim.keymap.set(modes, "<D-->", function() change_scale(1 / scale.step) end, { desc = "Decrease Neovide scale" })
  vim.keymap.set(modes, "<D-+>", function() change_scale(scale.step) end, { desc = "Increase Neovide scale" })
  vim.keymap.set(modes, "<D-0>", function() vim.g.neovide_scale_factor = scale.default end, { desc = "Reset Neovide scale" })
  vim.keymap.set("n", "<F11>", function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end, { desc = "Toggle Neovide fullscreen" })
end
