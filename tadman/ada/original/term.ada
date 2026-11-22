with call_csh;

package term is
    --. F editor - terminal handler 

	function dtyi return character;  -- assumes raw mode 

	procedure dtyo(ch: in character);  -- assumes raw mode 

	procedure initterm;

	procedure endterm;

	procedure clearline;

	procedure cleareop;

	procedure curpos(r, c: in integer);

	procedure clearpage;

	procedure mvhome;

	procedure termil;

	procedure termdl;

	procedure termic;

	procedure termdc;

	procedure termscroll(n: in integer);  

end term;

with text_io; use text_io;
with defs; use defs;
with colorscan10; use colorscan10;

package body term is

	function dtyi return character is  -- assumes raw mode 
	    ch: character;
	begin
	    get(ch);
            ch := character'val(character'pos(ch) mod 8#177#);  -- remove parity
	    return ch;
	end dtyi;

	procedure dtyo(ch: in character) is  -- assumes raw mode 
	begin
	    put(ch);
	end dtyo;

	procedure initterm is
	begin
	    call_csh.csh("stty -echo cbreak");
	    if slow /= 0 then
		height := slow - 1;
	    else
		height := LINES - 1;
	    end if;
	    width := COLS - 1;
	    scrolling_region(1,23);
	end initterm;

	procedure endterm is
	begin
		scrolling_region(1,24);
		call_csh.csh("stty echo cooked");
	end endterm;

	--. for use with colorscan10
	procedure clearline is
	begin
		erase_line(to_end);
	end clearline;

	procedure cleareop is
	begin
		erase_display(to_end);
	end cleareop;

	procedure curpos(r, c: in integer) is
	begin
		set_cursor(r + 1, c + 1);
	end curpos;

	procedure mvhome is
	begin
		cursor_home;
	end mvhome;

	procedure clearpage is
	begin
		mvhome; cleareop;
	end clearpage;

	procedure termil is
	begin
		null;
	end termil;

	procedure termdl is
	begin
		null;
	end termdl;

	procedure termic is
	begin
		null;
	end termic;

	procedure termdc is
	begin
		null;
	end termdc;

	procedure termscroll(n: in integer) is
	begin
	    curpos(22, 0);
	    for i in 1..n loop
		dtyo(lf);
	    end loop;
	end termscroll;

end term;
