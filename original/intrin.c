#include "globals.h"
/*              F editor - very low level byte moving routines */

moveleft(src, dest, len)
register char *src, *dest;
register int len;
{       register int i;
        for (i = 0; i < len; i++) then begin
                *dest = *src;
                dest++;
                src++;
        end;
}

moveright(src, dest, len)
register char *src, *dest;
register int len;
{       register int i;
        dest += len;
        src += len;
        for (i = 0; i < len; i++) then begin
                dest--;
                src--;
                *dest = *src;
        end;
}

scaneq(amount,ch,src)
register int amount;
register char ch, *src;
{       register int i;
        i = amount;
        if (i eq 0) then return 0;
        if (i > 0) then begin
                for (i = 0; ((i < amount) and (src[i] neq ch)); i++) ;
                return i;
        end else begin
                for (i = 0; ((i > amount) and (src[i] neq ch)); i--) ;
                return i;
        end;
}
