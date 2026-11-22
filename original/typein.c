#include "globals.h"
                /* F editor - typein routine */

#define modified changed = true

enum comtype translate();
enum comtype paramode();

typein(ch)
char ch;
{

        enum comtype command;

        command = translate(ch);
        if (command eq comesc) then command = paramode();

        switch(command) {
case comnull: break;
case comshell: callshell(); break;
case cominspac: modified; addspace(); break;
case comdelspac: modified; deletespaces(); break;
case comsetfil: setfile(); break;
case comrename: renamefile(); break;
case cominslines: modified; addlines(); break;
case comdelines: modified; deletelines(); break;
case compick: pickup(); break;
case comput: modified; putback(); break;
case comtab: ftab(); break;
case comrtn: carrtn(); break;
case comlf: linefeed(); break;
case comup: cursup(); break;
case combk: curslf(); break;
case comrt: cursrt(); break;
case comforpage: pluspages(); break;
case combkpage: backpages(); break;
case complulines: pluslines(); break;
case comminlines: minuslines(); break;
case comfser: searchforward(); break;
case combser: searchbackward(); break;
case comhome: home(); break;
case comres: resetc(); break;
case comchar: modified; fputchar(ch); foutchar(ch); break;
case comredraw: redraw(); break;
case comgotost: gotostart(); break;
case comknock: modified; knockdown(); break;
case comerror: ferr("Unknown command"); break;
case comexit: fexit(); break;
case cominterrupt: interruptexit(); break;
case comeol: eolplease(); break;
case comeof: gotoend(); break;
case comsil: modified; sil(); break;
case comsdl: modified; sdl(); break;
case comsic: modified; sic(); break;
case comsdc: modified; sdc(); break;
case comrdwline: display(ci,ci,0); break;
case combreak: modified; inscr(); break;
case comunbreak: modified; rmvcr(); break;
case comrevscroll: srevscroll(); break;
default: ferr("Bug in typein");
                }       /* end switch */
}       /* end typein */
 
