local go = require('go')
local config = require('go.config')

describe('setup', function()
    it('shoule init with default', function()
        go.setup{}
        assert.are.same('golint', config.options.linter)
    end)

    it('should setup with customized value', function()
        go.setup{
            linter = 'test_linter',
        }
        assert.are.same('test_linter', config.options.linter)
    end)
end)
