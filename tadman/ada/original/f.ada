with text_io; use text_io;
with defs; use defs;
with fstacks;
with top;
with term;
with disp;
with low;

procedure f is
    file: constant string := ""; 
    smartterm: boolean := false; 
    slow: integer := 24; 
    initial_row, initial_column: integer := 0; 
    err_mess: constant string := "";
begin
    top.finit;
    if not fstacks.readfile then
	null;                          -- nothing   
				       -- attempt to read file - don't
				      --- save old 
    end if;
    term.initterm;
    if initial_row > 0 or else 
       initial_column > 0 then
	fi := fi + 
	      (initial_row / height) * height;  -- integer
						--- arithmetic! 
	ci := initial_row mod height;
	cj := initial_column;
    end if;
    term.clearpage;
    disp.display(0, height, 0);
    if err_mess'length /= 0 then
	low.bottom;
	put(err_mess);
	low.unbottom;
	low.resetc;
    else
	low.fmsg;
    end if;
    loop
		top.chprocess(term.dtyi);    -- never exits
    end loop;
exception
    when bye_bye => put_line("Bye bye!");
end f;
