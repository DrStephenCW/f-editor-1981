package body call_csh is
	function system(s: string) return integer;
	pragma import(c, system, "system");
	procedure csh(s : string) is
	    r: integer;
	begin r := system(s & character'val(0)); end;
end call_csh;
