with text_io; use text_io;
with defs; use defs;
with term;
with move;
with intrin;

package low is
    --. F editor - level functions 

	function chradd(a,b : character) return character;

	function chrsub(a,b : character) return character;

	function lower(ch : in character) return character;

	function upper(ch: in character) 
	    return character;

	function nexttabstop(i: in integer) 
	    return integer;

	function max(x, y: in integer) 
	    return integer;

	function min(x, y: in integer) 
	    return integer;

	procedure pushleft(ch: in character);

	function popleft return character;

	procedure pushright(ch: in character);

	function popright return character;

	function peekleft return character;

	function peekright return character;

	function leftright return character;

	function rightleft return character;

	procedure bottom;

	procedure unbottom;

	procedure home;

	procedure resetc;

	procedure linefeed;

	procedure carrtn;

	procedure cursup;

	procedure cursrt;

	procedure curslf;

	procedure foutchar(ch: in character);

	procedure ftab;

	procedure fmsg;

	procedure ferr(s: in string);

	procedure sync;

end low;

with text_io; use text_io;
with defs; use defs;
with term;
with move;
with intrin;

package body low is

	function chradd(a,b : character) return character is begin
		return character'val(character'pos(a) + character'pos(b));
	end;

	function chrsub(a,b : character) return character is begin
		return character'val(character'pos(a) - character'pos(b));
	end;

	function lower(ch: in character) 
	    return character is
	begin
	    if ch in 'A'..'Z' then
		return
		character'val(
		  character'pos(ch) - character'pos('A') + character'pos('a'));
	    else
		return ch;
	    end if;
	end lower;

	function upper(ch: in character) 
	    return character is
	begin
	    if ch in 'a'..'z' then
		return
		character'val(
		  character'pos(ch) - character'pos('a') + character'pos('A'));
	    else
		return ch;
	    end if;
	end upper;

	function nexttabstop(i: in integer) 
	    return integer is
	begin
	    return i + tabamount - (i mod tabamount);
	end nexttabstop;

	function max(x, y: in integer) 
	    return integer is
	begin
	    if x > y then
		return x;
	    else
		return y;
	    end if;
	end max;

	function min(x, y: in integer) 
	    return integer is
	begin
	    if x < y then
		return x;
	    else
		return y;
	    end if;
	end min;

	procedure pushleft(ch: in character) is
	begin
	    if ch /= nul then
		if leftindex >= rightindex then
		    low.ferr("Stack overf(left)");
		else
		    leftindex := leftindex + 1;
		    textbuf(leftindex) := ch;
		end if;
	    end if;
	end pushleft;

	function popleft return character is
	begin
	    if leftindex < 1 then
		return nul;
	    else
		leftindex := leftindex - 1;
		return textbuf(leftindex + 1);
	    end if;
	end popleft;

	procedure pushright(ch: in character) is
	begin
	    if ch /= nul then
		if rightindex < leftindex then
		    low.ferr("Stack overf(right)");
		else
		    rightindex := rightindex - 1;
		    textbuf(rightindex) := ch;
		end if;
	    end if;
	end pushright;

	function popright return character is
	begin
	    if rightindex > textbufsize then
		return nul;
	    else
		rightindex := rightindex + 1;
		return textbuf(rightindex - 1);
	    end if;
	end popright;

	function peekleft return character is
	begin
	    if leftindex < 1 then
		return nul;
	    else
		return textbuf(leftindex);
	    end if;
	end peekleft;

	function peekright return character is
	begin
	    if rightindex > textbufsize then
		return nul;
	    else
		return textbuf(rightindex);
	    end if;
	end peekright;

	function leftright return character is
	    ch: character;
	begin
	    ch := popleft;
	    pushright(ch);
	    return ch;
	end leftright;

	function rightleft return character is
	    ch: character;
	begin
	    ch := popright;
	    pushleft(ch);
	    return ch;
	end rightleft;

	procedure bottom is
	begin
	    term.curpos(23, 0);
	    term.clearline;
	end bottom;

	procedure unbottom is
	begin
		null;
	end;

	procedure home is
	begin
	    ci := 0;  cj := 0;  term.mvhome;
	end home;

	procedure resetc is
	begin
	    term.curpos(ci, cj);
	end resetc;

	procedure linefeed is
	begin
	    if ci < height then
		ci := ci + 1;
	    else
		--. high.pluslines;  
		--. ci := ci + 1;
		ci := 0;
	    end if;
	    resetc;
	end linefeed;

	procedure carrtn is
	begin
	    cj := 0;  linefeed;
	end carrtn;

	procedure cursup is
	begin
	    if ci > 0 then  ci := ci - 1;  end if;
	    resetc;
	end cursup;

	procedure cursrt is
	begin
	    if cj < width then
		cj := cj + 1;
	    end if;
	    resetc;
	end cursrt;

	procedure curslf is
	begin
	    if cj > 0 then  cj := cj - 1;  end if;
	    resetc;
	end curslf;

	procedure foutchar(ch: in character) is
		the_ch : character := ch;
	begin
	    if character'pos(ch) < character'pos(' ') then
			           -- check control characters 
		term.dtyo(bell);
		the_ch := chradd(ch, ' ');
	    end if;
	    term.dtyo(the_ch);
	    if cj < width then
		cj := cj + 1;          -- bump to next column or new
				       --- line 
	    else
		carrtn;
	    end if;
	end foutchar;

	procedure ftab is
	begin
	    cj := nexttabstop(cj);     -- find next tab stop 
	    if cj > width then
		cj := width;
	    end if;
	    resetc;
	end ftab;

	procedure fmsg is
	begin
	    bottom;
	    put('[');
	    if curfile(1) = nul then
		put("New file");
	    else
		intrin.puts(curfile);
	    end if;
	    put(']');
	    unbottom;
	    resetc;
	end fmsg;

	procedure ferr(s: in string) is
	begin
	    bottom;
	    term.dtyo(bell);
	    put(s);
	    unbottom;
	    resetc;
	end ferr;

	procedure sync is
	begin
	    move.tpos(fi + ci, fj + cj);
	end sync;

end low;
