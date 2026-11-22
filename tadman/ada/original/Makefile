
OBJECTS = defs.o disp.o f.o high.o intrin.o low.o move.o par.o \
	call_csh.o fstacks.o \
	top.o typin.o term.o trans.o colorscan10.o

feditor:	$(OBJECTS)
	pac $(OBJECTS)

colorscan10.o:	colorscan10.ada
	mypac colorscan10

trans.o:	trans.ada defs.atr intrin.atr typin.atr
	mypac trans

term.o:	term.ada call_csh.atr defs.atr colorscan10.atr
	mypac term

f.o:	f.ada defs.atr fstacks.atr top.atr term.atr disp.atr low.atr
	pac f.ada

defs.o:	defs.ada
	mypac defs

call_csh.o:	call_csh.c call_csh.ada
	@echo "Something going on with call_csh; check it out"

disp.o: disp.ada defs.atr term.atr low.atr move.atr
	mypac disp

high.o:	high.ada defs.atr disp.atr term.atr low.atr move.atr intrin.atr \
		fstacks.atr
	mypac high

intrin.o: intrin.ada defs.atr 
	mypac intrin

low.o:	low.ada defs.atr term.atr move.atr intrin.atr
	mypac low

move.o:	move.ada defs.atr disp.atr intrin.atr low.atr
	mypac move

par.o:	par.ada defs.atr low.atr disp.atr intrin.atr term.atr high.atr
	mypac par

fstacks.o: fstacks.ada defs.atr low.atr move.atr top.atr intrin.atr
	mypac fstacks

top.o:	top.ada defs.atr intrin.atr typin.atr
	mypac top

typin.o: typin.ada defs.atr low.atr high.atr trans.atr par.atr disp.atr
	mypac typin



