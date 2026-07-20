local root_utils = require("utils.root")

---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(root_utils.python_root(bufnr))
  end,
  settings = {
    ty = {
      diagnosticMode = "openFilesOnly",
    },
  },
}
