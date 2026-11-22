# Move with-clauses that a spec does not use into its body (breaks the
# circular spec dependencies that the 1984 UCI Ada tools tolerated).
import re, sys, glob, os
for ads in glob.glob('*.ads'):
    adb = ads[:-1] + 'b'
    s = open(ads).read()
    lines = s.split('\n'); ctx = []; rest = []
    for i, l in enumerate(lines):
        if re.match(r'\s*(package|procedure|function|generic)\b', l, re.I):
            rest = lines[i:]; break
        ctx.append(l)
    body = '\n'.join(rest).lower()
    keep, move = [], []
    for l in ctx:
        m = re.match(r'\s*with\s+(\w+)\s*;', l, re.I)
        if m:
            u = m.group(1).lower()
            used = re.search(r'\b' + u + r'\.', body) or u in ('text_io', 'defs')
            (keep if used else move).append(l)
        else:
            keep.append(l)
    if move and os.path.exists(adb):
        open(ads, 'w').write('\n'.join(keep + rest))
        b = open(adb).read()
        open(adb, 'w').write('\n'.join(move) + '\n' + b)
        print(ads, 'moved', [m.strip() for m in move])
