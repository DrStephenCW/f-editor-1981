#include "globals.h"
                /* F editor - routines that move or print lots of chars */

curindex(s)     /* for debugging */
char *s;
{       fcrlf();
        printf("leftindex = %d, rightindex = %d",leftindex,
                                textbufsize - rightindex);
        printf(" called from %s  ",s);
}

fput()
{       register int i;

        for(i = putbufindex; i >= 1; i--) pushright(putbuf[i]);
}

pick(line,spa,sav)
int line,spa;
boolean sav;
{       register int chars;
        register int lines;
        register char ch;

        screwed = false;
        putbufindex = 0;
        if (line < 0) then return;
        chars = 0;
        lines = 0;
        if (line > 0) then
                repeat
                        ch = popright();
                        push(ch,sav);
                        if (ch eq cr) then ++lines;
                until ((lines >= line) or (ch eq null));
        if (spa > 0) then
                repeat
                        ch = peekright();
                        if ((ch neq cr) and (ch neq null)) then begin
                                ch = popright();
                                push(ch,sav);
                                ++chars;
                        end;
        until ((chars >= spa) or (ch eq cr) or (ch eq null));
        if (sav) then fput();
        if (screwed) then ferr("Not all characters saved");
}

push(ch,sav)
char ch;
boolean sav;
{       if (putbufindex eq putbufsize) then screwed = true;
        else putbuf[++ putbufindex] = ch;
        if (sav and screwed) then begin
                fput();
                ferr("Unable to save that many characters");
        end;
}

upline()
{       register int count;
        boolean res;

        res = false;
        if (leftindex < 1) then return res;
        count = scaneq(-leftindex, cr, &textbuf[leftindex]);
        if (count neq -leftindex) then begin
                --count;
                res = true;
        end;
        rightindex += count;
        leftindex += count;
        moveright(&textbuf[leftindex + 1],&textbuf[rightindex], abs(count));
        return res;
}

downline()
{       register int count;
        boolean res;

        res = false;
        if (rightindex > textbufsize) then return res;
        count = scaneq(textbufsize - rightindex + 1, cr,
                        &textbuf[rightindex]);
        if (count neq textbufsize - rightindex + 1) then begin
                ++count;
                res = true;
        end;
        moveleft(&textbuf[rightindex], &textbuf[leftindex + 1], abs(count));
        rightindex += count;
        leftindex += count;
        return res;
}

tpos(tempi, tempj)              /* position file at tempi, tempj */
int tempi,tempj;
{       register char ch;
        register int i;

        if ((ti eq tempi) and (tj eq tempj)) then return;

        while (ti < tempi) begin        /* adjust lines */
                if (not downline()) then pushleft(cr);
                ++ti;
        end;            /* ti is ok, and we're at the start of the line */

        while (ti > tempi) begin              
                upline();
                --ti;
        end;            /* ti ok, but we're at the end of the line */

        repeat                  /* make sure we're at start of line */
                ch = leftright();
        until ((ch eq cr) or (ch eq null));

        if (ch eq cr) then rightleft(); /* now at start of line for sure */

        tj = 0;                 /* adjust spaces */
        while (tj < tempj) begin
                ch = rightleft();
                if ((ch eq cr) or (ch eq null)) then begin
                        if (ch eq cr) then ch = leftright();
                        for (i = tj - 1; i < tempj - 1; i++) pushleft(' ');
                        tj = tempj;
                end
                else ++tj;
        end;
}

fixcursor(newi,newj)
int newi,newj;
{       register int oldfi,oldfj,newci,newcj;

        tpos(newi + 1, newj);           /* position to spot in file */

        oldfi = fi;   
        if ((ti < fi) or (ti > fi + height)) then fi = max(ti - 2, 0);
                                        /* behind, or more than one */
                                        /* page ahead? */
        oldfj = fj;
        if ((tj < fj) or (tj > fj + width)) then fj = max(tj - 2, 0);
                                        /* To the left, or past right edge? */

        newci = ti - fi;
        newcj = tj - fj;

        if ((fi eq oldfi) and (fj eq oldfj)) then begin
                if (enters) then display(ci,ci,cj);
        end
        else begin
                display(0,height,0);
                fmsg();
        end;

        ci = newci;
        cj = newcj;

        resetc();
}



