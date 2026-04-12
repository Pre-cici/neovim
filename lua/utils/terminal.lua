local M = {}
local window_directions = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
}

local function snacks_terminal_cmdline(buf)
  local terminal = vim.b[buf].snacks_terminal
  local cmd = type(terminal) == "table" and terminal.cmd or nil

  if type(cmd) == "string" then
    return cmd
  end

  if type(cmd) == "table" then
    return table.concat(cmd, " ")
  end

  return nil
end

function M.tmux_available()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

function M.navigate_window(direction)
  if M.tmux_available() then
    vim.cmd("TmuxNavigate" .. direction)
  else
    vim.cmd("wincmd " .. window_directions[direction])
  end
end

function M.navigate_from_terminal(direction)
  local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
  vim.schedule(function()
    M.navigate_window(direction)
  end)
end

function M.snacks_terminal_cmd_starts_with(buf, prefix)
  local cmdline = snacks_terminal_cmdline(buf)
  return type(cmdline) == "string" and cmdline:match("^" .. vim.pesc(prefix)) ~= nil
end

return M
