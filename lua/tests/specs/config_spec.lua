local go = require('go')
local config = require('go.config')

describe('setup', function()
    it('should init with default', function()
        go.setup({})
        assert.are.same('revive', config.options.linter)
    end)

    it('should setup with customized value', function()
        go.setup({
            linter = 'test_linter',
        })
        assert.are.same('test_linter', config.options.linter)
    end)
end)

describe('tools', function()
    it('should get tool with given name', function()
        local qt = config.get_tool('quicktype')
        assert.are.same('quicktype', qt.name)
        assert.are.same('yarn', qt.pkg_mgr)
    end)

    it('should return nil if not found', function()
        local qt = config.get_tool('something')
        assert.are.same(nil, qt)
    end)

    it('should update tool with given name', function()
        local qt = config.get_tool('quicktype')
        assert.are.same('quicktype', qt.name)
        assert.are.same('yarn', qt.pkg_mgr)
        local ret = config.update_tool('quicktype', function(tool)
            tool.pkg_mgr = 'npm'
        end)
        assert.are.same(true, ret)
        local new_qt = config.get_tool('quicktype')
        assert.are.same('quicktype', new_qt.name)
        assert.are.same('npm', new_qt.pkg_mgr)
    end)

    it('should return false if not found', function()
        local ret = config.update_tool('something', function(_) end)
        assert.are.same(false, ret)
    end)
end)
