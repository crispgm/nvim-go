local M = {}

function M.show_success(prefix)
    print(string.format('[%s] Success', prefix))
end

function M.show_error(prefix, j, return_val)
    print(string.format('[%s] Error: %d', prefix, return_val))
    local results = j:result()
    for _, v in ipairs(results) do
        print(v)
    end
end

return M
