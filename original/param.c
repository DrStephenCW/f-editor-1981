#include "globals.h"
                /* F editor - Parameter Parsing */

enum comtype translate();

badparam(s)
char *s;

{
        char mess[256];
	sprintf(mess,"Illegal parameter for %s",s);
        termstatus(mess);
        ci = saveci;
        cj = savecj;
        display(ci,ci,cj);
        resetc();
}       /* end badparam */

readint(param,notnum)
char *param;
int *notnum;    /* ref parameter */

{
        int num;
        int sflag;
        int pix;

        *notnum = true;
        sflag = false;
        num = 0;
        if (strlen(param) >= 1) then begin

                if (strlen(param) >= 2)
                        if (param[0] eq '-') then begin
                                sflag = true; 
                                ++param;
                        end;

                for (     ; *param; ++param)
                        if ((*param >= '0') && (*param <= '9'))
                                num = (num * 10) + (*param - '0');
                        else return 0;

                *notnum = false;
        end;

        if (sflag) num = - num;

        return num;

}       /* end readint */

enum comtype readparam()

{
        char ch;
        boolean cm;             /* cursor movement seen */
        boolean cs;             /* argument is text */
        boolean done;           /* command seen; stop reading param */
        enum comtype command;
        int pix;

        pix = 0;                /* init parameter value to none */
        param[pix] = null;
        done = false;           /* no movement seen of either kind */
        cm = false;
        cs = false;

        while (not done) begin
                ch = dtyi();    /* get next parameter character */
                command = translate(ch);        /* convert to symbol */
                if ((command eq comesc) or      /* check if one those ok */
                    (command eq comchar) or     /* in a parameter */
                    (command eq comlf) or
                    (command eq comup) or
                    (command eq combk) or
                    (command eq comrtn) or
                    (command eq comrt) or
                    (command eq comtab)) then begin
                        if ((cm and (command eq comchar)) or
                            (cs and not ((command eq comchar) or
                                         (command eq combk)))) then begin
                                badparam("mixed parameter modes");
                                return comnull;
                        end;
                        switch(command) {
                        case comchar: 
                                foutchar(ch); 
                                param[pix++] = ch; 
                                cs = true; 
                                break;
                        case comesc: 
                                foutchar('*'); 
                                cm = true; 
                                break;
                        case comlf: 
                                linefeed(); 
                                cm = true; 
                                break;
                        case combk: 
                                if (cs) then begin
                                        dtyo(backspace); 
                                        dtyo(' '); 
                                        dtyo(backspace);
                                        if (pix > 0) param[--pix] = null;
                                end
                                else begin
                                        cm = true; 
                                        curslf();
                                end;
                                break;
                        case comrtn: 
                                carrtn(); 
                                cm = true; 
                                break;
                        case comup: 
                                cursup(); 
                                cm = true; 
                                break;
                        case comrt: 
                                cursrt(); 
                                cm = true; 
                                break;
                        case comtab: 
                                ftab(); 
                                cm = true; 
                                break;
                        }       /* end switch */
                }       /* end if command = ... */
                else done = true;
        } /* end while */
        param[pix] = null;
        return command;  
}       /* end readparam */
                        
cvt(lines,spaces,wantlines,wasnum)
int *lines,*spaces;
int wantlines;
int *wasnum;

{
        boolean nogood;
        int result;

        *spaces = 0;
        *lines = 0;
        result = readint(param,&nogood);
        *wasnum = not nogood;
        if (nogood) then begin
                *lines = ci - saveci;
                if (*lines eq 0) then *spaces = cj - savecj;
                else *spaces = cj;      
        end
        else if (wantlines) then *lines = result;
        else *spaces = result;
}       /* end cvt */    


enum comtype setparam(command)        
enum comtype command;

{
        int wom;
        int i;
        boolean wasnum;             

        switch(command) {
        case cominspac:
        case comdelspac:              
                cvt(&wom,&defspace,false,&wasnum);
                if ((defspace <= 0) or (wom neq 0)) then begin
                        defspace = 1; 
                        badparam("insert/delete spaces");
                end;
                break;
        case complulines:
        case comminlines:
                cvt(&defpluslines,&wom,true,&wasnum);
                if (defpluslines <= 0) then begin
                        defpluslines = 1;
                        badparam("plus/minus lines");
                end;
                break;
        case comfser:
        case combser:
                if (param[0] neq null) then strcpy(defsearch,param);
                else ferr("No search string specified");
                break;
        case cominslines:
        case comdelines:            
                cvt(&deflines,&defsxl,true,&wasnum);
                if ((deflines < 0 ) or (defsxl < 0)) then begin
                        deflines = 1; 
                        badparam("insert/delete spaces");
                end;
                break;
        case compick:
                cvt(&defpick,&defsxp,true,&wasnum);
                lastpick = defpick;     /* bug fix (see globals.h) */
                if ((defpick < 0) or (defsxp < 0)) then begin
                        defpick = 1; 
                        badparam("pick up lines");
                end;
                resetc();
                display(ci,ci,cj);
                break;
        case comput:
                if (param[0] eq null) then ferr ("Can't put empty string");
                else {
                        int i;
                        for (i = 0; i < strlen(param); ++i)
                                putbuf[i+1] = param[i];
                        defpick = 0;
                        lastpick = defpick;     /* bug fix (see globals.h) */
                        defsxp = strlen(param);
                        putbufindex = defsxp;
                }
                break;
        case combkpage:
        case comforpage:
                cvt(&defpages,&wom,true,&wasnum);
                if ((defpages <= 0) or not wasnum) then begin
                        defpages = 1;
                        badparam("plus/minus pages");
                end;
                break;
        case comeol: 
                badparam("eol parameter is always 1"); 
                break; 
        case comredraw:
                cvt(&wom,&defslide,false,&wasnum);
                break;
        case comsetfil:
                cvt(&wom,&wom,false,&wasnum);
                if (wasnum) then badparam("set file");
                strcpy(newfile,param);
                break;
        case cominterrupt: 
                /* return cominterrupt;  */
                break;          
        case combreak:
        case comunbreak:     
        case comsic:
        case comsdc:
        case comsil:
        case comsdl:
        case comrdwline:
                break;
        default:break;
        }       /* end switch */
}       /* end setparam */

enum comtype paramode()

{       
        enum comtype command;

        saveci = ci;            /* save current cursor position */
        savecj = cj;

        enters = true;          /* the arg key was pressed */

        foutchar('*');          /* prompt signals parameter mode */

        command = readparam();  /* "parse" a command */

        if (command eq cominterrupt) then begin
                ci = saveci;    /* command was aborted */
                cj = savecj;    /* restore cursor position */
                resetc();
                display(ci,ci,cj);      /* clean up any characters */
                enters = false;         /* pretend param mode never entered */
                return comnull;
        end;
        setparam(command);      /* translate according to what each */
        ci = saveci;            /* command expects */
        cj = savecj;
        return command;
}       /* end paramode */


                              
