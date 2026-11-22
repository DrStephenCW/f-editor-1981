# Builds nf, the F editor, from the untouched 1981-84 sources in original/.
# The only addition is compat/sgtty.h, which maps the 4.2BSD gtty/stty
# calls onto POSIX termios.  -fcommon is needed because globals.h defines
# (rather than declares) the editor's globals in every file, which the
# 1984 linker merged and modern gcc refuses to by default.
CC      = gcc
CFLAGS  = -std=gnu89 -fcommon -w -O -Icompat -Ioriginal
SRCS    = display f high intrin low move param shell stacks top typein term trans
OBJS    = $(SRCS:%=build/%.o)

nf: $(OBJS)
	$(CC) $(OBJS) -o nf

build/%.o: original/%.c original/globals.h compat/sgtty.h
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

ada-f:
	cd tadman/ada/src && gnatmake -gnat95 -q -D ../../../build f.adb -o ../../../ada-f

clean:
	rm -rf build nf ada-f
.PHONY: clean ada-f
