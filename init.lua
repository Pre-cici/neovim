require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'config.lsp'

require 'plugins'

require('vim._extui').enable {
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 40000, -- Time a message is visible in the message window.
  },
}
