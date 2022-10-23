extern int A[];
extern int scanf(const char (*format), int *x);

void get_from_console(int n) {
	for (int i = 0; i < n; ++i) {
		int t;
		scanf("%d", &t);
		A[i] = t;
	}
}
