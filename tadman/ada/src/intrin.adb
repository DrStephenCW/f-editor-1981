
with defs; use defs;
with text_io; use text_io;

package body intrin is

	procedure puts(s : string) is
	begin
		for i in s'first..s'last loop
			exit when s(i) = nul;
			put(s(i));
		end loop;
	end;

	procedure null_string(s : in out string) is
	begin
		s(s'first) := nul;
	end;

	function strlen(s : string) return integer is
		i : integer := s'first;
		len : integer := 0;
	begin
		while i <= s'last loop
			exit when s(i) = nul;
			i := i + 1;
			len := len + 1;
		end loop;
		return len;
	end; 

	procedure moveleft(src, dest: in integer;
			   len: in integer) is
	begin
	    for i in 0..len - 1 loop
		textbuf(dest + i) := textbuf(src + i);
	    end loop;
	end moveleft;

	procedure moveright(src, dest: in integer;
			    len: in integer) is
	ldest : integer := dest;
	lsrc : integer := src;

	begin
	    ldest := ldest + len;
	    lsrc := lsrc + len;
	    for i in 0..len - 1 loop
		ldest := ldest - 1;
		lsrc := lsrc - 1;
		textbuf(ldest) := textbuf(lsrc);
	    end loop;
	end moveright;

	function scaneq(amount: in integer; 
			 ch: in character; 
			 src: in integer) return integer is
	    i: integer;
	begin
	    i := amount;
	    if i = 0 then  return 0;  end if;
	    if i > 0 then
		i := 0;
		while i < amount and then 
		      textbuf(src + i) /= ch loop
		    i := i + 1;
		end loop;
		return i;
	    else
		i := 0;
		while i > amount and then 
		      textbuf(src + i) /= ch loop
		    i := i - 1;
		end loop;
		return i;
	    end if;
	end scaneq;

end intrin;
