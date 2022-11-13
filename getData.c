#include "header.h"

void getData(int* type, char* str1, char* str2, int* len1, int* len2, int* argc, char **argv) {
    
    int ch;
    int flag = 0;
    char* fname;
    FILE *input;
    char *arg;
  
    
    if (*type == 1) {
        printf("Enter in console two strings. Divide them by the symbol ';'. The enter process ends with double Ctrl + D press. \n");
        input = stdin;
    } else if (*type == 2) {
        fname = argv[2];
        input = fopen(fname, "r");
        
    } else { 
        arg = argv[1];
        getRandomString(str1, str2, len1, len2, arg);
    }

    if (*type != 3) {
        int i = 0;
        do {
            ch = fgetc(input);
            if (ch != 59) {
                if (!flag) str1[i++] = ch;
                else str2[i++] = ch;
            } else {
                *len1 = i;
                i = 0;
                flag = 1;
            }
        } while(ch != -1);
        *len2 = (i-1);
        str2[i-1] = '\0';
    }
    
    if (*type == 2) {
        fclose(input);
    }
}