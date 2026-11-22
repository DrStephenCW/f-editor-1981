with defs; use defs;

package par is
    --. F editor - Parameter Parsing 

	function readparam return comtype;

	function paramode return comtype;

end par;

with defs; use defs;
with text_io; use text_io;
with trans;
with low;
with disp;
with intrin;
with term;
with high;

package body par is

	procedure badparam(s: in string) is
	begin
	    low.bottom;
	    put("Illegal paramater: ");
	    put(s);
	    low.unbottom;
	    ci := saveci;
	    cj := savecj;
	    disp.display(ci, ci, cj);
	    low.resetc;
	end badparam;

	procedure readint(p: in string; 
			  notnum: out boolean;
			  the_num : out integer) is
	    param : string(1..p'length) := p;
	    num: integer;
	    sflag: boolean;
	    pix: integer;
	begin
	    notnum := true;
	    sflag := false;
	    num := 0;
	    pix := 1;
	    if intrin.strlen(param) >= 1 then
		if intrin.strlen(param) >= 2 then
		    if param(1) = '-' then
			sflag := true;
			pix := 2;
		    end if;
		    for i in pix..param'length loop
			if 
			    param(i) in '0'..'9' then
			    num := (num * 10) + 
				   character'pos(low.chrsub(param(i),'0'));
			else
			    the_num := 0; return;
			end if;
		    end loop;
		end if;
		notnum := false;
	    end if;
	    if sflag then  num := - num;  end if;
	    the_num := num;
	end readint;

	function readparam return comtype is
	    ch: character;
	    cm: boolean;               -- cursor movement seen 
	    cs: boolean;               -- argument is text 
	    done: boolean;             -- command seen; stop reading
				       --- param 
	    command: comtype;
	    pix: integer;
	begin
	    pix := 1;                  -- init parameter value to
				       --- none 
	    param(pix) := nul;
	    done := false;             -- no movement seen of either
				       --- kind 
	    cm := false;
	    cs := false;
	    while not done loop
		ch := term.dtyi;     -- get next parameter
				       --- character 
				       -- end while 
		command := trans.translate(ch);  -- convert to symbol 
		if command = comesc or else 
		   command = comchar or else 
		   command = comlf or else 
		   command = comup or else 
		   command = combk or else 
		   command = comrtn or else 
		   command = comrt or else 
		   command = comtab then
		    if 
			(cm and then 
			  command = 
			      comchar) or else 
			(cs and then 
			      not 
				  (command = 
					comchar)) or else 
			command = combk then
			badparam(
			    "mixed parameter modes");
			return comnull;
		    end if;
		    case command is    -- end switch 
		    when comchar =>
			low.foutchar(ch);
			pix := pix + 1;
			param(pix) := ch;
			cs := true;
		    when comesc =>
			low.foutchar('*');
			cm := true;
		    when comlf =>
			low.linefeed;
			cm := true;
		    when combk =>
			if cs then
			    term.dtyo(backspace);
			    term.dtyo(' ');
			    term.dtyo(backspace);
			    if pix > 0 then
				pix := pix - 1;
				param(pix) := nul;
			    end if;
			else
			    cm := true;  low.curslf;
			end if;
		    when comrtn =>
			low.carrtn;
			cm := true;
		    when comup =>
			low.cursup;
			cm := true;
		    when comrt =>
			low.cursrt;
			cm := true;
		    when comtab =>
			low.ftab;
			cm := true;
		    when others => done := true;
		    end case;
		else
		    done := true;
		end if;
	    end loop;
	    param(pix) := nul;
	    return command;
        end readparam;

	procedure cvt(lines, spaces: out integer; 
		      wantlines: in boolean;
		      wasnum: out boolean) is
	    nogood: boolean;  result: integer;
	begin
	    spaces := 0;
	    lines := 0;
	    readint(param, nogood, result);
	    wasnum := not nogood;
	    if nogood then
		lines := ci - saveci;
		if lines = 0 then
		    spaces := cj - savecj;
		else
		    spaces := cj;
		end if;
	    elsif  wantlines  then
		lines := result;
	    else
		spaces := result;
	    end if;
	end cvt;

	procedure setparam(command: in comtype) is

	    wom: integer;
	    i: integer;
	    wasnum: boolean;
	begin
	    case command is
	    when cominspac | comdelspac =>
		cvt(wom, defspace, false, wasnum);
		if defspace <= 0 or else 
		   wom /= 0 then
		    defspace := 1;
		    badparam(
			"insert/delete spaces");
		end if;
	    when complulines | comminlines =>
		cvt(defpluslines, wom, true, 
		    wasnum);
		if defpluslines <= 0 then
		    defpluslines := 1;
		    badparam("plus/minus lines");
		end if;
	    when comfser | combser =>
		if param(1) /= nul then
		    defsearch := param(1..80);	-- fix this
		else
		    low.ferr(
			"No search string specified");
		end if;
	    when cominslines | comdelines =>
		cvt(deflines, defsxl, true, 
		    wasnum);
		if deflines < 0 or defsxl < 0 then
		    deflines := 1;
		    badparam(
			"insert/delete spaces");
		end if;
	    when compick =>
		cvt(defpick, defsxp, true, 
		    wasnum);
		lastpick := defpick;   -- bug fix (see globals.h) 
		if defpick < 0 or defsxp < 0 then
		    defpick := 1;
		    badparam("pick up lines");
		end if;
		low.resetc;
		disp.display(ci, ci, cj);
	    when comput =>
		if param(1) = nul then
		    low.ferr(
			"Can't put empty string");
		else
		    for i in 0..intrin.strlen(param) - 1 
			loop
			putbuf(i + 1) := param(i);
		    end loop;
		    defpick := 0;
		    lastpick := defpick;  -- bug fix (see globals.h) 
		    defsxp := intrin.strlen(param);
		    putbufindex := defsxp;
		end if;
	    when combkpage | comforpage =>
		cvt(defpages, wom, true, wasnum);
		if defpages <= 0 or else 
		   not wasnum then
		    defpages := 1;
		    badparam("plus/minus pages");
		end if;
	    when comeol =>
		badparam(
		    "eol parameter is always 1");
	    when comredraw =>
		badparam("redraw doesn't take an argument");
	    when comsetfil =>
		newfile := param;
	    when cominterrupt =>
		-- return cominterrupt;
		null;
	    when combreak | comunbreak | comsic | 
		    comsdc | comsil | comsdl | 
		 comrdwline =>
			null;
	    when others =>  null;
	    end case;
	end setparam;

	function paramode return comtype is
	    command: comtype;
	begin
	    saveci := ci;              -- save current cursor
				       --- position 
	    savecj := cj;
	    enters := true;            -- the arg key was pressed 
	    low.foutchar('*');
	    command := readparam;    -- "parse" a command 
	    if command = cominterrupt then
		ci := saveci;          -- command was aborted 
		cj := savecj;          -- restore cursor position 
		low.resetc;
		disp.display(ci, ci, cj);
		enters := false;       -- pretend param mode never
				       --- entered 
		return comnull;
	    end if;
	    setparam(command);
	    ci := saveci;              -- command expects 
	    cj := savecj;
	    return command;
	end paramode;

end par;
