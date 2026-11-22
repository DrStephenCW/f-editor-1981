#include <stdio.h>
#include "globals.h"
                /* F editor - top level control */

defargs()                       /* define default arguments */
{       defspace = 1;           /* this was done to imitate the */
        deflines = 1;           /* way the Z editor works */
        defsxl = 0;             /* This is called after every command */
        defpages = 1;
        defpluslines = height / 2;
        defslide = 40;
        defpick = 1;
        defsxp = 0;
        defsxl = 0;
}

finit()
{       defargs();              /* set arguments to default settings */
        enters = false;         /* nobody could have entered a parameter */
        lastpick = 1;           /* bug fix (see globals.h) */
        defsearch[0] = null;    /* no search string */
        eofdis = false;         /* not at end of file */
        putbufindex = 0;        /* nothing in put buffer */
        emptystacks();
        lastfile[0] = null;     /* don't know name of last file */
}

emptystacks()
{
        ti = tj = fi = fj = ci = cj = 0;       /* start at beginning of file */
        leftindex = 0;
        rightindex = textbufsize + 1;
}

chprocess(ch)
char ch;
{       defargs();              /* default arguments like in Z */
        enters = false;         /* param not entered (yet) */
	fflush(stdout);		/* make sure screen is accurate */
        typein(ch);             /* take action for each character */
}

fedit()
{       int error_line;         /* typically -r is used by Ada env */
        finit();                /* first time - initialization */
        if (not readfile()) then ;      /* nothing */  
                                /* attempt to read file - don't save old */
        initterm();             /* switch to raw input/output mode */
        if (initial_r || initial_c) then begin     
                fi += (initial_r / height) * height;
                                /* integer arithmetic! */
                ci = initial_r % height;
                cj = initial_c;
        end;
        clearpage();
        display(0,height,0);    /* display page from file */
        if (err_mess) then begin
                /* print -e option message */
                termstatus(err_mess);
                resetc();
        end
        else fmsg();    /* print silly message at bottom */
        while (true) chprocess(dtyi()); /* edit file */
                        /* never returns! */
}










