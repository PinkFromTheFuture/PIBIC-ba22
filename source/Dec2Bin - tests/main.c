#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, const char * argv[]) {

    FILE * in;
    FILE * out;
	char infile[100];
	char outfile[100];

	char b[33];
	int i, j = 0;
	int num;

	if(argc != 3){
        printf("Program requires two parameters: inputFile outputFile");
        exit(EXIT_FAILURE);
    }


    strcpy(infile,argv[1]);
    strcpy(outfile,argv[2]);

	/* Abre Arquivos de Entrada e Saída */
	if ((in = fopen( infile, "r" )) == NULL) {
	    printf("Open failed: %s\n",infile);
	    exit(EXIT_FAILURE);
	}
	if ((out = fopen( outfile, "w" )) == NULL) {
	    printf("Open failed: %s\n",outfile);
	    exit(EXIT_FAILURE);
	}

	while( fscanf(in, "%d,", &num) > 0 ){
		for (i=31; i >= 0; i--) {
			if( (1 << i) & num)
				b[31 - i] = '1';
			else
				b[31 - i] = '0';
		}

			b[32] = 0;
			fprintf(out, "%d => \"%s\",\n", j, b);
			j++;
	}

	fclose(in);
	fclose(out);
	printf("\nDone.");

    return 0;
}
