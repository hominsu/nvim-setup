local function can_restore_session(read_stdin)
  if read_stdin or vim.fn.argc(-1) > 0 then return false end
  if vim.v.this_session ~= "" or #vim.api.nvim_list_uis() == 0 then return false end

  local windows = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.api.nvim_tabpage_list_wins(0))

  local single_tab = #vim.api.nvim_list_tabpages() == 1
  local single_window = #windows == 1
  local initial_buffer = vim.api.nvim_buf_get_name(0) == "" or vim.bo.filetype == "snacks_dashboard"

  return single_tab and single_window and not vim.bo.modified and initial_buffer
end

local function setup_restore()
  local group = vim.api.nvim_create_augroup("restore_workspace", { clear = true })
  local read_stdin = false

  vim.api.nvim_create_autocmd("StdinReadPre", {
    group = group,
    once = true,
    callback = function() read_stdin = true end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    once = true,
    callback = vim.schedule_wrap(function()
      if can_restore_session(read_stdin) then
        require("persistence").load()
      end
    end),
  })
end

return {
  "folke/persistence.nvim",
  lazy = false,
  opts = {
    need = 1,
    branch = false,
  },
  keys = require("config.keymaps").plugins["persistence.nvim"],
  init = setup_restore,
}
