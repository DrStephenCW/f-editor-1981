package typin is
	procedure typein(ch : in character);
end typin;

with defs; use defs;
with low; use low;
with high; use high;
with trans;
with par;
with disp;

package body typin is

procedure typein(ch: in character) is
--. F editor - typein routine 
    command: comtype;
begin
    command := trans.translate(ch);
    if command = comesc then
	command := par.paramode;
    end if;
    case command is
    when comnull =>  null;
    when cominspac =>  changed := true;  addspace;
    when comdelspac =>
	changed := true;
	deletespaces;
    when comsetfil =>  setfile;
    when comrename =>  renamefile;
    when cominslines =>
	changed := true;
	addlines;
    when comdelines =>
	changed := true;
	deletelines;
    when compick =>  pickup;
    when comput =>  changed := true;  putback;
    when comtab =>  ftab;
    when comrtn =>  carrtn;
    when comlf =>  linefeed;
    when comup =>  cursup;
    when combk =>  curslf;
    when comrt =>  cursrt;
    when comforpage =>  pluspages;
    when combkpage =>  backpages;
    when complulines =>  pluslines;
    when comminlines =>  minuslines;
    when comfser =>  searchforward;
    when combser =>  searchbackward;
    when comhome =>  home;
    when comres =>  resetc;
    when comchar =>
	changed := true;
	fputchar(ch);
	foutchar(ch);
    when comredraw =>  redraw;
    when comgotost =>  gotostart;
    when comknock =>  changed := true;  knockdown;
    when comerror =>  ferr("Unknown command");
    when comexit =>  fexit;
    when cominterrupt =>  interruptexit;
    when comeol =>  eolplease;
    when comeof =>  gotoend;
    when comsil =>  changed := true;  sil;
    when comsdl =>  changed := true;  sdl;
    when comsic =>  changed := true;  sic;
    when comsdc =>  changed := true;  sdc;
    when comrdwline =>  disp.display(ci, ci, 0);
    when combreak =>  changed := true;  inscr;
    when comunbreak =>  changed := true;  rmvcr;
    when comrevscroll =>  srevscroll;
    when others =>  ferr("Bug in typein");
    end case;
end typein;

end typin;
