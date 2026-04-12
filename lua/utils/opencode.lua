local M = {}

local tmux_pane_id

local function snacks_terminal_opts(width)
  return {
    win = {
      position = "right",
      width = width(),
      enter = false,
      on_win = function(win)
        require("opencode.terminal").setup(win.win)
      end,
    },
  }
end

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR, { title = "opencode" })
end

function M.tmux_available()
  return vim.env.TMUX ~= nil and vim.env.TMUX ~= ""
end

function M.open_builtin_terminal(cmd, width)
  require("snacks.terminal").open(cmd, snacks_terminal_opts(width))
end

function M.close_builtin_terminal(cmd, width)
  local terminal =
    require("snacks.terminal").get(cmd, vim.tbl_extend("force", snacks_terminal_opts(width), { create = false }))
  if terminal then
    terminal:close()
  end
end

function M.toggle_builtin_terminal(cmd, width)
  require("snacks.terminal").toggle(cmd, snacks_terminal_opts(width))
end

function M.tmux_pane_exists()
  if not tmux_pane_id then
    return false
  end

  local result = vim
    .system({ "tmux", "list-panes", "-a", "-F", "#{pane_id}" }, {
      text = true,
    })
    :wait()
  if result.code ~= 0 then
    tmux_pane_id = nil
    return false
  end

  for _, pane_id in ipairs(vim.split(result.stdout or "", "\n", { trimempty = true })) do
    if pane_id == tmux_pane_id then
      return true
    end
  end

  tmux_pane_id = nil
  return false
end

function M.open_tmux_pane(cmd)
  if M.tmux_pane_exists() then
    return
  end

  local result = vim
    .system({
      "tmux",
      "split-window",
      "-h",
      "-d",
      "-P",
      "-F",
      "#{pane_id}",
      "-p",
      "35",
      cmd,
    }, { text = true })
    :wait()

  if result.code ~= 0 then
    notify_error(result.stderr ~= "" and result.stderr or "Failed to open tmux pane for opencode")
    return
  end

  tmux_pane_id = vim.trim(result.stdout or "")
end

function M.close_tmux_pane()
  if not M.tmux_pane_exists() then
    return
  end

  vim.system({ "tmux", "kill-pane", "-t", tmux_pane_id }, { text = true }):wait()
  tmux_pane_id = nil
end

function M.toggle_tmux_zoom()
  local result = vim.system({ "tmux", "resize-pane", "-Z" }, { text = true }):wait()
  if result.code ~= 0 then
    notify_error(result.stderr ~= "" and result.stderr or "Failed to toggle tmux zoom for opencode")
  end
end

function M.toggle_tmux_pane(cmd)
  if M.tmux_pane_exists() then
    M.toggle_tmux_zoom()
  else
    M.open_tmux_pane(cmd)
  end
end

function M.server_opts(cmd, width)
  return {
    start = function()
      if M.tmux_available() then
        M.open_tmux_pane(cmd)
      else
        M.open_builtin_terminal(cmd, width)
      end
    end,
    stop = function()
      if M.tmux_available() then
        M.close_tmux_pane()
      else
        M.close_builtin_terminal(cmd, width)
      end
    end,
    toggle = function()
      if M.tmux_available() then
        M.toggle_tmux_pane(cmd)
      else
        M.toggle_builtin_terminal(cmd, width)
      end
    end,
  }
end

return M
