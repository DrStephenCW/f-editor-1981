
with defs; use defs;
with low;
with term;

package body trans is

function translate(c: in character) 
    return comtype is
	ch : character := c;
--. F editor - character translation routine 
begin
    if ch in ' '..'~' then
	return comchar;                -- printing character 
    elsif  ch = rubout  then
	return combk;                  -- treated eq to backspace 
    elsif  ch in nul..character'val(31)  then
	case low.chradd(ch, '@') is
	when 'A' =>  return cominspac;
	when 'B' =>  return comsetfil;
	when 'C' =>  return cominterrupt;
	when 'D' =>  return cominslines;
	when 'E' =>  return combser;
	when 'F' =>  return comdelines;
	when 'G' =>  return comput;
	when 'H' =>  return combk;
	when 'I' =>  return comtab;
	when 'J' =>
	    return comrtn;             -- change when raw mode put in
	when 'K' =>  return comup;
	when 'L' =>  return comrt;
	when 'M' =>  return comrtn;
	when 'N' =>  return comknock;
	when 'O' =>  return comgotost;
	when 'P' =>  return comeof;
	when 'Q' =>  return combkpage;
	when 'R' =>  return comfser;
	when 'S' =>  return comdelspac;
	when 'T' =>  return complulines;
	when 'U' =>  return comredraw;
	when 'V' =>  return comlf;
	when 'W' =>  return comminlines;
	when 'X' =>  return comrename;
	when 'Y' =>  return comhome;
	when 'Z' =>  return comexit;
	when '\' =>  return comrt;
	when '_' =>  return compick;
	when '^' =>  return comhome;
	when '[' =>
	    if not smartterm then      -- must be one of them-thar
				       --- smart terminals 
		return comesc;
	    end if;
	    ch := term.dtyi;         -- command char follows esc 
	    case ch is
	    when '@' =>  return comsic;
	    when 'A' =>  return comup;
	    when 'B' =>  return comlf;
	    when 'C' =>  return comrt;
	    when 'D' =>  return combk;
	    when 'H' =>  return comhome;
	    when 'L' =>  return comsil;
	    when 'M' =>  return comsdl;
	    when 'N' =>  return comsdc;
	    when 'O' =>  return comsic;
	    when 'S' =>  return comesc;
	    when 'T' =>
		return combreak;       -- f2 
	    when 'U' =>
		return comunbreak;     -- f3 
	    when 'V' =>
		return comrdwline;     -- f4 
	    when 'W' =>
		return comrevscroll;   -- f5 
	    when ' ' =>
		return comnull;        -- for correcting accidental
				       --- esc's 
	    when esc =>
		return comesc;         -- two escapes = one normal
				       --- esc 
	    when others =>  return comerror;
	    end case;
	when others =>  return comerror;
	end case;
    end if;
end translate;

end trans;
