#include <stdio.h>
#include <sgtty.h>
#include "globals.h"
                /* F editor - terminal handler */

struct sgttyb termfix;
struct sgttyb oldterm;

char dtyi()             /* assumes raw mode */
{       int ch;
        ch = getchar() & 0177;  /* remove parity */
        return ch;
}                                 

dtyo(ch)                /* assumes raw mode */
char ch;
{       putchar(ch);
}

int LINES;		/* number of lines for window - 1 */
int COLS;		/* number of columns for window - 1 */

change_to_raw_mode()
{
        gtty(0,&oldterm);
        termfix = oldterm;      /* structure copy! */
        termfix.sg_flags &= ~ECHO;
        termfix.sg_flags |= RAW;
        stty(0,&termfix);
}

initterm()
{       
  switch (termtype) {
    case badterm:
	printf("Unknown terminal type\n");
	exit(0);
	break;
    case colorscan10:
	LINES _ 22;
	COLS _ 79;
	change_to_raw_mode();
        height _ slow ? slow : LINES;
        width _ COLS - 1; 
        control_s_bug = true;   /* terminal sends ctrl-s/q */
        printf ("\033<\033[r\033[?4l\033[?6l\033[2J");
                                /* reset everything */
	printf("\033[1;23r");	/* scrolling region 1 => 23	*/
        break;
    case datamedia: 
	LINES _ 22;
	COLS _ 79;
	change_to_raw_mode();
        height _ slow ? slow - 1 : LINES;
        width _ COLS; 
        break;
    case heath19: 
	LINES _ 23;
	COLS _ 79;
	change_to_raw_mode();
        height _ slow ? slow - 1 : LINES;
        width _ COLS; 
        printf("%c%c%c",esc,'x','6');  /* keypad shifted */
	break;
  } /* end switch */
}

endterm()
{       
  switch (termtype) {
    case colorscan10: 
        printf ("\033[r"); 	/* reset scrolling region */
        curpos(LINES + 1,0);
        clearline();
        stty(0,&oldterm);
	break;
    case datamedia: 
        stty(0,&oldterm);
	termstatus("");
	curpos(LINES,0);
	clearline();
	break;
    case heath19: 
        stty(0,&oldterm);
        termstatus("");
        curpos(LINES,0);
        clearline();
	break;
  }
}

clearline()
{  switch (termtype) {
    case colorscan10: 
        printf("\033[K");
	break;
    case datamedia:
        dtyo(29);
	break;
    case heath19:
	dtyo(esc); dtyo('K');
	break;
   }
}


cleareop()
{ switch(termtype) {
    case colorscan10:
        printf("\033[J");
	break;
    case datamedia:
        dtyo(11); 
	break;
    case heath19:
        dtyo(esc); dtyo('J'); 
	break;
  }
}                     

curpos(r,c)
int r,c;  
{       
  switch(termtype) {
    case colorscan10:
	printf("\033[%d;%dH",r+1,c+1);
	break;
    case datamedia:
	dtyo(30);
        dtyo(c+32);
	dtyo(r+32);
	break;
    case heath19:
        dtyo(esc); dtyo('Y'); 
        dtyo(r+32);
        dtyo(c+32);
	break;
  }
}

clearpage()
{ switch(termtype) {
    case colorscan10:
        mvhome();
        cleareop();
	break;
    case datamedia:
	dtyo(12);
	break;
    case heath19:
        dtyo(esc); dtyo('E'); 
	break;
  }
}

mvhome()
{
  switch(termtype) {
    case colorscan10:
        printf("\033[0;0H");
	break;
    case datamedia:
	dtyo(25);
	break;
    case heath19:
        dtyo(esc); dtyo('H'); 
	break;
  }
}

termil()
{
  switch(termtype) {
    case colorscan10:
        ferr("No smart insert line");
	break;
    case datamedia:
	ferr("No smart insert line");
	break;
    case heath19:
        dtyo(esc); dtyo('L');
	break;
  }
}

termdl()
{
  switch(termtype) {
    case colorscan10:
        ferr("No smart delete line");
	break;
    case datamedia:
        ferr("No smart delete line");
	break;
    case heath19:
        dtyo(esc); dtyo('M');
	break;
  }
}

termic()
{
  switch(termtype) {
    case colorscan10:
        ferr("No smart insert character");
	break;
    case datamedia:
        ferr("No smart insert character");
	break;
    case heath19:
        dtyo(esc); dtyo('@');
        dtyo(' '); dtyo(esc);
        dtyo('O');
  	break;
  }
}

termdc()        
{
  switch(termtype) {
    case colorscan10:
        ferr("No smart delete character");
	break;
    case datamedia:
        ferr("No smart delete character");
	break;
    case heath19:
        dtyo(esc); dtyo('N');
	break;
  }
}

termscroll(n)
int n;
{
  switch (termtype) {
    case colorscan10:
        curpos(LINES,0);
        for ( ; n > 0; n--) dtyo(lf);
	break;
    case datamedia:
        curpos(LINES + 1,0);
        for ( ; n > 0; n--) dtyo(lf);
	break;
    case heath19:
        curpos(LINES,0);
        for ( ; n > 0; n--) dtyo(lf);
	break;
  }
}

termrevscroll(n)
int n;
{
  switch(termtype) {
    case colorscan10:
        curpos(0,0);
        for (; n > 0; n--)
		printf("\033M");
	break;
    case datamedia:
	ferr("No reverse scroll");
	break;
    case heath19:
        curpos(0,0);
        for (; n > 0; n--) {
                dtyo(esc);
                dtyo('I');
        }
	break;
  }
}

termstatus(s)
char *s;
{
  switch(termtype) {
    case colorscan10:
        curpos(LINES + 1, 0);
        printf("%s",s);
        clearline();
        curpos(0,0);
	break;
    case datamedia:
	curpos(LINES + 1,0);
	printf("%s",s);
	clearline();
	curpos(0,0);
	break;
    case heath19:
        dtyo(esc);
        dtyo('x');
        dtyo('1');
        curpos(LINES + 1,0);
        printf("%s",s);
        clearline();
        curpos(0,0);
	break;
  }
}

termctrlchar(c)
char c;
{       dtyo(bell);
        dtyo(c + '@');
}

