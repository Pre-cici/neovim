local M = {}

M.mode_names = {
  n = 'NORMAL',
  no = 'NORMAL (no)',
  nov = 'NORMAL (nov)',
  noV = 'NORMAL (noV)',
  ['noCTRL-V'] = 'NORMAL',
  niI = 'NORMAL i',
  niR = 'NORMAL r',
  niV = 'NORMAL v',
  nt = 'NTERMINAL',
  ntT = 'NTERMINAL (ntT)',
  v = 'VISUAL',
  vs = 'V-CHAR (Ctrl O)',
  V = 'V-LINE',
  Vs = 'V-LINE',
  [''] = 'V-BLOCK',
  i = 'INSERT',
  ic = 'INSERT',
  ix = 'INSERT',
  t = 'TERMINAL',
  R = 'RcPLACE',
  Rc = 'REPLACE (Rc)',
  Rx = 'REPLACEa (Rx)',
  Rv = 'V-REPLACE',
  Rvc = 'V-REPLACE (Rvc)',
  Rvx = 'V-REPLACE (Rvx)',
  s = 'SELECT',
  S = 'S-LINE',
  [''] = 'S-BLOCK',
  c = 'COMMAND',
  cv = 'COMMAND',
  ce = 'COMMAND',
  cr = 'COMMAND',
  r = 'PROMPT',
  rm = 'MORE',
  ['r?'] = 'CONFIRM',
  x = 'CONFIRM',
  ['!'] = 'SHELL',
}

M.mode_colors = {
  n = 'yellow',
  i = 'green',
  v = 'cyan',
  V = 'cyan',
  [''] = 'cyan',
  c = 'orange',
  s = 'purple',
  S = 'purple',
  [''] = 'purple',
  R = 'orange',
  r = 'orange',
  ['!'] = 'red',
  t = 'red',
}

M.colors = {
  none = 'NONE',
  fg = '#CAD3F5',
  bg = 'NONE',
  dark_bg = '#5B6078',
  blue = '#8AADF4',
  green = '#A6DA95',
  red = '#ED8796',
  yellow = '#EED49F',
  purple = '#F5BDE6',
  cyan = '#8BD5CA',
  white = '#B8C0E0',
  black = '#494D64',
  orange = '#F5A97F',
  grey = '#5B6078',
  bright_grey = '#A5ADCB',
  dark_grey = '#494D64',
  bright_blue = '#8AADF4',
  bright_green = '#A6DA95',
  bright_red = '#ED8796',
  bright_yellow = '#EED49F',
  bright_purple = '#F5BDE6',
  bright_cyan = '#8BD5CA',
  bright_white = '#A5ADCB',
  bright_black = '#5B6078',
}

function M.vi_mode()
  return {
    init = function(self)
      self.mode = vim.fn.mode(1)
    end,
    surround = {
      separator = 'right',
    },
    static = {
      mode_names = M.mode_names,
      mode_colors = M.mode_colors,
    },
    provider = function(self)
      return ' %2(' .. self.mode_names[self.mode] .. ' ' .. '%)'
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode], bold = true }
    end,
    update = {
      'ModeChanged',
      pattern = '*:*',
      callback = vim.schedule_wrap(function()
        vim.cmd 'redrawstatus'
      end),
    },
  }
end

function M.lsp_clients(conditions)
  return {
    hl = { fg = 'green', bold = true },
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach', 'BufEnter', 'BufWritePost' },
    init = function(self)
      local names = {}
      for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
        names[#names + 1] = client.name
      end
      table.sort(names)
      self._txt = table.concat(names, ', ')
    end,
    provider = function(self)
      if not self._txt or self._txt == '' then
        return ''
      end
      return '  ' .. self._txt
    end,
    on_click = {
      name = 'heirline_lsp_clients',
      callback = function()
        vim.schedule(function()
          if vim.fn.exists ':LspInfo' == 2 then
            vim.cmd 'LspInfo'
          else
            vim.cmd 'checkhealth vim.lsp'
          end
        end)
      end,
    },
  }
end

function M.work_dir(conditions)
  return {
    condition = function()
      return not conditions.buffer_matches({
        buftype = { 'nofile', 'prompt', 'terminal', 'quickfix' },
        filetype = {
          'help',
          'lazy',
          'mason',
          'TelescopePrompt',
          'TelescopeResults',
          'neo%-tree',
          'NvimTree',
          'qf',
          'checkhealth',
        },
      }, 0)
    end,
    {
      provider = function()
        return ' '
      end,
      hl = function()
        if vim.fn.haslocaldir(0) == 1 then
          return { fg = 'cyan', italic = true }
        end
        return { fg = 'blue', italic = false }
      end,
    },
    {
      provider = function()
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        return cwd .. ' '
      end,
      hl = { fg = 'blue', italic = true },
    },
  }
end

function M.help_file_name()
  return {
    condition = function()
      return vim.bo.filetype == 'help'
    end,
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ':t')
    end,
    hl = { fg = 'blue' },
  }
end

function M.venv_component()
  local function python_env_name()
    local env = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if not env or env == '' then
      return nil
    end
    env = env:gsub('[/\\]+$', '')
    return env:match('([^/\\]+)$') or env
  end

  return {
    hl = { fg = 'yellow', bold = true },
    condition = function()
      return python_env_name() ~= nil
    end,
    provider = function()
      return '  ' .. ' ' .. python_env_name()
    end,
    on_click = {
      name = 'heirline_venv_selector',
      callback = function()
        vim.schedule(vim.cmd.VenvSelect)
      end,
    },
  }
end

return M
