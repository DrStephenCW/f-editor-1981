with text_io;
package defs is
--. F editor for Vax/Unix 
--. 
--. Original-original version by James Meehan in IMP10 and IMP20
--. Next one by Stephen Willson and Eric Olsen in UCSD Pascal
--. Then written in C by Stephen Willson
--. Transliterated into ADA and modified for use in the
--.     UCI ADA Environment by Frank Tadman
--. Debugged by Stephen Willson using Arcturus
--.
--. Global definitions 
--.   Characters (should be in standard)
--.    setbuf(stdout, NULL);
    nul: constant character := character'val(0);
    cr: constant character := character'val(13);
    controlx: constant character := character'val(24);
    controlz: constant character := character'val(26);
    bell: constant character := character'val(7);
    backspace: constant character := character'val(8);
    lf: constant character := character'val(10);
    tab: constant character := character'val(9);
    rubout: constant character := character'val(127);
    esc: constant character := character'val(27);
	--.   Parameters
    tabamount: constant integer := 8;  -- terminal characteristics 
    putbufsize: constant integer := 500;  -- editing buffer sizes 
    textbufsize: constant integer := 1000;
    filensize: constant integer := 255;  -- space for file name 
    LINES: constant integer := 23;
    COLS: constant integer := 80;
    type comtype is 
	(comerror, comnull, comrevscroll, 
	 cominspac, comdelspac, comsetfil, 
	 cominslines, comdelines, compick, comput, 
	 comtab, comrtn, comlf, comup, combk, 
	 combser, comhome, comres, comchar, 
	 comredraw, comeof, comeol, comknock, 
	 comexit, cominterrupt, comesc, comfser, 
	 complulines, comminlines, comrt, 
	 comgotost, comforpage, combkpage, 
	 cominfo, comrename, comsil, comsdl, 
	 comsic, comsdc, comrdwline, combreak, 
	 comunbreak);
    screwed: boolean;                  -- put buffer overflowed 
    curfile: string(1..filensize);     -- current filenames 
    deffile: string(1..filensize);     -- default file 
    newfile: string(1..filensize);     -- next file to edit 
    lastfile: string(1..filensize);    -- next file we edited 
    height: integer;                   -- current screen dimensions 
    width: integer;
    leftindex: integer;                -- stack pointers 
    rightindex: integer;
    defsearch: string(1..80);          -- current search string 
    defspace: integer;                 -- arguments to commands 
    deflines: integer;
    defsxl: integer;
    defpages: integer;
    defslide: integer;                 -- no longer used 
    defpluslines: integer;
    defpick: integer;
    defsxp: integer;
    saveci, savecj: integer;           -- globals for moving routines
				       --- 
				       -- below: i for height; j for
				      --- width 
    ci: integer;                       -- current cursor position on
				       --- screen 
    cj: integer;
    fi: integer;                       -- address of top-left of
				       --- screen 
    fj: integer;
    ti: integer;                       -- current spot in file 
    tj: integer;
    enters: boolean;                   -- hit <enter> ? 
    changed: boolean;                  -- file has been modified? 
    param: string(1..255);             -- parameter characters 
    putbufindex: integer;              -- end of put buffer contents 
    eofdis: boolean;                   -- at end of file if true 
    textbuf: string(1..textbufsize + 20);  -- actual editing buffer 
    putbuf: string(1..putbufsize + 20);  -- deletion save buffer 
    lastpick: integer;                 -- size of last pick operation
				       --- in lines (bug introduced by 
				       --- resetting the args after 
				       --- each command) 
    file: string(1..80);		-- name of file specified when called
    smartterm: boolean; 		-- true if using special heath features
    slow: integer; 			-- size of screen
    initial_row,initial_column: integer; -- where to position cursor at startup
    err_mess: string(1..80);		-- message to print at bottom at 
					--- startup
    bye_bye : exception;
    -- port: the UCI text_io could put an integer directly
    package int_io is new text_io.integer_io(integer);
    procedure put(item: integer; width: text_io.field := 0;
                  base: text_io.number_base := 10) renames int_io.put;
end defs;

