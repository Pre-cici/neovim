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
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
            -- ["<c-p>"] = { "print_cwd", mode = { "n", "i" } },
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

  keys = {
    -- stylua: ignore
    { "<leader><space>", function() Snacks.picker.files({ layout={preset="telescope"}, cwd = get_root(0) }) end, desc = "Find Files" },
    { "<leader>bb", function() Snacks.picker.buffers({ layout={preset="select"} }) end, desc = "Buffers" },
    { "<leader>h", function() Snacks.picker.help() end, desc = "Help Pages" },

    { "<leader>ff", function() Snacks.picker.files({ cwd = get_root(0), follow = true }) end, desc = "Find Files" },
    { "<leader>fb", function() Snacks.picker.buffers({ layout={preset="select"} }) end, desc = "Buffers" },
    { "<leader>fB", function() Snacks.picker.buffers({ layout={preset="select"}, hidden = true, nofile = true }) end, desc = "Buffers (all)" },
    { "<leader>fr", function() Snacks.picker.recent({ cwd = get_root(0) }) end, desc = "Recent" },
    { "<leader>fh", function() Snacks.picker.highlights() end, desc = "Highligh" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fc", function() Snacks.picker.commands({ layout={preset="vscode"} }) end, desc = "Command" },
    { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>fT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undotree" },


    -- { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List" },
    -- { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    -- { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },

    { "<leader>/", function() Snacks.picker.grep({ layout={preset="ivy_split"}, cwd = get_root(0), live = true }) end, desc = "Grep (Root)" },

    { "<leader>sg", function() Snacks.picker.grep({ layout={preset="ivy_split"}, cwd = get_root(0), live = true }) end, desc = "Grep (Root)" },
    { "<leader>sw", function()
        local w = vim.fn.expand("<cword>")
        Snacks.picker.grep({ layout={preset="ivy_split"}, cwd = get_root(0), search = w, live = true })
      end, desc = "Grep Word (Root)" },
    { "<leader>sb", function() Snacks.picker.lines({layout={preset="ivy_split"}}) end, desc = "Search Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers({layout={preset="ivy_split"}}) end, desc = "Search Open Buffers" },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
  },
}
