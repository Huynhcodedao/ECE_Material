/*
 *  File: io4.c
 *
 *	ECE 231 - Spring 2012
 *	Date: January 16, 2012
 *
 */

/* Does what ??? */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>


int main(int argc, char *argv[])
{
    char temp[100];  // For storing a file name none in command line
	int numbers = 0;
    float flotante;

    FILE *inputf, *outputf; //I/O pointers to files
    
       if (argv[1]) { // If there is a filename in commandline - Checks if valid and opens it. exits if error
        if ( (inputf = fopen(argv[1], "r")) == NULL) {
            printf("\nInvalid filename\n");
            return 1;
        }
    }
    else { // If no commanline arguements - Asks for filename and opens it.  Exits if error.
        printf("\nEnter input filename : ");
      	scanf("%s", temp);
      	        if ( (inputf = fopen(temp, "r")) == NULL) {
            printf("\nInvalid filename\n");
            return 1;
        }
    }
    outputf = fopen("output.txt", "w"); // Not needed for this file but kept for portability
  
  	/* scan floating point numbers from the input file and copy them to the output file  */  
    
  	while (fscanf(inputf,"%f", &flotante) != EOF)
    {
/*        
        printf("count is = %d\n", count);
        printf("flotante is = %f\n", flotante);
 */
        numbers = numbers + 1;
        fprintf(outputf,"%f\n", flotante);
    }

  	printf("\nThe total number of floating points in the file are = %d\n", numbers);
  	
  	fclose(inputf);  // Closes the input file.
  	fclose(outputf);  // Closes output file - just as a best practice
  	
}
