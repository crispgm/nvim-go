local test = require('go.test')

describe('test utilities', function()
    it('should split file name', function()
        require('go').setup({
            test_flags = { '-count=1' },
            test_timeout = '1s',
        })
        assert.are.same(
            { 'go', 'test', '-timeout=1s', '-count=1' },
            test._build_args({ 'go', 'test' })
        )
    end)

    it('should validate go source file', function()
        assert.are.same(0, test._valid_file('a.go'))
        assert.are.same(0, test._valid_file('a_a.go'))
        assert.are.same(0, test._valid_file('a1.go'))
        assert.are.same(1, test._valid_file('a_test.go'))
        assert.are.same(1, test._valid_file('a_a_test.go'))
        assert.are.same(1, test._valid_file('a1_test.go'))
        assert.are.same(-1, test._valid_file('a_test'))
        assert.are.same(-1, test._valid_file('a_a_test'))
        assert.are.same(-1, test._valid_file('a1_test'))
    end)

    it('should validate a test func name', function()
        assert.are.same(true, test._valid_func_name('TestAFunc'))
        assert.are.same(true, test._valid_func_name('Test'))
        assert.are.same(true, test._valid_func_name('ExampleFunc'))
        assert.are.same(true, test._valid_func_name('Example'))
        assert.are.same(false, test._valid_func_name(''))
        assert.are.same(false, test._valid_func_name('Func'))
    end)

    it('should split file name', function()
        assert.are.same(
            'FuncName',
            test._split_file_name('func FuncName() error')
        )
    end)
end)
