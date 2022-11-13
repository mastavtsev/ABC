#include "header.h"

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


int contains(char *str, int len, char ch) {
    int flag = 0;
    
    if (len == 0)
        return 0;
    
    for (int i = 0; i < len; i++) {
        if (str[i] == ch) {
            flag = 1;
            break;
        }
    }
    
    return flag;
}

int main(int argc, char **argv) {
    int flag = 0;
    char str1[10000];
    char str2[10000];
    char res1[10000];
    char res2[10000];
    char *arg;
    
    int len1;
    int len2;
    int type;
    
    int i = 0;
    int k = 0;
    int n = 0;
    
    FILE *output;
    
    struct timespec start;
    struct timespec end;
    long elapsed_ns;
      
    if (argc != 3) { // exit with error
		return 1;
	}
   
    printf("Type in the console the type of input you want: \n"
	"1 - console (output in console) \n"
	"2 - file input (output in output.txt) \n"
	"3 - random input (output in console) \n");

	scanf("%d", &type);
	
    
    getData(&type, str1, str2, &len1, &len2, &argc, argv);

    clock_gettime(CLOCK_MONOTONIC, &start);

    for (i = 0; i < len1; i++) {
        if (contains(str2, len2, str1[i])) {
            res1[k++] = str1[i];
        }
    }
    
    
    for (i = 0; i < k; i++) {
        if (!contains(res2, n, res1[i])) {
            res2[n++] = res1[i];
        }
    }
    
    clock_gettime(CLOCK_MONOTONIC, &end);
    elapsed_ns = timespecDiff(end, start);
  
    if (type != 2) {
        printf("\n");
        printf("RESULT:   %s", res2);
    } else if (type == 2){
        printf("\n");
        printf("The resulting string is in the output.txt file.");
        output = fopen("output.txt", "w");
        fprintf(output, "%s", res2);
    }
    
    printf("\nElapsed: %ld ns\n", elapsed_ns);
    
    return 0;
}
