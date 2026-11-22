with defs; use defs;

package top is
    --. F editor - top level control 

	procedure defargs;             -- define default arguments 
	procedure finit;

	procedure emptystacks;

	procedure chprocess(ch: in character);

    end top;

    with defs; use defs;
    with intrin;
    with typin;

    package body top is

	procedure defargs is           -- define default arguments 
	begin
	    defspace := 1;             -- this was done to imitate
				       --- the 
	    deflines := 1;             -- way the Z editor works 
	    defsxl := 0;               -- This is called after every
				       --- command 
	    defpages := 1;
	    defpluslines := height / 2;
	    defslide := 40;
	    defpick := 1;
	    defsxp := 0;
	    defsxl := 0;
	end defargs;

	procedure finit is
	begin
	    defargs;
	    enters := false;           -- nobody could have entered a
				       --- parameter 
	    lastpick := 1;             -- bug fix (see globals.h) 
	    intrin.null_string(defsearch);
	    eofdis := false;           -- not at end of file 
	    putbufindex := 0;          -- nothing in put buffer 
	    emptystacks;
	    intrin.null_string(lastfile);        -- don't know name of last
				       --- file 
	end finit;

	procedure emptystacks is
	begin
	    ti := 0;                   -- start at beginning of file 
	    tj := 0;
	    fi := 0;
	    fj := 0;
	    ci := 0;
	    cj := 0;
	    leftindex := 0;
	    rightindex := textbufsize + 1;
	end emptystacks;

	procedure chprocess(ch: in character) is
	begin
	    defargs;
	    enters := false;           -- param not entered (yet) 
	    typin.typein(ch);
	end chprocess;


end top;
