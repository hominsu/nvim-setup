return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "dark",
    transparent = false,
    code_style = {
      comments = "none",
      keywords = "none",
      functions = "none",
      strings = "none",
      variables = "none",
    },
    colors = {
      bg0 = "#282c33",
      fg = "#acb2be",
      purple = "#b477cf",
      green = "#a1c181",
      blue = "#73ade9",
      orange = "#bf956a",
      red = "#d07277",
      cyan = "#6eb4bf",
      yellow = "#dfc184",
      grey = "#5d636f",
      light_grey = "#878e98",
    },
  },
  config = function(_, opts)
    require("onedark").setup(opts)
    require("onedark").load()
  end,
}

