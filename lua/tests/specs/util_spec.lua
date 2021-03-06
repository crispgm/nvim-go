local util = require('go.util')

describe('binary_exists', function()
    it('should not exist', function()
        local is = util.binary_exists('a1b1')
        assert.are.same(false, is)
    end)

    it('should exist', function()
        local is = util.binary_exists('ls')
        assert.are.same(true, is)
    end)
end)
