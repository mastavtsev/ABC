
/// variant 12 Stavtsev

#include <stdio.h>
#include <time.h>


int A[1048576];
int B[1048576];

extern void get_from_console(int n);
extern void get_from_random(int n, char *arg);

long timespecDiff(struct timespec start, struct timespec stop) {
	struct timespec ret;
	long result;
	ret.tv_sec = start.tv_sec - stop.tv_sec;
	ret.tv_nsec = start.tv_nsec - stop.tv_nsec;

	result = ret.tv_sec;
	result *= 1000000000;
	result += ret.tv_nsec;

	return result;
}

int main(int argc, char **argv) {
	int n;
	int type;
	int j;
	char *arg;
	int neg;
	int pos;
	struct timespec start;
	struct timespec end;
	FILE *input;
	FILE *output;
	long elapsed_ns;

	neg = -1;
	pos = -1;


	/// Добавить проверку на n
	printf("Type in console the size of A: ");
	scanf("%d", &n);

	printf("Type in the console the type of input you want: \n"
	"1 - console (output in console) \n"
	"2 - file input.txt (output in output.txt) \n"
	"3 - random input (output in console) \n");

	scanf("%d", &type);

	if (type == 1) {
		printf("Type values in console:\n");
		get_from_console(n);
	}


	if (type == 2) {
		input = fopen("input.txt", "r");
	for (int i = 0; i < n; ++i) {
		fscanf(input, "%d", &A[i]);
		}
	}

	if (type == 3) {
		if (argc == 2) { // [foo.exe, seed]
			arg = argv[1];
			get_from_random(n, arg);
		} else { // exit with error
			return 1;
		}
	}

	clock_gettime(CLOCK_MONOTONIC, &start);

	for (int i = 0; i < n; ++i) {
		if (A[i] >= 0) {
			if (pos == -1) {
				pos = i;
			}
	} else {
			neg = i;
		}
	}


	j = 0;
	for (int i = 0; i < n; ++i) {
		if (i != neg && i != pos) {
			B[j] = A[i];
			j = j + 1;
		}
	}

	clock_gettime(CLOCK_MONOTONIC, &end);

	elapsed_ns = timespecDiff(end, start);
	printf("Elapsed: %ld ns\n", elapsed_ns);

	printf("\n");
	if (type != 2) {
		printf("Array B\n");
		for (int i = 0; i < n - 2; ++i) {
			printf("%d ", B[i]);
		}
	} else {
		output = fopen("output.txt", "w");
		for (int i = 0; i < n - 2; ++i) {
			fprintf(output, "%d ", B[i]);
		}
	}
	printf("\n");

	return 0;
}




