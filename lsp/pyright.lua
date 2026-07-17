local python_utils = require("utils.python")
local root_utils = require("utils.root")

local function update_python_path(client, path)
  client.settings = vim.tbl_deep_extend("force", client.settings or client.config.settings or {}, {
    python = {
      pythonPath = path,
    },
  })
  client.config.settings = client.settings

  client:notify("workspace/didChangeConfiguration", {
    settings = client.settings,
  })
end

local function set_python_path(command)
  local path = command.args

  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  })

  for _, client in ipairs(clients) do
    update_python_path(client, path)
  end
end

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },

  root_dir = function(bufnr, on_dir)
    on_dir(root_utils.python_root(bufnr))
  end,

  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },

  on_attach = function(client, bufnr)
    update_python_path(client, python_utils.active_python(bufnr))

    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}
