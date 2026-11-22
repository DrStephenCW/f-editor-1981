
with defs; use defs;
with text_io; use text_io;
with disp; use disp;
with term;
with low;
with move;
with intrin;
with fstacks;

package body high is

	procedure fcrlf is             -- print carriage return and
				       --- line feed 
	begin
	    put(cr);  put(lf);
	end fcrlf;

	procedure srevscroll is        -- smart minus 1 line 
	begin
	    low.sync;
	    if fi <= 0 then            -- no place to go 
		return;
	    end if;
	    term.curpos(0, 0);
	    term.termil;
	    fi := fi - 1;              -- move screen back a line 
	    fi := low.max(0, fi);
	    ci := ci + 1;
	    if (ci > height) then  
		term.mvhome;  
	    end if;
	    display(0, 0, 0);
	end srevscroll;

	procedure deletespaces is      -- remove characters from
				       --- editing buffer 
	    ch: character;  count: integer;
	begin
	    low.sync;
	    if defspace > 0 then
		count := defspace;
		ch := low.popright;
		count := count - 1;
		while ch /= cr and then 
		      ch /= nul and then 
		      count >= 0 loop
		    ch := low.popright;
		    count := count - 1;
		end loop;
		low.pushright(ch);
	    end if;
	    display(ci, ci, cj);
	end deletespaces;

	procedure deletelines is       -- delete lines and spaces 
	begin
	    low.sync;
	    defpick := deflines;
	    defsxp := defsxl;
	    move.pick(deflines, defsxl + fj, false);
	    if deflines /= 0 then
		display(ci, height, cj);
	    else
		display(ci, ci, cj);
	    end if;
	end deletelines;

	procedure addlines is          -- inserts carriage returns 
	    i: integer;                -- plus spaces 
	begin
	    low.sync;
	    for i in 0..defsxl + fj - 1 loop
		low.pushright(' ');
	    end loop;
	    for i in 0..deflines - 1 loop
		low.pushright(cr);
	    end loop;
	    if deflines /= 0 then
		display(ci, height, cj);
	    else
		display(ci, ci, cj);
	    end if;
	end addlines;

	procedure addspace is          -- insert blanks into editing
				       --- buffer 
	    i: integer;
	begin
	    low.sync;
	    for i in 1..defspace loop
		low.pushright(' ');
	    end loop;
	    display(ci, ci, cj);
	end addspace;

	procedure fputchar(ch: in character) is
	    peek: character;           -- put character into editing
				       --- buffer 
	    noise : character;
	begin
	    low.sync;
	    tj := tj + 1;
	    low.pushleft(ch);
	    peek := low.peekright;   -- overwrite current char
				       --- unless cr or nul 
	    if peek /= nul and then 
	       peek /= cr then
		noise := low.popright;
	    end if;
	end fputchar;

	procedure inscr is             -- insert a carriage return
				       --- into the file 
	begin
	    low.sync;
	    low.pushright(cr);
	    term.clearline;
	    if ci = height then        -- done in this case 
		return;
	    end if;
	    term.curpos(ci + 1, cj);
	    term.termil;
	    display(ci + 1, ci + 1, 0);
	end inscr;

	procedure rmvcr is
	    peek: character;
	begin
	    low.sync;
	    move.pick(1, 0, false);
	    term.clearline;
	    if ci /= height then
		term.curpos(ci + 1, 0);
		term.termdl;
	    end if;
	    display(ci, ci, cj);
	    display(height, height, 0);
	end rmvcr;

	procedure sic is               -- smart insert blank into
				       --- editing buffer 
	begin
	    low.sync;
	    term.termic;
	    low.pushright(' ');
	    low.resetc;
	end sic;

	procedure renamefile is
	begin
	    if param(1) = nul then
		low.ferr(
		    "No file specified for rename");
	    end if;
	    curfile := param;
	    if enters then
		display(ci, ci, cj);
	    end if;
	    low.fmsg;
	end renamefile;

	procedure setfile is
		noise : boolean;
	begin
	    if not fstacks.writefile then
		return;
	    end if;
	    if newfile = curfile then
		newfile := lastfile;
	    end if;
	    noise := fstacks.readfile;
	    changed := false;
	    display(0, height, 0);
	    low.fmsg;
	end setfile;

	procedure sil is               -- smart insert line 
	begin
	    cj := 0;                   -- doesn't break lines 
	    low.sync;
	    low.pushright(cr);
	    if deflines + ci > height then
		term.clearpage;
	    end if;
	    term.termil;
	end sil;

	procedure searchbackward is
	    lindex: integer;           -- local copy of leftindex  
	    sti, stj: integer;         -- local copies of ti and tj 
	    size: integer;             -- size of search parameter 
	    found: boolean;
	    ok: boolean;
	    firstch: character;
	    ch: character;
	    i: integer;
	begin
	    if defsearch(1) = nul then
		low.ferr("No search string");
		if enters then
		    display(ci, ci, cj);
		else
		    low.resetc;
		end if;
		return;
	    end if;
	    low.bottom;
	    put("-Search '");
	    put(defsearch);
	    put(''');
	    low.unbottom;
	    low.sync;
	    size := intrin.strlen(defsearch);
	    for i in 1..size loop
		defsearch(i) := 
		    low.lower(defsearch(i));
	    end loop;
	    firstch := defsearch(1);
	    lindex := leftindex;       -- might miss first occurance 
	    sti := ti - 1;
	    stj := 0;                  -- number of characters from
				       --- end of line 
	    found := false;
	    while lindex >= 1 and then 
		  not found loop
		ch := low.lower(textbuf(lindex));
		if ch = cr then
		    sti := sti - 1;  stj := 0;
		else
		    stj := stj - 1;
		end if;
		if ch = firstch then
		    ok := true;
		    for i in 1..size - 1 loop
			ok := defsearch(i) = 
			      low.lower(textbuf(lindex + i)) and ok;
		    end loop;
		    found := ok;
		end if;
		if not found then
		    lindex := lindex - 1;
		end if;
	    end loop;
	    if found then
		put(" *Found*");
		move.fixcursor(sti, 0);
	    else
		put(" *Failed*");
		if enters then
		    display(ci, ci, cj);
		else
		    low.resetc;
		end if;
	    end if;
	end searchbackward;

	procedure sdl is               -- delete lines 
	begin
	    cj := 0;
	    low.sync;
	    defpick := 1;
	    move.pick(1, 0, false);
	    term.termdl;
	    display(height, height, 0);
	end sdl;

	procedure putback is           -- restore put buffer 
	begin
	    low.sync;
	    move.fput;
	    if lastpick > 0 then
		display(ci, height, cj);
	    else
		display(ci, ci, cj);
	    end if;
	end putback;

	procedure pickup is            -- put text into put buffer 
	begin
	    low.sync;
	    move.pick(defpick, defsxp, true);
	    if enters then
		display(ci, ci, cj);
	    else
		low.resetc;
	    end if;
	end pickup;

	procedure pluspages is         -- move window forward by
				       --- screenfuls 
	begin
	    low.sync;
	    fi := fi + defpages * (height + 1);
	    display(0, height, 0);
	end pluspages;

	procedure knockdown is         -- take next character
				       --- literally 
	    ch: character;
	begin
	    low.sync;
	    ch := term.dtyi;
	    fputchar(ch);
	    low.foutchar(ch);
	end knockdown;

	procedure backpages is         -- move window backwards by
				       --- screenfuls 
	begin
	    low.sync;
	    fi := fi - defpages * (height + 1);
	    fi := low.max(fi, 0);
	    display(0, height, 0);
	end backpages;

	procedure minuslines is        -- move window backwards by
				       --- lines 
	begin
	    low.sync;
	    fi := fi - defpluslines;
	    if fi < 0 then             -- stop at beginning of file 
		fi := 0;  ci := 0;
	    else
		ci := ci + defpluslines;
		if ci > height then    -- put cursor home if 
				       -- screen 
		    ci := 0;           -- it wanted to move 
		    cj := 0;           -- off the top of the 
		end if;
	    end if;
	    display(0, height, 0);
	end minuslines;

	procedure gotoend is           -- skip lines to end of buffer
				       --- 
	begin
	    low.sync;
	    while move.downline loop
		fi := fi + 1;  ti := ti + 1;
	    end loop;
	    minuslines;
	end gotoend;

	procedure searchforward is     -- search for text 
	    rindex: integer;           -- copy of rightindex 
	    sti, stj: integer;         -- copies of ti and tj 
	    size: integer;             -- size of search string 
	    found: boolean;
	    ok: boolean;
	    firstch: character;        -- first char of text to
				       --- search for 
	    ch: character;             -- current char in buffer
				       --- being tested 
	    i: integer;                -- random loop control 
	begin
	    if defsearch(1) = nul then
		low.ferr("No search string");
		if enters then
		    display(ci, ci, cj);
		else
		    low.resetc;
		end if;
		return;
	    end if;
	    low.bottom;
	    put("+Search '");
	    put(defsearch);
	    put(''');
	    low.unbottom;
	    low.sync;
	    size := intrin.strlen(defsearch);  -- convert to lower case 
	    for i in 1..size loop
		defsearch(i) := 
		    low.lower(defsearch(i));
	    end loop;
	    firstch := defsearch(1);
	    if textbuf(rightindex) = cr then
		sti := ti;             -- current spot in file 
		stj := - 1;
	    else
		sti := ti - 1;  stj := tj;
	    end if;
	    rindex := rightindex + 1;  -- skip current character 
				       -- in case of repeated searches
				      --- 
	    found := false;
	    while rindex + size <= textbufsize and 
		  not found loop
		ch := low.lower(textbuf(rindex));
		if ch = cr then        -- count lines and spaces 
		    sti := sti + 1;  stj := - 1;
		else
		    stj := stj + 1;
		end if;
		if ch = firstch then   -- check for match 
		    ok := true;
		    for i in 1..size - 1 loop
			ok := defsearch(i) = 
			      low.lower(textbuf(rindex + i)) and 
			        ok;      -- ok remains true until 
		    end loop;
		    found := ok;       -- bad character 
		end if;
		if not found then      -- try from next char 
		    rindex := rindex + 1;
		end if;
	    end loop;
	    if found then
		put(" *Found*");
		move.fixcursor(sti, stj);
	    else
		put(" *Failed*");
		if enters then
		    display(ci, ci, cj);
		else
		    low.resetc;
		end if;
	    end if;
	end searchforward;

	procedure sdc is               -- smart remove character from
				       --- editing buffer 
	    ch: character;
	begin
	    low.sync;
	    ch := low.popright;      -- remove character 
	    if ch = cr or ch = nul then  -- never past end of buffer
					 --- or line 
		low.pushright(ch);
	    end if;
	    term.termdc;
	end sdc;

	procedure pluslines is         -- move window forward by
				       --- lines 
	    i: integer;
	begin
	    low.sync;
	    fi := fi + defpluslines;
	    if defpluslines >= height then
		display(0, height, 0);
	    else
		term.termscroll(defpluslines);
		if not eofdis then
		    display(
			height - defpluslines + 1, 
			height, 0);
		end if;
		ci := ci - defpluslines;
		if ci < 0 then
		    term.mvhome;
		elsif  enters  then
		    display(ci, ci, cj);
		else
		    low.resetc;
		end if;
	    end if;
	end pluslines;

	procedure redraw is
	begin
	    term.clearpage;
	    display(0, height, 0);
	    low.fmsg;
	end redraw;

	procedure eolplease is         -- only goes to end of current
				       --- line 
	    ch: character;
	    count: integer;            -- number of characters
				       --- skipped over 
	begin
	    low.sync;
	    count := - 1;
	    if rightindex > textbufsize then
		return;
	    end if;
	    count := count + 1;
	    ch := textbuf(rightindex + count);
	    while ch /= cr and then 
		  rightindex + count + 1 <= 
		    textbufsize loop
		count := count + 1;
		ch := textbuf(rightindex + count);
	    end loop;
	    cj := low.min(width, cj + count);  -- don't move screen 
	    low.resetc;
	end eolplease;

	procedure gotostart is
	--. goes to beginning of file ignoring ti and tj 
	--. this is to make ti and tj match the stacks 
	--. this extra work shouldn't really be necessary 
	begin
	    while move.upline loop
		null;                  -- move everything to 
				       -- right stacks 
	    end loop;
	    fi := 0;                   -- reset file pointers
	    fj := 0;
	    ti := 0;
	    tj := 0;
	    ci := 0;
	    cj := 0;
	    display(0, height, 0);
	end gotostart;

	procedure fexit is
	begin
	    if not fstacks.writefile then
		return;
	    end if;
	    term.endterm;
	    cleanup;
	    raise bye_bye;
	end fexit;

	procedure cleanup is           -- belongs in low.c 
	begin
	    low.bottom;
	    term.clearline;
	    term.curpos(23, 0);
	    term.clearline;
	end cleanup;

	procedure interruptexit is
	    ch: character;
	begin
	    low.bottom;
	    put(
		"Type a q or a Q to exit; anything else to resume editing.");
	    ch := term.dtyi;
	    if ch = 'q' or else ch = 'Q' then
		cleanup;  term.endterm;  raise bye_bye;
	    end if;
	    low.fmsg;
	end interruptexit;

end high;
