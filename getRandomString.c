#include "header.h" 
#include <stdlib.h>

void getRandomString(char* str1, char* str2, int* len1, int* len2, char* arg) {
    int seed;
    int n1;
	int n2;
	
	FILE *output;
	
	seed = atoi(arg);
	srand(seed);
	
	printf("Input in console size of first and second string, \n"
	        "the size should be more than 0 and less than 100. \n" 
	        "You can find the result of random generation in random_gen.txt file. \n");
	
	while(1) {
	    scanf("%d%d", &n1, &n2);
	    if ((0 < n1 && n1 <= 100) && (0 < n2 && n2 <= 100)) break;
	    else printf("Wrong values, try again! \n");
	}
	*len1 = n1;
	*len2 = n2;
	
	for (int i = 0; i < n1; i++) {
        str1[i] = (char) (rand() % 94) + '!';
    }
    
    for (int i = 0; i < n2; i++) {
        str2[i] = (char) (rand() % 94) + '!';
    }

    output = fopen("random_gen.txt", "w");
    fprintf(output, "%s \n%s", str1, str2);
}


