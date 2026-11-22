with text_io; use text_io;
package disp is
	procedure display(start, linef, col: in integer);
end disp;

with text_io; use text_io;
with defs; use defs;
with term;
with low;
with move;

package body disp is

procedure display(
	start, linef, col: in integer) is
    rindex: integer;
    ch: character;
    curcol: integer;
    crcount: integer;
    lmargin: integer;
    cstart: integer := start;
    spacecount: integer;
begin
    term.curpos(start, col);
    fi := low.max(fi, 0);
    move.tpos(fi + start, 0);
    rindex := rightindex;
    crcount := 0;
    curcol := - 1;
    term.clearline;
    lmargin := col;
    spacecount := 0;
    while (rindex <= textbufsize) and then 
	  (crcount <= linef - start) loop
	ch := textbuf(rindex);
	curcol := curcol + 1;
	if ch = cr then
	    crcount := crcount + 1;
	    if curcol < width then
		term.clearline;
	    end if;
	    curcol := - 1;
	    lmargin := tj;
	    cstart := cstart + 1;
	    term.curpos(cstart, 0);
	    ch := nul;
	    spacecount := 0;
	elsif  (ch < ' ')  then        -- highest control char 
	    term.dtyo(esc);
	end if;
	if curcol - fj >= lmargin and then 
	   curcol - fj < width and then 
	   ch /= nul then
	    if (ch = ' ') then
		spacecount := spacecount + 1;
		if (spacecount < 4) then
		    while spacecount > 0 loop
			term.dtyo(' ');
			spacecount := spacecount + 
				      1;
		    end loop;
		else
		    term.clearline;
		    term.curpos(cstart, curcol);
		end if;
		term.dtyo(ch);
		spacecount := 0;
	    end if;
	    rindex := rindex + 1;
	end if;
	eofdis := rindex > textbufsize;
	if eofdis then  term.cleareop;  end if;
	low.resetc;
    end loop;
end display;

end disp;