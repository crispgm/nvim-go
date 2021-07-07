local import = require('go.import')

describe('package delimitation', function()
    it('should delimit double quotes', function()
        local pkg = '"fmt"'
        assert.are.same('fmt', import._test_delimit_pkg(pkg))
    end)

    it('should delimit slash', function()
        local pkg = 'github.com/crispgm/go-g/'
        assert.are.same(
            'github.com/crispgm/go-g',
            import._test_delimit_pkg(pkg)
        )
    end)
end)

describe('need go get', function()
    it('should go get', function()
        local pkg = 'github.com/crispgm/go-g'
        assert.are.same(true, import._test_need_go_get(pkg))
    end)

    it('should not go get', function()
        local pkg = 'fmt'
        assert.are.same(false, import._test_need_go_get(pkg))
    end)
end)
