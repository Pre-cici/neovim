vim.lsp.enable('lua_ls')
vim.lsp.enable('stylua')
vim.lsp.enable('ruff')
vim.lsp.enable('pyright')
vim.lsp.enable('marksman')

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local Snacks = require 'snacks'

    local function has(method)
      return client:supports_method(method, bufnr) -- nvim 0.11 API
    end

    local function map(modes, lhs, rhs, desc, opts)
      opts = opts or {}
      opts.buffer = bufnr
      opts.desc = desc
      vim.keymap.set(modes, lhs, rhs, opts)
    end

    local float_opts = { border = 'rounded' }
    if has(vim.lsp.protocol.Methods.textDocument_hover) then
      map('n', 'K', function()
        vim.lsp.buf.hover(float_opts)
      end, 'Hover')
    end

    if has(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
      map('n', 'gK', function()
        vim.lsp.buf.signature_help(float_opts)
      end, 'Signature Help')
      map('i', '<C-k>', function()
        vim.lsp.buf.signature_help(float_opts)
      end, 'Signature Help')
    end

    -- =========================
    -- g* : goto family (classic)
    -- =========================
    if has(vim.lsp.protocol.Methods.textDocument_definition) then
      map('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
    end

    -- =========================
    -- <leader>c : code related
    -- =========================
    map('n', '<leader>cl', function()
      Snacks.picker.lsp_config()
    end, 'LSP Info')

    if has(vim.lsp.protocol.Methods.textDocument_codeAction) then
      map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code: Action')
      map('n', '<leader>cA', function()
        vim.lsp.buf.code_action { context = { only = { 'source' } }, apply = true }
      end, 'Code: Source Action')
    end

    if has(vim.lsp.protocol.Methods.textDocument_codeLens) then
      map({ 'n', 'x' }, '<leader>cc', vim.lsp.codelens.run, 'Code: Run Codelens')
      map('n', '<leader>cC', vim.lsp.codelens.refresh, 'Code: Refresh Codelens')
    end

    if has(vim.lsp.protocol.Methods.textDocument_documentHighlight) and Snacks.words and Snacks.words.jump and Snacks.words.is_enabled then
      map('n', ']]', function()
        if Snacks.words.is_enabled() then
          Snacks.words.jump(vim.v.count1)
        end
      end, 'Next Reference')
      map('n', '[[', function()
        if Snacks.words.is_enabled() then
          Snacks.words.jump(-vim.v.count1)
        end
      end, 'Prev Reference')
      map('n', '<A-n>', function()
        if Snacks.words.is_enabled() then
          Snacks.words.jump(vim.v.count1, true)
        end
      end, 'Next Reference')
      map('n', '<A-p>', function()
        if Snacks.words.is_enabled() then
          Snacks.words.jump(-vim.v.count1, true)
        end
      end, 'Prev Reference')
    end

    if has(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local hl_group = vim.api.nvim_create_augroup('user-lsp-highlight-' .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = hl_group,
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.buf.clear_references)
          pcall(vim.api.nvim_del_augroup_by_id, hl_group)
        end,
      })
    end
    if has(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end, 'Toggle Inlay Hints')
    end
  end,
})

