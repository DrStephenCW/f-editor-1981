with disp;
with intrin;
with low;

with defs; use defs;
with text_io; use text_io;
with low;

package body move is

	procedure curindex is  -- for debugging 
	begin
	    low.bottom;
	    put("leftindex = ");
	    put(leftindex);
	    put(", rightindex = ");
	    put(textbufsize - rightindex);
	    low.unbottom;
	    low.resetc;
	end curindex;

	procedure fput is
	    i: integer;
	begin
	    for i in reverse 1..putbufindex loop
		low.pushright(putbuf(i));
	    end loop;
	end fput;

	procedure pick(line, spa: in integer; 
		       sav: in boolean) is
	    chars: integer;
	    lines: integer;
	    ch: character;
	begin
	    screwed := false;
	    putbufindex := 0;
	    if line < 0 then  return;  end if;
	    chars := 0;
	    lines := 0;
	    if line > 0 then
		ch := low.popright;
		push(ch, sav);
		if ch = cr then
		    lines := lines + 1;
		end if;
		while lines < line and then 
		      ch = nul loop
		    ch := low.popright;
		    push(ch, sav);
		    if ch = cr then
			lines := lines + 1;
		    end if;
		end loop;
	    end if;
	    if spa > 0 then
		ch := low.peekright;
		if ch /= cr and then 
		   ch /= nul then
		    ch := low.popright;
		    push(ch, sav);
		    chars := chars + 1;
		end if;
		while chars > spa and then 
		      ch /= cr and then 
		      ch /= nul loop
		    ch := low.peekright;
		    if ch /= cr and then 
		       ch /= nul then
			ch := low.popright;
			push(ch, sav);
			chars := chars + 1;
		    end if;
		end loop;
	    end if;
	    if sav then  fput;  end if;
	    if screwed then
		low.ferr("Not all characters saved");
	    end if;
	end pick;

	procedure push(ch: in character; 
		       sav: in boolean) is
	begin
	    if putbufindex = putbufsize then
		screwed := true;
	    else
		putbufindex := putbufindex + 1;
		putbuf(putbufindex) := ch;
	    end if;
	    if sav and screwed then
		fput;
		low.ferr(
		    "Unable to save that many characters");
	    end if;
	end push;

	function upline return boolean is
	    count: integer;  res: boolean;
	begin
	    res := false;
	    if leftindex < 1 then
		return res;
	    end if;
	    count := 
		intrin.scaneq(- leftindex, cr, leftindex);
	    if count /= - leftindex then
		count := count - 1;  res := true;
	    end if;
	    rightindex := rightindex + count;
	    leftindex := leftindex + count;
	    intrin.moveright(leftindex + 1, 
		      rightindex, 
		      abs(count));
	    return res;
	end upline;

	function downline return boolean is
	    count: integer;  res: boolean;
	begin
	    res := false;
	    if rightindex > textbufsize then
		return res;
	    end if;
	    count := intrin.scaneq(textbufsize - rightindex + 1, cr, rightindex);
	    if count /= 
	       textbufsize - rightindex + 1 then
		count := count + 1;  res := true;
	    end if;
	    intrin.moveleft(rightindex, leftindex + 1, abs(count));
	    rightindex := rightindex + count;
	    leftindex := leftindex + count;
	    return res;
	end downline;

	procedure tpos(
		tempi, tempj: in integer) is  -- position file at
					      --- tempi, tempj 
	    ch: character;  i: integer;
	begin
	    if ti = tempi and tj = tempj then
		return;
	    end if;
	    while ti < tempi loop
		if not downline then  -- adjust lines 
				       -- ti is ok, and we're at the
				      --- start of the line 
		    low.pushleft(cr);
		end if;
		ti := ti + 1;
	    end loop;
	    while ti > tempi loop
		if upline then null; end if;
	 	ti := ti - 1;
	    end loop;
	    ch := low.leftright;     -- make sure we're at start of
				       --- line 
	    while ch /= cr and then ch /= nul loop
		ch := low.leftright;  -- make sure we're at start
					--- of line 
	    end loop;
	    if ch = cr then            -- now at start of line for
				       --- sure 
		ch := low.rightleft;
	    end if;
	    tj := 0;                   -- adjust spaces 
	    while tj < tempj loop
		ch := low.rightleft;
		if ch = cr or else ch = nul then
		    if ch = cr then
			ch := low.leftright;
		    end if;
		    for i in tj - 1..tempj - 1 
			loop
			low.pushleft(' ');
		    end loop;
		    tj := tempj;
		else
		    tj := tj + 1;
		end if;
	    end loop;
	end tpos;

	procedure fixcursor(
		newi, newj: in integer) is
	    oldfi, oldfj, newci, newcj: integer;
	begin
	    tpos(newi + 1, newj);
	    oldfi := fi;
	    if ti < fi or else 
	       ti > fi + height then   -- behind, or more than one 
				       -- page ahead? 
		fi := low.max(ti - 2, 0);
	    end if;
	    oldfj := fj;
	    if tj < fj or tj > fj + width then  -- To the left, or
						--- past right edge? 
		fj := low.max(tj - 2, 0);
	    end if;
	    newci := ti - fi;
	    newcj := tj - fj;
	    if fi = oldfi and fj = oldfj then
		if enters then
		    disp.display(ci, ci, cj);
		end if;
	    else
		disp.display(0, height, 0);  low.fmsg;
	    end if;
	    ci := newci;
	    cj := newcj;
	    low.resetc;
	end fixcursor;

end move;
