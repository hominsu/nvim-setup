return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.register("bash", "sh")

      local languages = { "c", "cpp", "go", "lua", "vim", "vimdoc", "query", "bash", "cmake", "markdown", "markdown_inline", "regex" }
      local filetypes = vim.iter(vim.tbl_map(vim.treesitter.language.get_filetypes, languages)):flatten():totable()

      local function enable(buf)
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if pcall(vim.treesitter.start, buf) and lang and vim.treesitter.query.get(lang, "indents") then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
        pattern = filetypes,
        callback = function(args) enable(args.buf) end,
      })

      require("nvim-treesitter").install(languages, { summary = true }):await(vim.schedule_wrap(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(filetypes, vim.bo[buf].filetype) then enable(buf) end
        end
      end))
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 1,
      multiline_threshold = 1,
    },
  },
}
