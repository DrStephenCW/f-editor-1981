
with defs; use defs;
with text_io; use text_io;
with low;
with move;
with top;
with intrin;

package body fstacks is

	procedure intobuf(ch: in character) is
	    t: integer;
	begin
	    if ch = cr then
		ti := ti + 1;  tj := 0;
	    elsif  ch = tab  then
		t := low.nexttabstop(tj);
		while tj < t loop
		    low.pushleft(' ');
		    tj := tj + 1;
		end loop;
		return;
	    else
		tj := tj + 1;
	    end if;
	    low.pushleft(ch);
	end intobuf;

	function readfile return boolean is
	    ch: character;
	    numchars: integer;
	    f : file_type;
	begin
	    numchars := 0;
	    top.emptystacks;
	    lastfile := curfile;
	    curfile := newfile;
	    if curfile(1) = nul then
		return false;
	    end if;
	    begin
	        open(f, in_file, curfile(1..intrin.strlen(curfile)));
	    exception
	        when name_error => return false;
	    end;
	    loop
		exit when end_of_file(f);
		if end_of_line(f) then skip_line(f); ch := lf;  -- port
		else get(f,ch); end if;
		if ch = lf then
		    intobuf(cr);
		else
		    intobuf(ch);
		end if;
		numchars := numchars + 1;
	    end loop;
	    close(f);
	    move.tpos(0, 0);
	    return true;
	end readfile;

	function lftocr(ch: in character) return character is
	begin
	    if ch = cr then
		return lf;
	    else
		return ch;
	    end if;
	end lftocr;

	function writefile return boolean is
		f : file_type;
		i : integer;
	begin
	    if not changed then
		return true;
	    end if;
	    i := intrin.strlen(curfile);
	    if i = 0 then
		low.ferr("File not named");
		return false;
	    end if;
	    begin
		create(f, out_file, curfile(1..i));  -- port: was open(f, out_file, curfile)
	    exception
		when name_error => 
			low.ferr("Can't open file for writing");
			return false;
	    end;
	    for i in 1..leftindex loop
		put(f, lftocr(textbuf(i)));
	    end loop;
	    for i in rightindex..textbufsize loop
		put(f, lftocr(textbuf(i)));
	    end loop;
	    if rightindex <= textbufsize then
		if textbuf(textbufsize) /= cr then
		    put(f, lf);
		end if;
	    elsif  textbuf(leftindex) /= cr  then
		put(f, lf);
	    end if;
	    close(f);
	    return true;
	end writefile;

end fstacks;
