local M = {}

function M.scheduled_error(err)
  vim.schedule(function()
    vim.notify(err, vim.log.levels.ERROR)
  end)
end

function M.partial(func, ...)
  local _partial = function(f, x)
    return function(...)
      return f(x, ...)
    end
  end
  for i = 1, select("#", ...) do
    func = _partial(func, select(i, ...))
  end
  return func
end

return M
