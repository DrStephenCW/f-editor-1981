#include "globals.h"
                /* F editor - low level functions */


lower(ch)
char ch;
{       if ((ch >= 'A') and (ch <= 'Z')) then return ch - 'A' + 'a';
        else return ch;
}

upper(ch)
char ch;
{       if ((ch >= 'a') and (ch <= 'z')) then return ch - 'a' + 'A';
        else return ch;
}

nexttabstop(i)
int i;
{       return i + tabamount - (i % tabamount);
}

max(x,y)
int x,y;
{       return (x > y) ? x : y;
}

min(x,y)
int x,y;
{       return (x < y) ? x : y;
}

pushleft(ch)
char ch;
{       if (ch neq null) then
                if (leftindex >= rightindex) then
                        ferr("Stack overflow (left)");
                else textbuf[++leftindex] = ch;
}

popleft()
{       if (leftindex < 1) then return null;
        else return textbuf[leftindex--];
}

pushright(ch)
char ch;
{       if (ch neq null) then
                if (rightindex < leftindex) then
                        ferr("Stack overflow (right)");
                else textbuf[--rightindex] = ch;
}

popright()
{       if (rightindex > textbufsize) then return null;
        else return textbuf[rightindex++];
}

peekleft()
{       if (leftindex < 1) then return null;
        else return textbuf[leftindex];
}

peekright()
{       if (rightindex > textbufsize) then return null;
        else return textbuf[rightindex];
}

leftright()
{       char ch;

        ch = popleft();
        pushright(ch);
        return ch;
}

rightleft()
{       char ch;

        ch = popright();
        pushleft(ch);
        return ch;
}


home()
{       ci = 0;
        cj = 0;
        mvhome();
}

resetc()
{       curpos(ci,cj);
}

linefeed()
{       if (ci < height) then ++ci; 
        else begin
                pluslines();               /* automatically scroll screen */
                ++ci;
        end;
        resetc();
}

carrtn()
{       cj = 0;
        linefeed();
}

cursup()
{       if (ci > 0) then --ci;
        resetc();
}

cursrt()
{       if (cj < width) then ++cj;
        resetc();
}

curslf()
{       if (cj > 0) then --cj;
        resetc();
}

foutchar(ch)
char ch;
{       if (ch < ' ') then begin        /* check control characters */
                termctrlchar(ch);
        end;
        dtyo(ch);
        if (cj < width) then ++cj;      /* bump to next column or new line */
        else carrtn();
}

ftab()
{       cj = nexttabstop(cj);           /* find next tab stop */
        if (cj > width) then cj = width;
        resetc();
}

fmsg()
{       char mess[256];
	sync();
        sprintf(mess,"[File: %s  Line # %d%s]", 
		curfile[0] eq 0 ? "Not named" : curfile,
		ti - ci,
		eofdis ? " *END*" : "");
        termstatus(mess);
        resetc();
}

ferr(s)
char *s;
{       termstatus(s);
        dtyo(bell);
        resetc();
}

sync()
{       tpos(fi + ci, fj + cj);
}
