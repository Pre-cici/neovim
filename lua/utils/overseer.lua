local M = {}

function M.default_components()
  return {
    -- 'display_duration',
    'on_exit_set_status',
    { 'on_output_quickfix', open_on_exit = 'failure' },
    'on_complete_notify',
  }
end

function M.run(task)
  require('overseer').new_task(task):start()
end

return M
