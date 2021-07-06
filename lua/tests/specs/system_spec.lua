local system = require('go.system')

describe('wrap_file_command', function()
    it('should wrap command with file and args', function()
        local command = system.wrap_file_command(
            'ls',
            { '-l' },
            '/path/to/file'
        )
        assert.are.same({ 'ls', '-l', '/path/to/file' }, command)
    end)

    it('should wrap command without args', function()
        local command = system.wrap_file_command('ls', {}, '/path/to/file')
        assert.are.same({ 'ls', '/path/to/file' }, command)
    end)
end)
