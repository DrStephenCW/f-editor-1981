#include "globals.h"
#include <stdio.h>
                /* F editor - file input and output routines */

boolean writefile();

intobuf(ch)
char ch;
{       if (ch eq cr) then begin
                ++ti;
                tj = 0;
        end
        else if (ch eq tab) then begin int t;
                t = nexttabstop(tj);
                for (    ; tj < t; tj++) pushleft(' ');
                return;
        end
        else ++tj;
        pushleft(ch);
}

boolean readfile()
{       FILE *fil, *fopen();
        int ch;
        int numchars;
        numchars = 0;
        emptystacks();
        strcpy(lastfile,curfile);       /* remember name of last file */
        strcpy(curfile,newfile);        /* save name of desired file */
                                        /* O.K. if file not named */
                                        /* or doesn't exist */
        if (curfile[0] eq null) then return false;
        if ((fil = fopen(curfile,"r")) eq null) then return false;
                                        /* leave file empty */
        while ((ch = getc(fil)) neq EOF) begin
                if (ch eq lf) then intobuf(cr);
                else intobuf(ch);
                ++numchars;
        end;
        fclose(fil);            
        tpos(0,0);                      /* jump to beginning of file */
        return true;
}

lftocr(ch)
char ch;
{       if (ch eq cr) then return lf;
        else return ch;
}

boolean writefile()
{       FILE *fil,*fopen();
        int i;

        if (not changed) then return true;

        i = strlen(curfile);
        if (i eq 0) then begin
                ferr("File not named");
                return false;
        end;

        if ((fil = fopen(curfile,"w")) eq null) then begin
                ferr("Can't open file for writing");
                return false;
        end;

        for (i = 1; i <= leftindex; i++) 
                        putc(lftocr(textbuf[i]),fil);
        for (i = rightindex; i <= textbufsize; i++) 
                        putc(lftocr(textbuf[i]),fil);

                                /* make sure cr at end of file */
        if (rightindex <= textbufsize) then begin
                if (textbuf[textbufsize] neq cr) then putc(lf,fil); 
        end
        else if (textbuf[leftindex] neq cr) then putc(lf,fil);

        fclose(fil);
        return true;
}





                                
