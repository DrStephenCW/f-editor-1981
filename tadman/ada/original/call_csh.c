#include "call_csh.h"
/* structure used by Ada compiler to pass unconstrained arrays */
typedef struct {
        char *ptr;      /* pointer to array */
        int unused;     /* to be used for packed arrays */
        int lowbound;   /* arg'first */
        int upbound;    /* arg'last */
} dopeform;

cal002(d) 
dopeform *d;
{
	char cmd[256];
	int i;
	int size = d->upbound - d->lowbound + 1;
	for (i = 0; i < size; i++) cmd[i] = d->ptr[i];
	cmd[i] = 0;
	system(cmd);
}

cal001() {
static bmu initbool;
if(initbool) return;
initbool = 1;
L0: 
;}

bmu cal000[1];
 bmu cal999[] = {0};
