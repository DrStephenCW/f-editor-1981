#include "globals.h"

callshell()                     /* send put buffer contents to a shell */
                                /* dumb sh for now */
{       char buff[256];         /* maximum of 255 characters */
        int i;
        cj  _ 0;                /* read from beginning of line */
        sync();                   
        pick(1,0,true);
        buff[0] _ ' ';          /* buff[0] not used */
        for (i _ 1; i <= putbufindex and i < 255 and putbuf[i] neq cr; i++)
                buff[i] _ putbuf[i];
        buff[i] _ 0;            /* from post increment */
        endterm();              /* back to cooked mode */
        ferr(buff);             /* print command for reference */
        if (system(buff)) then ferr("Error status non-zero from shell");
        else fmsg();
        initterm();             /* back to raw mode */
}
