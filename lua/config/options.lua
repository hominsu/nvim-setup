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

local neovide_group = vim.api.nvim_create_augroup("neovide_config", { clear = true })
local neovide_setup_done = false

local function setup_neovide()
  if neovide_setup_done or not vim.g.neovide then
    return false
  end
  neovide_setup_done = true

  if vim.g.neovide_channel_id and not vim.g.clipboard then
    local function copy(lines)
      vim.rpcrequest(vim.g.neovide_channel_id, "neovide.set_clipboard", lines, "+")
    end

    local function paste()
      return vim.rpcrequest(vim.g.neovide_channel_id, "neovide.get_clipboard", "+")
    end

    vim.g.clipboard = {
      name = "neovide",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste, ["*"] = paste },
      cache_enabled = false,
    }

    vim.g.loaded_clipboard_provider = nil
    vim.cmd.runtime("autoload/provider/clipboard.vim")
  end

  vim.g.neovide_theme = "dark"
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_normal_opacity = 1.0

  vim.o.guifont = "Maple Mono NF CN:h15"
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
  local function paste() vim.api.nvim_paste(vim.fn.getreg "+", true, -1) end

  -- macOS
  vim.keymap.set({ "n", "i", "v" }, "<D-s>", save, { desc = "Save" })
  vim.keymap.set("x", "<D-c>", '"+y', { desc = "Copy" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<D-v>", paste, { desc = "Paste" })

  -- Windows
  vim.keymap.set({ "n", "i", "v" }, "<C-S-s>", save, { desc = "Save" })
  vim.keymap.set("x", "<C-S-c>", '"+y', { desc = "Copy" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-S-v>", paste, { desc = "Paste" })

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

  return true
end

if not setup_neovide() then
  vim.api.nvim_create_autocmd("UIEnter", {
    group = neovide_group,
    callback = function()
      setup_neovide()
    end,
  })
end
