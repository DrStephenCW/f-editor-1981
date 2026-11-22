typedef unsigned char bmu;
typedef bmu *bp;
typedef int *ip;
typedef bmu **pp;
#define V(n) (f.v+n)
#define ap ((bp)&a)
#define A(n) (ap+n)
#define B(n) *(n)
#define SH(n) *(short *)(n)
#define USH(n) *(unsigned short *)(n)
#define I(n) *(ip)(n)
#define P(n) *(pp)(n)
#define L(n) *(long *)(n)
#define UL(n) *(unsigned long *)(n)
#define D(n) *(double *)(n)
#define U(n) *(unsigned *)(n)
typedef int (*ifun)();
#define F(n) *(ifun *)(n)
extern bp _trvrse(), _ptrchk();
extern bp _fnew(), _fznew();
extern bmu ifib, ofib;
extern bp _peek();
extern unsigned _memavail();
extern double _rabs(), _rsqr();
extern double sin(), cos(), atan();
extern double exp(), log(), sqrt();
extern long _setrange();
bmu cal999[];
#define S(n) (cal999+n)
bmu cal000[];
#define G(n) (cal000+n)
