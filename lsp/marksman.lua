---@brief
---
--- https://github.com/artempyanykh/marksman
---
--- Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.
---
--- Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.
---
--- Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases

local function root_dir(bufnr, on_dir)
  local vault = vim.fs.root(bufnr, { ".obsidian" })
  if vault then
    on_dir(vault)
    return
  end

  local root = vim.fs.root(bufnr, { ".marksman.toml", ".git" })
  if root then
    on_dir(root)
    return
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    on_dir(vim.uv.cwd())
    return
  end

  on_dir(vim.fs.dirname(path))
end

---@type vim.lsp.Config
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = root_dir,
}
