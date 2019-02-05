/*
 * Copyright (c) <2016 - 2020>, Bilkent University and ETH Zurich 
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or other
 *   materials provided with the distribution.
 * - Neither the names of the Bilkent University, ETH Zurich,
 *   nor the names of its contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  Authors: 
  Mohammed Alser
	  mohammedalser AT bilkent DOT edu DOT tr
  Date:
  December 3rd, 2016
*/


/* Include Files */
#include "main.h"
#include "stdio.h" 
#include <string.h>
#include <time.h>
#include <stdlib.h>
#include <immintrin.h>

/* to compile type the following 
sudo ldconfig -v
gcc -g -O3 -Wall -o main *.c -lz -lm 
./main 0 4 100 /home/alser-xilinx/Desktop/Filters_29_11_2016/ERR240727_1_E3_30million.txt 3000000
OR: use the following to check the memory leaks
valgrind --leak-check=yes --show-leak-kinds=all ./main
*/

int main(int argc, const char * const argv[]) {
	//(void)argc;
	//(void)argv;

	/*int DebugMode=0;
	int GridSize=4;
	int KmerSize=10;
	int ReadLength = 100; 
	*/
	if (argc!=6){
		printf("missing argument..\n./main [DebugMode] [GridSize] [ReadLength] [ReadFile] [# of reads]\n");
		exit(-1);
	}
	int DebugMode=atoi(argv[1]);
	int GridSize=atoi(argv[2]);
	int ReadLength = atoi(argv[3]); 

	int n;
	FILE * fp;
	char * line = NULL;
	size_t len = 0;
	ssize_t read;
	char *p;
	int j,i;
	int loopPar;
	char RefSeq[ReadLength] ;
	char ReadSeq[ReadLength];
	int ErrorThreshold;
	int Accepted1;
	int FP1;
	int FN1;
	clock_t begin1;
	clock_t end1;
	double time1;
	double time_spent1;
        printf("Edit Distance \t CPU Time(seconds) \t Alignment_Needed \t Not_Needed \n");
	printf("Threshold \n");
	for (loopPar =0; loopPar<=10;loopPar++) {
		ErrorThreshold=(loopPar*ReadLength)/100;
		//printf("\n<-------------------Levenshtein Distance = %d------------------->\n", ErrorThreshold);

		FP1=0;
		FN1=0;
		time1= 0;
		//fp = fopen("/home/alser-xilinx/Desktop/Filters_29_11_2016/ReadRef_39999914_pairs_ERR240727_1_with_NW_2017.fastq", "r");

		fp = fopen(argv[4], "r");
		if (!fp){
			printf("Sorry, the file does not exist or you do not have access permission");
		}
		else {
			for (i = 1; i <= atoi(argv[5]); i++) {
				read = getline(&line, &len, fp);
				j=1;
				for (p = strtok(line, "\t"); p != NULL; p = strtok(NULL, "\t")) {
					if (j==1){
						for (n = 0; n < ReadLength; n++) {
							ReadSeq[n]= p[n];
							//printf("%c",ReadSeq[n]);
						}
						//printf(" ");
					}
					else if (j==2){
						for (n = 0; n < ReadLength; n++) {
							RefSeq[n]= p[n];
							//printf("%c",RefSeq[n]);
						}
						//printf("\n");
					}
					j=j+1;
				}		  

				begin1 = clock();
				Accepted1 = Shouji(ReadLength, RefSeq, ReadSeq, ErrorThreshold, GridSize, DebugMode);
				/*if (Accepted1==1){
					EdlibAlignResult resultEdlib1 = edlibAlign(RefSeq, ReadLength, ReadSeq, ReadLength, edlibNewAlignConfig(-1, EDLIB_MODE_NW, EDLIB_TASK_PATH, NULL, 0)); // with alignment
					edlibFreeAlignResult(resultEdlib1);
				}*/
				end1 = clock();

				
				
				/////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////////////
				/////////////////////////////////////////////////////////////////////////////////////////////////


				//NWAccepted = Accepted8;

				if (Accepted1==0  ){//&& NWAccepted==1
					FN1++;
					//SlidingWindow(ReadLength, RefSeq, ReadSeq, ErrorThreshold, GridSize, 1);
				}
				else if (Accepted1==1 ){//&& NWAccepted==0){
					FP1++;		
				}

				time1 = time1 + (end1 - begin1);
			}

			time_spent1 = (double)time1 / CLOCKS_PER_SEC;

			//printf("Fastest implementation of Myers’s bit-vector algorithm (Edlib 2017):\n");
			//printf("CPU Time(seconds): %5.4f,    Accepted Mapping: %d,    Rejected Mapping: %d\n", time_spent8, FP8,FN8);
			//printf("----------------------------------------------------------------- \n");
			//printf("Filter Name \t    CPU Time(seconds) \t\t FPs# \t FNs# \n");
			printf(" %d \t\t %5.4f \t %10d \t %d\n", ErrorThreshold, time_spent1, FP1,FN1);


			fclose(fp);
		}
	}
	return 0;
}
