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
    vim.keymap.set("v", "<leader>mt", function()
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      for i, line in ipairs(lines) do
        local indent = line:match("^%s*") or ""
        local content = line:gsub("^%s*", "")
        content = content:gsub("^%d+[.)]%s+", "")
        content = content:gsub("^%(%d+%)%s+", "")
        content = content:gsub("^[-*+]%s+", "")
        content = content:gsub("^%[[ xX]%]%s+", "")
        lines[i] = indent .. "- [ ] " .. content
      end
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
    end, vim.tbl_extend("force", opts, { desc = "Markdown: convert selection to TODO (- [ ])" }))

  end,
})
