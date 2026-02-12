---@brief
---
--- https://github.com/microsoft/pyright
---
--- `pyright`, a static type checker and language server for python

local function set_python_path(command)
  local path = command.args
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  })
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python =
        vim.tbl_deep_extend("force", client.settings.python --[[@as table]], { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    client:notify("workspace/didChangeConfiguration", { settings = nil })
  end
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
    -- Add project root to PYTHONPATH so SnipRun can import local packages
    local function project_root()
      local buf = vim.api.nvim_buf_get_name(0)
      local start = (buf ~= "" and vim.fs.dirname(buf)) or vim.loop.cwd()
      local markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" }
      local found = vim.fs.find(markers, { path = start, upward = true })[1]
      return found and vim.fs.dirname(found) or vim.loop.cwd()
    end

    local function prepend_env(name, value)
      local sep = ":"
      local cur = vim.env[name] or ""
      if cur == "" then
        vim.env[name] = value
        return
      end
      for entry in string.gmatch(cur, "([^" .. sep .. "]+)") do
        if entry == value then
          return
        end
      end
      vim.env[name] = value .. sep .. cur
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = "*.py",
      callback = function()
        prepend_env("PYTHONPATH", project_root())
      end,
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure pyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}
