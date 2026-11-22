
objects = display.o f.o high.o intrin.o low.o move.o param.o shell.o stacks.o \
	top.o typein.o term.o trans.o

nf: $(objects)
	cc $(objects) -o nf

term.o:	term.c globals.h
	cc -c term.c

trans.o: trans.c globals.h
	cc -c trans.c

display.o: display.c globals.h
	cc -c display.c

f.o:	f.c globals.h
	cc -c f.c

high.o:	high.c globals.h
	cc -c high.c

intrin.o: globals.h intrin.c
	cc -c intrin.c

low.o:	low.c globals.h
	cc -c low.c

move.o:	move.c globals.h
	cc -c move.c

param.o: param.c globals.h
	cc -c param.c

shell.o: shell.c globals.h
	cc -c shell.c

stacks.o: stacks.c globals.h
	cc -c stacks.c

top.o:	top.c globals.h
	cc -c top.c

typein.o: typein.c globals.h
	cc -c typein.c



