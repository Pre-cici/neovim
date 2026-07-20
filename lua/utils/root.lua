local M = {}

M.project_markers = {
  ".git",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "package.json",
  "go.mod",
  "Cargo.toml",
  "Makefile",
}

M.python_markers = {
  "ty.toml",
  "uv.lock",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "environment.yml",
  "conda.yaml",
  ".git",
}

function M.buffer_dir(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  return (name ~= "" and vim.fs.dirname(name)) or vim.uv.cwd()
end

function M.find(markers, start)
  local dir = vim.fs.normalize(start)
  while dir do
    for _, marker in ipairs(markers) do
      if vim.uv.fs_stat(vim.fs.joinpath(dir, marker)) then
        return dir
      end
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return start
end

function M.git_root(bufnr)
  local start = M.buffer_dir(bufnr)
  local git = vim.fs.find(".git", { path = start, upward = true })[1]
  if git then
    return vim.fs.dirname(git)
  end
  return vim.uv.cwd()
end

function M.project_root(start)
  return M.find(M.project_markers, start or vim.uv.cwd())
end

function M.python_root(bufnr)
  return M.find(M.python_markers, M.buffer_dir(bufnr))
end

return M
