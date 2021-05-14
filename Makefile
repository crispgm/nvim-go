.PHONY: lint test vader

init:
	luarocks install luacheck

lint:
	luacheck lua/go

format:
	stylua lua/ --config-path ./.stylua.toml

test:
	nvim --headless --noplugin -u scripts/minimal_init.vim -c "PlenaryBustedDirectory lua/tests/specs/ { minimal_init = './scripts/minimal_init.vim' }"

vader:
	nvim --headless --noplugin -u scripts/minimal_init.vim ./test/vader.vader -c "Vader!"
