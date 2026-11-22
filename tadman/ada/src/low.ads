with text_io; use text_io;
with defs; use defs;

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
