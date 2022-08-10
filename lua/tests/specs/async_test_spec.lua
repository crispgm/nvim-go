local test = require('go.async_test')

describe('async test utilities', function()
    it('should calc relative path to test file from working dir', function()
        assert.are.same("d/",
            test._calc_relative_path_to("a/b/c/d", "a/b/c"))
        assert.are.same("dd/",
            test._calc_relative_path_to("aa/bb/cc/dd", "aa/bc/cc"))
        assert.are.same("../",
            test._calc_relative_path_to("a/b/c", "a/b/c/d"))
        assert.are.same("../../../",
            test._calc_relative_path_to("a/b/c", "a/b/c/d/e/f"))
        assert.are.same("d/e/f/",
            test._calc_relative_path_to("a/b/c/d/e/f", "a/b/c"))
        assert.are.same("ddddd/eeeee/fffff/",
            test._calc_relative_path_to("aaaaa/bbbbb/ccccc/ddddd/eeeee/fffff",
                "aaaaa/bbbbb/ccccc"))
    end)

    it('should calc module root path above current dir', function()
        -- path below includes 'go.mod' file which's used  for module root
        -- detection

        assert.are.same("./test/fixtures/test/",
            test._module_root("./test/fixtures/test/test/test"))
        assert.are.same("./test/fixtures/test/",
            test._module_root("./test/fixtures/test/test/"))
        assert.are.same("./test/fixtures/test/",
            test._module_root("./test/fixtures/test"))

        local cwd = vim.fn.getcwd() -- to test root '/' calculation
        assert.are.same(cwd .. "/test/fixtures/test/",
            test._module_root(cwd .. "/test/fixtures/test/test/test"))
    end)
end)

describe('async test run', function()
    local run_pseudo_test = function(fn, count)
        local org_cwd = vim.fn.getcwd()
        vim.api.nvim_set_current_dir("./test/fixtures/test")
        local file = io.open(fn)
        assert(file, "must exist")
        local lines = file:lines()
        local trun = test._test_run()
        local fail_count = 0
        for line in lines do
            trun.parse_test_output_line(line, function(qfl)
                fail_count = fail_count + #qfl
            end)
        end
        vim.api.nvim_set_current_dir(org_cwd)
        assert.are.same(count, fail_count)
    end

    it('should find ZERO when all pass', function()
        run_pseudo_test("pass_test.json", 0)
    end)

    it('should find failed ones', function()
        run_pseudo_test("fail_test.json", 2)
    end)

    it('should find failed ones for sub tests as well', function()
        run_pseudo_test("fail_include_sub_tests.json", 6)
    end)

    it('should find failed ones from examples', function()
        -- 8 errors 4 info lines 1 caption
        run_pseudo_test("example-test-fail.json", 8*(4+1))
    end)
end)

