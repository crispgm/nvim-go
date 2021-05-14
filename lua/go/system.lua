local M = {}

function M.wrap_file_command(cmd, args, file_path)
    local command = { cmd }
    if #args > 0 then
        for _, arg in ipairs(args) do
            table.insert(command, arg)
        end
    end
    table.insert(command, file_path)
    return command
end

return M
