
package term is
    --. F editor - terminal handler 

	function dtyi return character;  -- assumes raw mode 

	procedure dtyo(ch: in character);  -- assumes raw mode 

	procedure initterm;

	procedure endterm;

	procedure clearline;

	procedure cleareop;

	procedure curpos(r, c: in integer);

	procedure clearpage;

	procedure mvhome;

	procedure termil;

	procedure termdl;

	procedure termic;

	procedure termdc;

	procedure termscroll(n: in integer);  

end term;
