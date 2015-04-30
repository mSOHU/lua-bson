LUALIB=-I/usr/local/include/luajit-2.0 -L/usr/local/bin -lluajit-5.1
LUA_INCLUDE=-I/usr/local/include/luajit-2.0
SOCKETLIB=-lws2_32

LUA_VERSION = 5.1

PREFIX ?=          /usr/local
INSTALL ?= install
LUA_CMODULE_DIR =   $(PREFIX)/lib/lua/$(LUA_VERSION)

.PHONY: all win linux

all : 
	@echo Please do \'make PLATFORM\' where PLATFORM is one of these:
	@echo win linux

win: bson.dll

linux: lbitlib.a bson.so
	$(INSTALL) bson.so /usr/local/lib/lua/5.1/

bson.dll : bson.c
	gcc --shared -Wall -O2 $^ -o$@ $(LUALIB) $(SOCKETLIB)

lbitlib.a : 
	gcc -c -Wall -fPIC -Ilua-compat-5.2/c-api -O2 lua-compat-5.2/lbitlib.c -o$@ $(LUA_INCLUDE)
bson.so : bson.c
	gcc --shared -Wall -fPIC -Ilua-compat-5.2/c-api -O2 $^ lbitlib.a -o$@ $(LUALIB)

clean:
	rm -f bson.dll bson.so *.a
