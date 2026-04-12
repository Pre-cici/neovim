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
      image = { enabled = true },
      terminal = {
        auto_insert = true,
        start_insert = true,
      },

      -- ui
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
