#include "globals.h"
                /* F editor - main display routine */

display(start,linef,col)
int start,linef,col;
{       register int rindex;
        register char ch;
        register int curcol;
        register int crcount;
        register int lmargin;
        register int cstart = start;
        register int spacecount;

        curpos(start,col);
        fi = max(fi,0);
        tpos(fi + start, 0);
        rindex = rightindex;
        crcount = 0;
        curcol = -1;
        clearline();      
        lmargin = col;
        spacecount = 0;
        while ((rindex <= textbufsize) and (crcount <= linef - start)) begin
                ch = textbuf[rindex];       
                ++curcol;
                if (ch eq cr) then begin
                        ++crcount;
                        if (curcol < width) then clearline();     
                        curcol = -1;
                        lmargin = tj;
                        ++cstart;
                        curpos(cstart,0);  
                        ch = null;
                        spacecount = 0;
                end else
                        if (ch < ' ') then begin /* highest control char */
                                ch = ch + '@';
                                dtyo(bell);
                        end;
                if ((curcol - fj >= lmargin) and (curcol - fj < width) 
                                             and (ch neq null)) 
                        then if (ch eq ' ') then spacecount++; 
                             else begin
                                if (spacecount < 4) then 
                                while (spacecount > 0) begin
                                        dtyo(' ');
                                        spacecount--;
                                end 
                                else begin
                                        clearline();
                                        curpos(cstart,curcol);
                                end;
                                dtyo(ch);
                                spacecount _ 0;
                             end;
                ++rindex;
        end;
        eofdis = (rindex > textbufsize);
        if (eofdis) then cleareop();      
	resetc();
	if (start != linef) fmsg();
}

