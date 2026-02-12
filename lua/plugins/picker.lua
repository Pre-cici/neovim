-- lua/plugins/snacks.lua
local function get_root(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  local path = (name ~= "" and vim.fs.dirname(name)) or vim.uv.cwd()

  local git = vim.fs.find(".git", { path = path, upward = true })[1]
  if git then
    return vim.fs.dirname(git)
  end
  return vim.uv.cwd()
end

-- TODO: layout / show path / change path
return {
  "folke/snacks.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  opts = {
    picker = {
      win = {
        input = {
          keys = {

            ["`"] = { "print_cwd", mode = { "n", "i" } },

            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-c>"] = { "close", mode = { "n", "i" } },

            ["<c-n>"] = { "list_down", mode = { "i", "n" } },
            ["<c-p>"] = { "list_up", mode = { "i", "n" } },

            ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
            ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<a-.>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<a-/>"] = { "toggle_regex", mode = { "i", "n" } },
            ["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },

            ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },

            ["<c-q>"] = { "qflist", mode = { "i", "n" } },

            ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
            ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
          },
        },
      },
      actions = {
        toggle_cwd = function(p)
          local root = vim.fs.normalize(get_root(p.input.filter.current_buf))
          local cwd = vim.fs.normalize(vim.uv.cwd() or ".")
          local current = p:cwd()
          p:set_cwd(current == root and cwd or root)
          p:find()
        end,
      },
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader><space>", function() Snacks.picker.files({ layout={preset="telescope"}, cwd = get_root(0) }) end,
      desc = "Find Files" },

    { "<leader>bb", function() Snacks.picker.buffers({ layout={preset="select"} }) end, desc = "Buffers" },

    { "<leader>fb", function() Snacks.picker.buffers({ layout={preset="select"}, hidden = true, nofile = true }) end,
      desc = "Buffers (all)" },

    { "<leader>ff", function() Snacks.picker.files({ layout={preset="telescope"}, cwd = get_root(0), hidden = true, follow = true }) end,
      desc = "Find Files (Hidden)" },

    { "<leader>fr", function() Snacks.picker.recent({ layout={preset="telescope"}, cwd = get_root(0) }) end,
      desc = "Recent" },


    { "<leader>fp", function() Snacks.picker.projects({layout={preset="select"}}) end, desc = "Projects" },


    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },

    { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highligh" },

    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },

    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },

    -- { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo" },


    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },


    { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },


    { "<leader>/", function() Snacks.picker.grep({ layout={preset="ivy"}, cwd = get_root(0), live = true }) end,
      desc = "Grep (Root)" },
    { "<leader>sg", function() Snacks.picker.grep({ layout={preset="ivy"}, cwd = get_root(0), live = true }) end,
      desc = "Grep (Root)" },
    { "<leader>sw", function() local w = vim.fn.expand("<cword>") Snacks.picker.grep({ layout={preset="ivy"}, cwd = get_root(0), search = w, live = true }) end,
      desc = "Grep Word (Root)" },

    { "<leader>sb", function() Snacks.picker.lines({layout={preset="ivy_split"}}) end, desc = "Search Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers({layout={preset="ivy_split"}}) end, desc = "Search Open Buffers" },

    { "<leader>sd", function() Snacks.picker.diagnostics({layout={preset="ivy"}}) end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer({layout={preset="ivy"}}) end, desc = "Buffer Diagnostics" },


    { "<leader>sc", function() Snacks.picker.commands({ layout={preset="vscode"} }) end, desc = "Command" },
    { "<leader>s/", function() Snacks.picker.search_history({ layout={preset="vscode"}}) end, desc = "Search History" },
    { "<leader>s:", function() Snacks.picker.command_history({ layout={preset="vscode"}}) end, desc = "Command History" },

  },
}
