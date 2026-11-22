# drive.py BIN FILE KEYS... : run nf in an 80x24 pty, send keys, print screen
import os, pty, sys, time, select, pyte, codecs
binp, fil = sys.argv[1], sys.argv[2]
keys = [codecs.decode(k, 'unicode_escape') for k in sys.argv[3:]]
scr = pyte.Screen(80, 24); st = pyte.ByteStream(scr)
pid, fd = pty.fork()
if pid == 0:
    os.environ['TERM'] = 'vt100'
    os.execv(binp, [binp, fil])
import fcntl, termios, struct
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack('HHHH', 24, 80, 0, 0))
def pump(t=0.4):
    end = time.time() + t
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.05)
        if r:
            try: d = os.read(fd, 65536)
            except OSError: return False
            if not d: return False
            st.feed(d)
    return True
pump(0.8)
for k in keys:
    os.write(fd, k.encode('latin-1')); pump(0.3)
pump(0.5)
for i, line in enumerate(scr.display):
    print('%2d|%s' % (i, line.rstrip()))
print('cursor', scr.cursor.y, scr.cursor.x)
try:
    p, s = os.waitpid(pid, os.WNOHANG); print('exited' if p else 'still running')
except ChildProcessError: print('exited')
