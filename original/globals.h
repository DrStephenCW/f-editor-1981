        /* F editor for Vax/Unix by Stephen Willson */
        /* Based on other editors at UCI with the same name */

        /* Global definitions */


#define true 1                  /* language extensions */
#define false 0
#define boolean char
#define then
#define begin {
#define end }
#define repeat do {
#define until(whilearg) } while (!(whilearg));
#define and &&
#define or ||
#define not !
#define eq ==
#define neq !=
#define _ =

#define tabamount 8             /* terminal characteristics */
#define null 0
#define cr 13
#define controlx 24
#define controlz 26
#define bell 7
#define backspace 8
#define lf 10
#define tab 9
#define rubout 127
#define esc 27

#define putbufsize 50000        /* editing buffer sizes */
#define textbufsize 100000
#define filensize 255           /* space for file name */
                                                         
enum terminal {badterm, colorscan10, datamedia, heath19};
enum comtype {comerror,         /* unknown command */
        comnull,                /* command that does nothing */
        comshell,               /* pass put buffer to shell */
        comrevscroll,           /* smart minus scroll 1 line */
        cominspac,              /* insert a space, normal f */
        comdelspac,             /* delete a space, normal f */
        comsetfil,              /* edit different file */
        cominslines,            /* insert lines, normal f */
        comdelines,             /* delete lines, normal f */
        compick,                /* save lines in put buffer */
        comput,                 /* copy lines from put buffer to edit buff */
        comtab,                 /* move to next tab stop on screen */
        comrtn,                 /* move to start of next line on screen */
        comlf,                  /* move down one line on screen */
        comup,                  /* move up one line on screen */
        combk,                  /* move back one character on screen */
        combser,                /* search backwards in buffer */
        comhome,                /* move cursor to home position on screen */
        comres,                 /* reset position of cursor on screen */
        comchar,                /* enter character into buffer */
        comredraw,              /* redraw screen on terminal */
        comeof,                 /* move window to end of file */
        comeol,                 /* move cursor to end of line on screen */
        comknock,               /* accept next character as is */
        comexit,                /* exit editor */
        cominterrupt,           /* interrupt current mode */
        comesc,                 /* go into parameter parsing mode */
        comfser,                /* search forward in buffer */
        complulines,            /* move window down by lines */
        comminlines,            /* move window up by lines */ 
        comrt,                  /* move cursor right on character on screen */
        comgotost,              /* move window to start of buffer */
        comforpage,             /* move window forward by pages */
        combkpage,              /* move window back by pages */
        cominfo,                /* print information about buffers */
        comrename,              /* rename current buffer */
        comsil,                 /* smart insert line */
        comsdl,                 /* smart delete line */
        comsic,                 /* smart insert character */
        comsdc,                 /* smart delete character */
        comrdwline,             /* redraw current line */
        combreak,               /* break a line in two */
        comunbreak};            /* delete up to and including next cr */

	enum terminal termtype;
        boolean screwed;                /* put buffer overflowed */
        char curfile[filensize];        /* current filenames */
        char deffile[filensize];        /* default file */
        char newfile[filensize];        /* next file to edit */
        char lastfile[filensize];       /* next file we edited */
        int height;                     /* current screen dimensions */
        int width;
        int leftindex;                  /* stack pointers */
        int rightindex;
        char defsearch[80];             /* current search string */
        int defspace;                   /* arguments to commands */
        int deflines;
        int defsxl;
        int defpages;
        int defslide;                   /* no longer used */
        int defpluslines;
        int defpick;
        int defsxp;
        int saveci,savecj;              /* globals for moving routines */
                                        /* below: i for height; j for width */
        int ci;                         /* current cursor position on screen */
        int cj;
        int fi;                         /* address of top-left of screen */
        int fj;
        int ti;                         /* current spot in file */
        int tj;
        boolean enters;                 /* hit <enter> ? */
        boolean changed;                /* file has been modified? */
        char param[255];                /* parameter characters */
        int putbufindex;                /* end of put buffer contents */
        boolean eofdis;                 /* at end of file if true */
        char textbuf[textbufsize + 20]; /* actual editing buffer */
        char putbuf[putbufsize + 20];   /* deletion save buffer */
        int slow;                       /* indicates height if nonzero */
        int initial_r;                  /* initial row to put window */
        int initial_c;                  /* initial column */
        char *err_mess;                 /* -e option for Ada env */
        int lastpick;                   /* size of last pick operation */
                                        /* in lines (bug introduced by */
                                        /* resetting the args after */
                                        /* each command) */
	boolean control_s_bug;          /* true if terminal is too slow */
					/* and sends control-s and control-q */


