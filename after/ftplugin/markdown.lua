vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    -- Unordered list
    vim.keymap.set(
      "v",
      "<leader>ml",
      [[:s/^/- /<CR>:nohlsearch<CR>gv]],
      vim.tbl_extend("force", opts, { desc = "Markdown: add unordered list (- )" })
    )

    -- Ordered list
    vim.keymap.set(
      "v",
      "<leader>mo",
      [[:s/^/1. /<CR>:nohlsearch<CR>gv]],
      vim.tbl_extend("force", opts, { desc = "Markdown: add ordered list (1.)" })
    )

    -- Remove "- "
    vim.keymap.set(
      "v",
      "<leader>mL",
      [[:s/^\s*-\s\+//<CR>:nohlsearch<CR>gv]],
      vim.tbl_extend("force", opts, { desc = "Markdown: remove unordered list prefix" })
    )

    -- Add unchecked todo prefix for each selected line (keeps indentation)
    -- It also converts existing bullets/ordered/todo to "- [ ] ".
    vim.keymap.set(
      "v",
      "<leader>mt",
      [[:s/^\(\s*\)\(\(\d\+[.)]\s\+\|(\d\+)\s\+\|[-*+]\s\+\)\?\(\[\s*[xX ]\s*\]\s\+\)\?/\1- [ ] /<CR>:nohlsearch<CR>gv]],
      vim.tbl_extend("force", opts, { desc = "Markdown: convert selection to TODO (- [ ] )" })
    )
  end,
})

