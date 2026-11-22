#include "globals.h"
                /* F editor - High level functions */

fcrlf()                         /* print carriage return and line feed */
{       putchar(cr);            /* needed in raw mode */
        putchar(lf);
}

srevscroll()                    /* smart minus 1 line */
{       sync();
        if (fi <= 0) then return;       /* no place to go */
        termrevscroll(1);
        fi -= 1;                /* move screen back a line */
        fi = max(0,fi);
        ci += 1;
        if (ci > height) then home();
        display(0,0,0);         /* display top line */
}

deletespaces()                  /* remove characters from editing buffer */
{       char ch;
        short count;

        sync();
        if (defspace > 0) then begin
                count = defspace;
                repeat
                        ch = popright();
                        --count;
                until ((ch eq cr) or (ch eq null) or (count < 0));
                pushright(ch);
        end;
        display(ci,ci,cj);        
}

deletelines()                   /* delete lines and spaces */
{       sync();
        defpick = deflines;
        defsxp = defsxl;
        pick(deflines,defsxl+fj,false);
        if (deflines neq 0) display (ci,height,cj);
        else display (ci,ci,cj);
}

addlines()                      /* inserts carriage returns */
{       int i;                  /* plus spaces */

        sync();
        for (i = 0; i < defsxl + fj; i++) pushright (' ');
        for (i = 0; i < deflines; i++) pushright (cr);
        if (deflines neq 0) display (ci,height,cj);
        else display (ci,ci,cj);
}

addspace()                      /* insert blanks into editing buffer */
{       int i;

        sync();
        for (i=1; i <= defspace; i++) pushright (' ');
        display(ci,ci,cj);        
}

fputchar(ch)
char ch;
{       char peek;              /* put character into editing buffer */
        sync();
        ++tj;
        pushleft (ch);
        peek = peekright();     /* overwrite current char unless cr or null */
        if ((peek neq null) and (peek neq cr)) then popright();
}

inscr()                         /* insert a carriage return into the file */
{       sync();
        pushright(cr);          /* now update screen smartly */
        clearline();            /* remove garbage past break */
        if (ci eq height) then return;  /* done in this case */
        curpos(ci + 1,cj);
        termil();
        display(ci + 1, ci + 1, 0);     /* fill in contents of new line */
}
  
rmvcr()
{       char peek;
        sync();
        pick(1,0,false);        /* remove from cursor to end of line */
        clearline();            /* and on screen too */
        if (ci neq height) then begin
                curpos(ci + 1, 0);
                termdl();
        end;
        display(ci,ci,cj);      /* display new stuff from next line */
        display(height, height, 0);  /* display new stuff that scrolls up */
}                                       

sic()                      /* smart insert blank into editing buffer */
{       sync();
        termic();
        pushright (' ');
        resetc();
}

renamefile()
{       if (param[0] eq null) then ferr("No file specified for rename");
        strcpy(curfile,param);
        if (enters) then display(ci,ci,cj);
        fmsg();
}

setfile()
{       if (not writefile()) then return;
        if (strcmp(newfile,curfile) eq 0) then
                strcpy(newfile,lastfile);
        readfile();
        changed _ false;
        display(0,height,0);
        fmsg();
}

sil()                      /* smart insert line */
{       cj _ 0;                 /* doesn't break lines */
        sync();
        pushright (cr);
        if (deflines + ci > height) clearpage();
        termil();
}

searchbackward()
{       int lindex;             /* local copy of leftindex  */
        int sti,stj;            /* local copies of ti and tj */
        int size;               /* size of search parameter */
        boolean found;             
        boolean ok;
        char firstch;
        char ch;
        int i;
        char mess[255];

        if (defsearch[0] eq 0) then begin
                ferr("No search string");
                if (enters) then display(ci,ci,cj);
                else resetc();
                return;
        end;

        sprintf(mess, "-Search \"%s\"", defsearch);
        termstatus(mess);

        sync();

        size = strlen(defsearch);
        for (i _ 0; i < size; ++i)
                defsearch[i] _ lower(defsearch[i]);

        firstch = defsearch[0];

        lindex = leftindex;     /* might miss first occurance */
        sti _ ti - 1;                       
        stj _ 00;               /* number of characters from end of line */

        found _ false;

        while ((lindex >= 1) and (not found)) begin

                ch _ lower(textbuf[lindex]);

                if (ch eq cr) then begin
                        --sti;
                        stj _ 00;
                end
                else --stj;       

                if (ch eq firstch) then begin
                        ok _ true;
                        for (i _ 1; i < size; ++i)
                                ok _ ((defsearch[i]
                                             eq lower(textbuf[lindex+i]))
                                      & ok);
                        found _ ok;
                end;

                if (not found) then --lindex;
        end;

        if (found) then begin
                termstatus("*Found*");
                fixcursor(sti,000);             /* tj ignored for now */
        end
        else begin
                termstatus("*Failed*");
                if (enters) then display(ci,ci,cj);
                else resetc();
        end;
}

sdl()                   /* delete lines */
{       cj _ 0;
        sync();
        defpick = 1;
        pick(1, 0, false);
        termdl();
        display(height, height, 0);
}

putback()                       /* restore put buffer */
{       sync();
        fput();
        if (lastpick > 0) display(ci,height,cj);
        else display(ci,ci,cj);
}

