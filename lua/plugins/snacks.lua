return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      toggle = { enabled = true },
      picker = { enabled = true },
      laztgit = { enabled = true },
      bufdelete = { enabled = true },
      image = {
        enabled = true,
        doc = { render_math = true, inline = false },
        math = {
          latex = {
            font_size = "small",
          },
        },
      },
      terminal = { auto_insert = true, start_insert = true, win = { wo = { winbar = "" } } },

      -- ui
      animate = { enabled = true },
      words = { enabled = true },
      statuscolumn = { enabled = true },
      dashboard = { enabled = false },
      scope = { enabled = true },
      scroll = { enabled = true },
      notifier = { enabled = false },
      input = { enabled = true },
    },
  },
}
