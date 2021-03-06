test:
	nvim --headless --noplugin -u scripts/minimal_init.vim -c "PlenaryBustedDirectory lua/tests/specs/ { minimal_init = './scripts/minimal_init.vim' }"

init:
	luarocks install luacheck

lint:
	luacheck lua/go
