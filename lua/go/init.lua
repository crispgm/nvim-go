local go = setmetatable({}, {
  __index = function(t, k)
    if k == 'setup' then return setup end

    local ok, val = pcall(require, string.format('go.%s', k))
    if ok then
      rawset(t, k, val)
    end

    return val
  end
})

local vim = vim
local config = require('go.config')
function setup(opt)
    config.options = vim.tbl_extend('force', config.options, opt)
end

return go
