local function set_python_path(command)
  local path = command.args

  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  })

  for _, client in ipairs(clients) do
    client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
      python = {
        pythonPath = path,
      },
    })

    client:notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end
end

local function get_project_root(bufnr)
  local root = vim.fs.root(bufnr or 0, {
    "uv.lock",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  })

  return root or vim.fn.getcwd()
end

local function get_python(bufnr)
  local root = get_project_root(bufnr)
  local venv_python = root .. "/.venv/bin/python"

  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end

  local venv = os.getenv("VIRTUAL_ENV")
  if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
    return venv .. "/bin/python"
  end

  local conda = os.getenv("CONDA_PREFIX")
  if conda and vim.fn.executable(conda .. "/bin/python") == 1 then
    return conda .. "/bin/python"
  end

  local python3 = vim.fn.exepath("python3")
  if python3 ~= "" then
    return python3
  end

  return "python3"
end

return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },

  root_markers = {
    "pyrightconfig.json",
    "uv.lock",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },

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
    local python = get_python(bufnr)

    client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
      python = {
        pythonPath = python,
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    })

    client:notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}
