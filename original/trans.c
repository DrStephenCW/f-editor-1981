#include "globals.h"
/* F editor - character translation routine */

enum comtype translate(ch)
char ch;

{
    if ((ch >= ' ') & (ch <= '~')) return comchar;
    /* printing character */
    else if (ch eq rubout) return combk;
    /* treated eq to backspace */
    else if ((ch >= 0) and (ch <= 31)) then
        switch (termtype) {
    case colorscan10: 
        {
            switch (ch + '@') {
            case 'A': 
                return cominspac;
            case 'B': 
                return comsetfil;
            case 'C': 
                return cominterrupt;
            case 'D': 
                return cominslines;
            case 'E': 
                return combser;
            case 'F': 
                return comdelines;
            case 'G': 
                return comput;
            case 'H': 
                return combk;                       
            case 'I': 
                return comtab;
            case 'J': 
                return comlf;
            case 'K': 
                return compick;
            case 'L': 
                return comforpage;
            case 'M': 
                return comrtn;
            case 'N': 
                return comknock;
            case 'O': 
                return comgotost;
            case 'P': 
                return comeof;
            case 'Q': 
                return combkpage;
            case 'R': 
                return comfser;
            case 'S': 
                return comdelspac;
            case 'T': 
                return complulines;
            case 'U': 
                return comredraw;
            case 'V': 
                return comeol;
            case 'W': 
                return comminlines;
            case 'X': 
                {
                    ch = dtyi();  /* extra function key follows control-x */
                    switch(ch + '@') {
                    case 'B': 
                        return comrename;
                    default : 
                        return comerror;
                    }       /* end switch for control-x */
                }       /* end case 'X' */
            case 'Y': 
                return comhome;
            case 'Z': 
                return comexit;
            case '\\': 
                return comrt;
            case '_': 
                return comup;
            case '^': 
                return comup;
            case '[': 
                { 
                    ch = dtyi();   /* command char follows esc */
                    switch(ch) {                          
                    case 'A': 
                        return comup; /* vt52 */
                    case 'B': 
                        return comlf; /* vt52 */
                    case 'C': 
                        return comrt; /* vt52 */
                    case 'D': 
                        return combk;	/* vt52 */
                    case 'H': 
                        return comhome; /* vt52 */
                    case '[': 
                        {
                            ch = dtyi();	/* something like esc [ ch */
                            switch(ch) {
                            case 'A': 
                                return comup;	/* vt100 keys */
                            case 'B': 
                                return comlf;
                            case 'C': 
                                return comrt;
                            case 'D': 
                                return combk;
                            default : 
                                return comerror;
                            }	/* end switch for esc [ ... */
                        }	/* end case '[' */
                    case 'O': 
                        {
                            ch = dtyi();	/* something like esc O ch */
                            switch(ch) {
                            case 'S': 
                                return comesc;		/* pf4 */
                            case 'P': 
                                return comrevscroll;	/* pf1 */
                            case ' ': 
                                return comnull;  /* for correcting accidental esc's */
                            default : 
                                return comerror;
                            }	/* end switch esc O ... */
                        }	/* end case 'O' */
                    }   /* end switch for esc */
                case '[' - '@': 
                    return comesc;  /* two escapes = one normal esc */
                }       /* case esc */
            default: 
                return comerror;
            }       /* end switch on control characters */
        }  /* end case colorscan10 */

    case datamedia: 
        {
            switch (ch + '@') {
            case 'A': 
                return cominspac;
            case 'B': 
                return comsetfil;
            case 'C': 
                return cominterrupt;
            case 'D': 
                return cominslines;
            case 'E': 
                return combser;
            case 'F': 
                return comdelines;
            case 'G': 
                return comput;
            case 'H': 
                return combk;                       
            case 'I': 
                return comtab;
            case 'J': 
                return comlf;
            case 'K': 
                return compick;
            case 'L': 
                return comforpage;
            case 'M': 
                return comrtn;
            case 'N': 
                return comknock;
            case 'O': 
                return comgotost;
            case 'P': 
                return comeof;
            case 'Q': 
                return combkpage;
            case 'R': 
                return comfser;
            case 'S': 
                return comdelspac;
            case 'T': 
                return complulines;
            case 'U': 
                return comredraw;
            case 'V': 
                return comeol;
            case 'W': 
                return comminlines;
            case 'X': 
                {
                    ch = dtyi();  /* extra function key follows control-x */
                    switch(ch + '@') {
                    case 'B': 
                        return comrename;
                    default : 
                        return comerror;
                    }       /* end switch for control-x */
                }       /* end case 'X' */
            case 'Y': 
                return comhome;
            case 'Z': 
                return comexit;
            case '\\': 
                return comrt;
            case '_': 
                return comup;
            case '^': 
                return comup;
            case '[': 
                return comesc;
            default: 
                return comerror;
            }       /* end switch on control characters */
        } /* end case datamedia */

    case heath19: 
        {

            switch (ch + '@') {
            case 'A': 
                return cominspac;
            case 'B': 
                return comsetfil;
            case 'C': 
                return cominterrupt;
            case 'D': 
                return cominslines;
            case 'E': 
                return combser;
            case 'F': 
                return comdelines;
            case 'G': 
                return comput;
            case 'H': 
                return combk;                       
            case 'I': 
                return comtab;
            case 'J': 
                return comlf;
            case 'K': 
                return compick;
            case 'L': 
                return comforpage;
            case 'M': 
                return comrtn;
            case 'N': 
                return comknock;
            case 'O': 
                return comgotost;
            case 'P': 
                return comeof;
            case 'Q': 
                return combkpage;
            case 'R': 
                return comfser;
            case 'S': 
                return comdelspac;
            case 'T': 
                return complulines;
            case 'U': 
                return comredraw;
            case 'V': 
                return comeol;
            case 'W': 
                return comminlines;
            case 'X': 
                {
                    ch = dtyi();  /* extra function key follows control-x */
                    switch(ch + '@') {
                    case 'B': 
                        return comrename;
                    default : 
                        return comerror;
                    }       /* end switch for control-x */
                }       /* end case 'X' */
            case 'Y': 
                return comhome;
            case 'Z': 
                return comexit;
            case '\\': 
                return comrt;
            case '_': 
                return comup;
            case '^': 
                return comup;
            case '[': 
                { 
                    ch = dtyi();   /* command char follows esc */
                    switch(ch) {                          
                    case '@': 
                        return comsic;
                    case 'A': 
                        return comup; 
                    case 'B': 
                        return comlf; 
                    case 'C': 
                        return comrt; 
                    case 'D': 
                        return combk;
                    case 'H': 
                        return comhome;
                    case 'L': 
                        return comsil;
                    case 'M': 
                        return comsdl;
                    case 'N': 
                        return comsdc;
                    case 'O': 
                        return comsic;
                    case 'S': 
                        return comesc;
                    case 'T': 
                        return combreak;      /* f2 */
                    case 'U': 
                        return comunbreak;    /* f3 */
                    case 'V': 
                        return comrdwline;    /* f4 */
                    case 'W': 
                        return comrevscroll;  /* f5 */
                    case ' ': 
                        return comnull;  /* for correcting accidental esc's */
                    case '[' - '@': 
                        return comesc;  /* two escapes = one normal esc */
                    default:
                        return comerror;
                    }       /* end switch for '[' */
                }       /* case '[' */
            default: 
                return comerror;
            }       /* end switch on control characters */
        } /* end case heath19 */
    } /* end switch termtype */
}       /* end translate */




