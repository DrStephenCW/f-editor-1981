with defs; use defs;

package high is
    --. F editor - High level functions 

	procedure fcrlf;               -- print carriage return and
				       --- line feed 

	procedure srevscroll;          -- smart minus 1 line 

	procedure deletespaces;        -- remove characters from
				       --- editing buffer 

	procedure deletelines;         -- delete lines and spaces 

	procedure addlines;            -- inserts carriage returns 

	procedure addspace;            -- insert blanks into editing
				       --- buffer 

	procedure fputchar(ch: in character);

	procedure inscr;               -- insert a carriage return
				       --- into the file 
	procedure rmvcr;

	procedure sic;                 -- smart insert blank into
				       --- editing buffer 
	procedure renamefile;

	procedure setfile;

	procedure sil;                 -- smart insert line 
	procedure searchbackward;

	procedure sdl;                 -- delete lines 

	procedure putback;             -- restore put buffer 

	procedure pickup;              -- put text into put buffer 

	procedure pluspages;           -- move window forward by
				       --- screenfuls 

	procedure knockdown;           -- take next character
				       --- literally 

	procedure backpages;           -- move window backwards by
				       --- screenfuls 

	procedure minuslines;          -- move window backwards by
				       --- lines 

	procedure gotoend;             -- skip lines to end of buffer
				       --- 

	procedure searchforward;       -- search for text 

	procedure sdc;                 -- smart remove character from
				       --- editing buffer 

	procedure pluslines;           -- move window forward by
				       --- lines 

	procedure redraw;

	procedure eolplease;           -- only goes to end of current
				       --- line 
	procedure gotostart;

	procedure fexit;

	procedure cleanup;             -- belongs in low.c 

	procedure interruptexit;

end high;
