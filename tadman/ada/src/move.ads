with defs; use defs;
with text_io; use text_io;

package move is
    --. F editor - routines that move or print lots of chars 

	procedure curindex;

	procedure fput;

	procedure pick(line, spa: in integer; 
		       sav: in boolean);

	procedure push(ch: in character; 
		       sav: in boolean);

	function upline return boolean;

	function downline return boolean;

	procedure tpos(tempi, tempj: in integer);  -- position file
						   --- at tempi,
						   --- tempj 

	procedure fixcursor(newi, newj: in integer);

end move;
