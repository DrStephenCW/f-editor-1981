# F editor (nf), UC Irvine, 1981-84

_The text below and the original source was recovered from a dump of a PDP-10 9-track magnetic tape by Claude Opus 5.5 Medium Effort.  The updates and the documentation here were also done by Claude._

A full-screen, keep-the-whole-file-in-memory text editor that Steve Willson
wrote in C for VAX/Unix at UC Irvine in October 1981 ("Halloween" is the date on
its manual), last changed September 1982. It is the fourth editor in a family
that came before it:

1. **F**, by James R. Meehan, in IMP10 and IMP20 for the UCI DEC-10 and DEC-20.
2. A UCSD Pascal version by Stephen Willson and Eric Olsen.
3. **nf**, this C version for VAX/Unix by Stephen Willson. It is called `nf`
   because `f` was already the short name for `finger`, and "NF" (intuitive
   feeling) is a Keirsey-Bates personality type.
4. An Ada transliteration (1983-84) by Frank Tadman, for the UCI Ada
   environment. It is kept under `tadman/` so the credit is plain.

The buffer is a gap buffer, which the manual calls a "left stack" and a "right
stack". The screen is a window you slide over the file like a piece of glass
over paper.

## What's here

| Path | What it is |
|---|---|
| `original/` | Everything from `~willson/feditor` on tape6, byte for byte with 1984 dates: 13 C files, `globals.h`, `Makefile`, `nf.doc` (the manual), `nf` (the VAX a.out binary, not stripped), `trans.bak`, `test.txt` |
| `compat/sgtty.h` | The only new code needed for the C version: the 4.2BSD `gtty`/`stty` raw-mode calls, done with POSIX termios |
| `Makefile` | Builds `nf` from `original/` without changing a line of it |
| `tadman/ada/original/` | Frank Tadman's Ada version as found in `thesis/ada_f` (2,702 lines, plus the UCI `pac` build files) |
| `tadman/ada/src/` | The same Ada version split into GNAT units, with 14 changes, each marked `-- port` |
| `tools/drive.py` | Runs the editor in an 80x24 pseudo-terminal, types keys at it and prints the screen (needs `pip install pyte`) |
| `tools/fixwith.py` | Moves unneeded `with` clauses from Ada specs to bodies (see below) |

## Build and run

```
make            # gcc; makes ./nf
./nf somefile   # TERM must be vt100 (any ANSI terminal will do: xterm, PuTTY, VS Code)
TERM=vt100 ./nf somefile

make ada-f      # needs GNAT (apt install gnat); makes ./ada-f
```

Tested on x86-64 Ubuntu 24.04 with gcc 13 and GNAT 13. `nf` should also build
on the Graviton (ARM64) EC2 instance, since nothing in it depends on word size.

## Keys (nf, vt100 mode)

| Key | Does |
|---|---|
| arrows, ^H ^J ^\ ^^ | move the cursor (down at the bottom scrolls 7 lines) |
| printing keys | overwrite the character under the cursor |
| ^A / ^S | insert a space / delete a character |
| ^D / ^F | insert a line break / delete through the end of the line (into the put buffer) |
| ^K / ^G | pick (copy) a line / put the put buffer back |
| ^R / ^E | search forward / backward |
| ^L / ^Q | page forward / back |
| ^T / ^W | 7 lines forward / back |
| ^O / ^P | start / end of file |
| ^V, ^Y, ^I | end of line, top-left, tab |
| ^B, ^X^B | switch file, rename the file |
| ^U | redraw |
| ^Z | save and exit |
| ^C | quit without saving (asks first) |
| Esc Esc *arg* *command* | give a command an argument: a count, a cursor movement, or text. Esc Esc `fox` ^R searches for "fox"; Esc Esc `hello` ^G inserts "hello" |

A single Esc waits for the next key (it was a VT100 prefix), so use Esc Esc,
or PF4 (Esc O S). The Ada version uses an older key layout: ^K up, ^L right,
^V down, ^J/^M return, and one Esc starts an argument.

## Who did the Ada version

The header of `defs.ada` says the C editor was "Transliterated into ADA and
modified for use in the UCI ADA Environment by Frank Tadman" and "Debugged by
Stephen Willson using Arcturus". The files sat in Stephen's account, in
`thesis/ada_f`. Two 1983 messages from Tadman fit that. On 29 May he wrote "I
see you have a directory called ada_f with the editor split up into files, but
have you done any debugging?" On 13 Aug he wrote "I'm also working on making
your F editor work." So the translation is credited to Tadman, and the
debugging to both of them. The tape doesn't show who split the files into
`ada_f`.

## The changes the Ada version needed

The tape copy is a snapshot from the middle of debugging, which matches Frank
Tadman's mail of 29 May 1983 ("what's the status of the f editor in ada? ...
have you done any debugging?"). Most changes are about the 1984 UCI Ada tools
being more forgiving than a modern compiler. The rest are real bugs.

- Specs `with` each other in a circle (low and move). Arcturus allowed it; GNAT
  does not, so the unused `with` clauses moved to the bodies.
- The UCI `text_io` could `put` an integer; `defs` now has an `int_io` instance.
- `par` reads an `out` parameter, which is illegal in Ada 83, so it builds with `-gnat95`.
- `call_csh` was a stub, so `stty` never ran. It now calls `system()`, and the
  mode is `raw` rather than `cbreak`, because in cbreak mode ^Z suspends the editor.
- `display` printed only spaces, counted them up rather than down, and never
  moved past text outside the window. It was re-nested to match `display.c`.
- `writefile` wrote the file to the screen instead of to the file.
- File names are 255-character strings padded with NULs, so `open` gets a slice.
- The file name now comes from the command line.

Known leftovers in the Ada version: the buffer is only 1,000 characters, it adds
one blank line at the end of the file when it saves, and it strips the high bit
with `mod 127` (so DEL becomes NUL).

## Credits

Text and code by Stephen Willson, Department of Information and Computer
Science, UC Irvine. Command set from James R. Meehan's F. UCSD Pascal version
with Eric Olsen. Ada version by Frank Tadman. The manual's own terms: "This
editor may be distributed without restriction, so long as credit is given to the
author, the Programming Environments Project, and the Department of Information
and Computer Science at the University of California at Irvine."

## Addendum
(This part written by Stephen.)
There was a company called Dayflo that created a very early version of a Hypertext system.
The product had the same name.  At the time, it had the largest funding of any software
startup in Orange County, CA.  Something like $10M!  That was a fortune back then!

Well, this one time, at band camp, they called me up to do some
consulting on a project they were making - some kind of database.  They were having trouble
with the front end editor.  So I show up and I'm looking at the code and it is kind of strange
but it eventually dawns on me that this is in fact a derivative of the C version of the F
editor I had written (documented here).  The programmers there didn't understand how the two stacks worked
and had all kinds of hacks to track locations in the text.  All you needed was "distance from
start" or "distance from end"; and it was easy to swap between these as the focus of the
editor moved around.  So I refactored all that to work correctly.

At nearly the same time they hired a woman as a permanent employee to 'own' the editor
going forward.  I taught her how the architecture was supposed to work and we
collaborated together on cleaning the thing up.  Ah, um, er,
we became "not just friends," and later got married, and we're still married.
