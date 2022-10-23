#include <stdlib.h>
extern int A[];

void get_from_random(int n, char (*arg)) {
	int seed;

	seed = atoi(arg);

	srand(seed);
	for (int i = 0; i < n; ++i) {
		A[i] = rand();
	}
}
