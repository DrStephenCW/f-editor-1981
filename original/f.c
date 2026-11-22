#include <stdio.h>
#include "globals.h"


        /* F editor for Vax/Unix by Stephen Willson */
        /* Department of Information and Computer Science, UC Irvine */
        /* October 1981 */


char *getenv();
enum terminal scanterm();


main(argc,argv)
int argc;
char *argv[];
{       
	{   char *t = getenv("TERM");
	    termtype = scanterm(t);
	}
        while(argc > 1 && argv[1][0] == '-') {
            switch(argv[1][1]) {
                case 'h':               /* height option */
                case 'H':
                        slow = scanint(&argv[1][2]);
                        break;          /* slow terminal; use small screen */
                case 'r':
                case 'R':
                        initial_r = scanint(&argv[1][2]);
                        break;          
                case 'c':
                case 'C':
                        initial_c = scanint(&argv[1][2]);
                        break;          
                case 'e':
                case 'E':
                        err_mess = &argv[1][2];
                        break;
		case 't':
		case 'T':
			termtype _ scanterm(&argv[1][2]);
			break;
                default:
                        printf("illegal flag '%c'\n", argv[1][1]);
            }
            argc--;
            argv++;
        }
        if (argc > 1) then strcpy(newfile, argv[1]);
        else newfile[0] = null;
	if (termtype == badterm) {
	  printf("Unknown terminal type\n");
	  exit(1);
	}
        fedit();        /* this never returns */
}

scanint(p)                      /* translate string to integer (sbw) */
char *p;
{
        register int n = 0;
        register char ch;

        while(ch = *p++)  
                n = n*10 + ch - '0';
        return(n);
}

test(p, q)
char *p, *q;
{	return strcmp(p, q) == 0;
}

enum terminal scanterm(p)
char *p;
{
	if (test(p, "CS10")) return colorscan10;
	else if (test(p, "cs10")) return colorscan10;
	else if (test(p, "vt100")) return colorscan10;
	else if (test(p, "heath")) return heath19;
	else if (test(p, "h19")) return heath19;
	else if (test(p, "dm1521")) return datamedia;
	else if (test(p, "dm1520")) return datamedia;
	else return badterm;
}

