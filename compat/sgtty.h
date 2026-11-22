/* sgtty.h -- the 4.2BSD gtty/stty calls that term.c uses, done with
   POSIX termios.  RAW is mapped to cfmakeraw(), which, like BSD RAW
   mode, turns off line editing, signals, flow control and output
   processing.  ECHO is handled by clearing it from the flags word. */
#ifndef COMPAT_SGTTY_H
#define COMPAT_SGTTY_H
#include <termios.h>
#include <unistd.h>
enum { T_ECHO = ECHO, T_ECHONL = ECHONL };
#define ECHO_F 0x08
#define RAW_F  0x20
#undef ECHO
#define ECHO ECHO_F
#define RAW  RAW_F
struct sgttyb { int sg_flags; struct termios t; };
static int gtty(int fd, struct sgttyb *p)
{ int r = tcgetattr(fd, &p->t); p->sg_flags = ECHO_F; return r; }
static int stty(int fd, struct sgttyb *p)
{ struct termios t = p->t;
  if (p->sg_flags & RAW_F) cfmakeraw(&t);
  if (!(p->sg_flags & ECHO_F)) t.c_lflag &= ~(T_ECHO|T_ECHONL);
  return tcsetattr(fd, TCSADRAIN, &t); }
#endif