pickup()                        /* put text into put buffer */
{       sync();
        pick (defpick,defsxp,true);
        if (enters) then display(ci,ci,cj);
        else resetc();
}

pluspages()                     /* move window forward by screenfuls */
{       sync();
        fi += defpages * (height + 1);
        display(0,height,0);
}

knockdown()                     /* take next character literally */
{       char ch;

        sync();
        ch = dtyi();
        fputchar(ch);
        foutchar(ch);
}

backpages()                     /* move window backwards by screenfuls */
{       sync();
        fi -= defpages * (height + 1);
        fi = max(fi,0);
        display(0,height,0);
}

minuslines()                    /* move window backwards by lines */
{       sync();
        fi -= defpluslines;
        if (fi < 0) then begin  /* stop at beginning of file */
                fi = 0;
                ci = 0;
        end else
        begin
                ci += defpluslines;
                if (ci > height) then begin     /* put cursor home if */
                        ci = 0;                 /* it wanted to move */
                        cj = 0;                 /* off the top of the */
                end                             /* screen */
        end;
        display(0,height,0);
}

gotoend()                       /* skip lines to end of buffer */
{       sync();
        while (downline()) begin
                fi += 1;
                ti += 1;
        end;
        minuslines();
}

searchforward()                 /* search for text */
{       int rindex;             /* copy of rightindex */
        int sti, stj;           /* copies of ti and tj */
        int size;               /* size of search string */
        boolean found;
        boolean ok;
        char firstch;           /* first char of text to search for */
        char ch;                /* current char in buffer being tested */
        int i;                  /* random loop control */
        char mess[256];

        if (defsearch[0] eq 0) then begin
                ferr("No search string");
                if (enters) then display(ci,ci,cj);
                else resetc();
                return;
        end;

        sprintf(mess, "+Search \"%s\"", defsearch);
        termstatus(mess);

        sync();

        size = strlen(defsearch);       /* convert to lower case */
        for (i = 0; i < size; i++) defsearch[i] = lower(defsearch[i]);

        firstch = defsearch[0];

        if (textbuf[rightindex] eq cr) then begin
                sti = ti;               /* current spot in file */
                stj = - 1;
        end                             /* bug fix by Scott Ogata */
        else begin
                sti = ti - 1;
                stj = tj;
        end;
        rindex = rightindex + 1;        /* skip current character */
                                        /* in case of repeated searches */
        found = false;

        while ((rindex + size <= textbufsize) and (not found)) begin

                ch = lower(textbuf[rindex]);

                if (ch eq cr) then begin        /* count lines and spaces */
                        ++sti;
                        stj = -1;
                end
                else ++stj;

                if (ch eq firstch) then begin   /* check for match */
                        ok = true;
                        for (i = 1; i < size; ++i)
                                ok = ((defsearch[i] eq lower(textbuf[
                                                                rindex + i]))
                                      & ok);    /* ok remains true until */
                        found = ok;             /* bad character */
                end;

                if (not found) then ++rindex;   /* try from next char */
        end;

        if (found) then begin
                termstatus(" *Found*");
                fixcursor(sti,stj);     /* moves to right spot in file */
        end
        else begin
                termstatus(" *Failed*");       
                if (enters) then display(ci,ci,cj);
                else resetc();
        end;
}

sdc()                  /* smart remove character from editing buffer */
{       char ch;

        sync(); 
        ch = popright();        /* remove character */
        if ((ch eq cr) or (ch eq null)) then pushright(ch);
                                /* never past end of buffer or line */
        termdc();
        /* needs to display character that might appear at right margin */
}

pluslines()                     /* move window forward by lines */
{       int i;

        sync();
        fi += defpluslines;
        /* if (control_s_bug) then begin
                ci -= defpluslines;
                if (ci < 0) then home();
                display(0,height,0);
        end 
        else */
	if (defpluslines >= height) display(0,height,0);
        else begin
                termscroll(defpluslines);
                if (not eofdis) then
                        display(height - defpluslines + 1, height, 0);
                ci -= defpluslines;
                if (ci < 0) then home();
                else if (enters) then display(ci,ci,cj);
                else resetc();
        end;
}

redraw()        
{   
        clearpage();
        display(0,height,0);
        fmsg();
}

eolplease()                     /* only goes to end of current line */
{       char ch;
        int count;              /* number of characters skipped over */
        sync();
        count = -1;

        if (rightindex > textbufsize) then return;

        repeat
                ++count;
                ch = textbuf[rightindex + count];
        until ((ch eq cr) or ((rightindex + count + 1) > textbufsize));

        cj = min(width,cj + count);     /* don't move screen */
        resetc();
}

gotostart()     /* goes to beginning of file ignoring ti and tj */
{               /* this is to make ti and tj match the stacks */
                /* this extra work shouldn't really be necessary */
        while (upline()) ;      /* move everything to */
                                /* right stacks */
        fi = fj = ti = tj = ci = cj = 0;        /* reset file pointers */
        display(0,height,0);
}

fexit()
{       if (not writefile()) then return;
        endterm();
        exit(0);
}


interruptexit()
{       char ch;
        termstatus("Type a q or a Q to exit; anything else to resume editing.");
        ch = dtyi();
        if ((ch eq 'q') or (ch eq 'Q')) then begin
                endterm();
                exit(1);
        end;
        fmsg();
}



