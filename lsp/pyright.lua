---@brief
---
--- https://github.com/microsoft/pyright
---
--- `pyright`, a static type checker and language server for python

local python_utils = require("utils.python")

local function get_python(bufnr)
  local root = python_utils.project_root(bufnr)
  local venv_python = root .. "/.venv/bin/python"

  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end

  local ok, venv_selector = pcall(require, "venv-selector")
  if ok then
    local python = venv_selector.python()
    if python and python ~= "" then
      return python
    end
  end

  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python3"
end

---@type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Use Ruff's import organizer instead
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

    client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })

    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}
