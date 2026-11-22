with defs; use defs;
with text_io; use text_io;

package intrin is

	--. F editor - very low level byte moving routines
	procedure puts(s : string);	-- handles nul terminator

	procedure null_string(s : in out string);

	function strlen(s : string) return integer;

	procedure moveleft(src, dest: in integer;
			   len: in integer);

	procedure moveright(src, dest: in integer; 
			    len: in integer);

	function scaneq(amount: in integer; 
			 ch: in character; 
			 src: in integer) return integer;
end intrin;
