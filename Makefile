init:
	luarocks install luacheck

lint:
	luacheck lua/go
