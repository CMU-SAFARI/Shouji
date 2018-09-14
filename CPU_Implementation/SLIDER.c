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
#include "SLIDER.h"
#include "stdio.h" 

/* Function Definitions */
int SLIDER(int ReadLength, const char RefSeq[], const char ReadSeq[], int ErrorThreshold, int GridSize, int DebugMode)
{
	int Accepted=0;
	//int *HammingMask;
	int i0;
	int ii;
	int n;
	int e;
	int i1;
	int SLIDERMask[ReadLength];
	int count;
	int GridIndex;
	int MagnetCount;
	int d0;
	int i;
	int MaxZeros;
	int MaxZerosIndex;
	int GridBound ;
	int dd;

	/* 20-Sept-2016 */
	/*  Building the Hamming masks */
	ii = ((2 * ErrorThreshold) + 1) * ReadLength;
	int HammingMask[ii];
	int HammingMask1[ii];//this to maintain the order of the neighborhood map
	int C,K;
	/*
	HammingMask = (int *)malloc(ii * sizeof(int));
	if(!HammingMask)
	{
		printf("Out of Memory !!\n");
		exit(1);
	}
	*/	
	/*for (n = 0; n < ii; n++) {
		HammingMask[n] = 0;
	}
	
	
	//  Original Hamming Mask
	for (n = 0; n < ReadLength; n++) {
		if (ReadSeq[n]== RefSeq[n])
			HammingMask[n] = 0;
		else if (ReadSeq[n]!= RefSeq[n])
			HammingMask[n] = 1;
	}
	
	//  Incremental-step right shifted Hamming Masks (Deletion)
	for (e = 0; e < ErrorThreshold; e++) {
		// fill the shifted chars with Zeros
		for (i0 = 0; i0 <= e; i0++) {
		  HammingMask[((e +1) * ReadLength) + i0] = 0;
		}
		 ii=e+1;
		//  shift the Read chars and compare
		for (n = 0; n < (ReadLength-ii); n++) {
			if (ReadSeq[n]== RefSeq[n+ii]){
				HammingMask[((e+1) * ReadLength) + n + ii] = 0;}
			else if (ReadSeq[n]!= RefSeq[n+ii])
				HammingMask[((e+1) * ReadLength) + n + ii] = 1;
		}
	}
	
	
	//  Incremental-step left shifted Hamming Masks (Insertion)
	for (e = 0; e < ErrorThreshold; e++) {
		// fill the shifted chars with Zeros
		for (i0 = 0; i0 <= e; i0++) {
			HammingMask[((e + ErrorThreshold+1) * ReadLength) + (ReadLength-i0)-1] = 0;
		}
		ii=e+1;
		//  shift the Read chars and compare
		for (n = 0; n < ReadLength-e-1; n++) {
			//printf("%c",ReadSeq[n+ii]);
			//printf(" %c\n",RefSeq[n]);
			if (ReadSeq[n+ii]== RefSeq[n])
				HammingMask[((e + ErrorThreshold + 1) * ReadLength) + n] = 0;
			else if (ReadSeq[n+ii]!= RefSeq[n])
				HammingMask[((e + ErrorThreshold + 1) * ReadLength) + n] = 1;
		}
	}
	
	// END of Building the Hamming masks */


	// Original Hamming Mask
	for (n = (ReadLength-1); n >=0 ; n--) {
		if (ReadSeq[n]!= RefSeq[n])
			HammingMask[n] = 1;
		else
			HammingMask[n] = 0;
	}

	if (ErrorThreshold==0) {
		count=0;
		for (n = 0; n < ReadLength; n++) {
			if (ReadSeq[n]!= RefSeq[n])
				count++;
		}
	}
	else {
		// Shifted Hamming Masks
		for (e = 1; e <= ErrorThreshold; e++) {
			ii = e * ReadLength;
			dd = ii + (ErrorThreshold * ReadLength);
			// fill the shifted chars with Zeros
			for (i0 = e-1; i0 >=0; i0--) {
				// Deletion
				HammingMask[ii + i0] = 1;
				// Insertion
				HammingMask[dd + (ReadLength-i0)-1] = 1;
			}
			//  shift the Read chars and compare
			for (n = (ReadLength-e-1); n >=0 ; n--) {
				//  Incremental-step right shifted Hamming Masks (Deletion)
				if (ReadSeq[n]!= RefSeq[n+e])
					HammingMask[ii + n + e] = 1;
				else
					HammingMask[ii + n + e] = 0;
				// Incremental-step left shifted Hamming Masks (Insertion)
				if (ReadSeq[n+e]!= RefSeq[n])
					HammingMask[dd + n] = 1;
				else
					HammingMask[dd + n] = 0;
			}
		}
		// END of Building the Hamming masks

		// This is to reorder the bit-vector to match the same order of the neighborhood map
		/*for(n=0; n<(((2*ErrorThreshold)+1)*ReadLength);n++){
			HammingMask1[n]=HammingMask[n];
		}
		C=ErrorThreshold+1;
		K=0;
		for (n = 0; n < (((ErrorThreshold))*ReadLength); n++) {
			if ( n % 100 == 0){
				C=C-1;
				K=0;
			}
			HammingMask[n]=HammingMask1[K+(C*ReadLength)];
			K=K+1;
		}
		for(n=0; n<ReadLength;n++){
			HammingMask[n+((ErrorThreshold)*ReadLength)]=HammingMask1[n];
		}*/
		// This is to reorder the bit-vector to match the same order of the neighborhood map
		
		if (DebugMode==1) {
			printf("\nHamming \n");
			for (n = 0; n < (((2*ErrorThreshold)+1)*ReadLength); n++) {
				if ( n % ReadLength == 0)
					printf("\n");
				printf("%d", HammingMask[n]  );
			}
			printf("\n\n\n\n");
		}
		count=0;
		for (n = 0; n < (((2*ErrorThreshold)+1)*ReadLength); n++) {
			if (HammingMask[n]==0)
				count++;
			if ( n % ReadLength == 0) {
				count=0;
				if (count >= (ReadLength-ErrorThreshold))
					return 1;
			}
		}

		/*  Search for Longest Consecutive Zeros in a sliding window fashion*/
		for (i0 = 0; i0 < ReadLength; i0++) {
			//SLIDERMask[i0] = HammingMask[i0+((ErrorThreshold)*ReadLength)];
			SLIDERMask[i0] = HammingMask[i0];
		}
		GridBound = ReadLength - GridSize + 1;
		count=0;
		d0 = (2 * ErrorThreshold) + 1;
		for (GridIndex = 0; GridIndex < ReadLength; GridIndex++) {
			
			if (GridIndex <= (ReadLength - GridSize) ) {
				MaxZeros = 0;
				MaxZerosIndex=0;
				for (i = 0; i < d0; i++) {
					count = 0;
					for (i1 = 0; i1 < GridSize; i1++) {
						if (DebugMode==1) {
							printf("%d", HammingMask[(i * ReadLength) + (GridIndex + i1)] );
						}
						if (HammingMask[(i * ReadLength) + (GridIndex + i1)] == 0) {
							count++ ;
						}
					}
					if (DebugMode==1) {
						printf("\n");
					}
					//printf("count:%d \n", count);
					if (count > MaxZeros) {
						MaxZeros = count;
						MaxZerosIndex = i;
					}
					else if (count == MaxZeros) {
						if ((HammingMask[(i * ReadLength) + (GridIndex)]==0) && (HammingMask[(i * ReadLength) + (GridIndex + 1)]==0)&& (HammingMask[(i * ReadLength) + (GridIndex + 2)]==0))
							MaxZerosIndex = i;
						else if ((HammingMask[(i * ReadLength) + (GridIndex)]==0) && (HammingMask[(i * ReadLength) + (GridIndex + 1)]==0))
							MaxZerosIndex = i;
						else if (HammingMask[(i * ReadLength) + (GridIndex)]==0)
							MaxZerosIndex = i;
					}
				}
				MagnetCount=0;
				for (i0 = 0; i0 < GridSize; i0++) {
					if (SLIDERMask[GridIndex + i0] == 0)
						MagnetCount++;
				}
				//printf("Max%d	\n", MaxZeros);
				if (MaxZeros > MagnetCount) {
					/*if (MaxZeros<GridSize && SLIDERMask[GridIndex + 0]==0 && SLIDERMask[GridIndex + 1]==0 && SLIDERMask[GridIndex + 2]==0 && SLIDERMask[GridIndex + 3]==1) {
						SLIDERMask[GridIndex + 0]=0;
						SLIDERMask[GridIndex + 1]=0;
						SLIDERMask[GridIndex + 2]=0;
						SLIDERMask[GridIndex + 3]=1;
					}
					else if (MaxZeros<GridSize && GridIndex>0 && SLIDERMask[GridIndex -1]==0 && SLIDERMask[GridIndex + 0]==0 && SLIDERMask[GridIndex + 1]==0 && SLIDERMask[GridIndex + 2]==1) {
						SLIDERMask[GridIndex - 1]=0;
						SLIDERMask[GridIndex + 0]=0;
						SLIDERMask[GridIndex + 1]=0;
						SLIDERMask[GridIndex + 2]=1;
					}*/
					/*else if (MaxZeros<GridSize && GridIndex>0 && SLIDERMask[GridIndex -2]==0 && SLIDERMask[GridIndex - 1]==0 && SLIDERMask[GridIndex + 0]==0 && SLIDERMask[GridIndex + 1]==1) {
						SLIDERMask[GridIndex - 2]=0;
						SLIDERMask[GridIndex - 1]=0;
						SLIDERMask[GridIndex + 0]=HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + 0)];
						SLIDERMask[GridIndex + 1]=HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + 1)];
					}*/
					 {
						for (i0 = 0; i0 < GridSize; i0++) {
							SLIDERMask[GridIndex + i0] = HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + i0)];
						}
					}
				}
				
				
				if (DebugMode==1) {
					printf("The selected seed is: ");
					for (i0 = 0; i0 < GridSize; i0++) {
						printf("%d", HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + i0)]);
					}
					printf("\n");
					for (n = 0; n < ReadLength; n++) {
						printf("%d", SLIDERMask[n]);
					}
					printf("\n");
					for (n = 0; n < GridBound; n++) {
						if (n==GridIndex)
							printf("****");
						else
							printf("_");
					}
					printf("\n");
				}
			}
			else if (GridIndex <= (ReadLength - 3) ) {
				MaxZeros = 0;
				MaxZerosIndex=0;
				for (i = 0; i < d0; i++) {
					count = 0;
					for (i1 = 0; i1 < (ReadLength-GridIndex); i1++) {
						if (DebugMode==1) {
							printf("%d", HammingMask[(i * ReadLength) + (GridIndex + i1)] );
						}
						if (HammingMask[(i * ReadLength) + (GridIndex + i1)] == 0) {
							count++ ;
						}
					}
					if (DebugMode==1) {
						printf("\n");
					}
					//printf("count:%d \n", count);
					if (count > MaxZeros) {
						MaxZeros = count;
						MaxZerosIndex = i;
					}
					else if (count == MaxZeros) {
						if ((HammingMask[(i * ReadLength) + (GridIndex)]==0) && (HammingMask[(i * ReadLength) + (GridIndex + 1)]==0) && (HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex)]==1))
							MaxZerosIndex = i;
						else if (HammingMask[(i * ReadLength) + (GridIndex)]==0 && HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex)]==1)
							MaxZerosIndex = i;
					}
				}
				MagnetCount=0;
				for (i0 = 0; i0 < (ReadLength-GridIndex); i0++) {
					if (SLIDERMask[GridIndex + i0] == 0)
						MagnetCount++;
				}
				//printf("Max%d	\n", MaxZeros);
				if (MaxZeros > MagnetCount) {
					for (i0 = 0; i0 < (ReadLength-GridIndex); i0++) {
						SLIDERMask[GridIndex + i0] = HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + i0)];
					}
				}
				if (DebugMode==1) {
					printf("The selected seed is: ");
					for (i0 = 0; i0 < (ReadLength-GridIndex); i0++) {
						printf("%d", HammingMask[(MaxZerosIndex * ReadLength) + (GridIndex + i0)]);
					}
					printf("\n");
					for (n = 0; n < ReadLength; n++) {
						printf("%d", SLIDERMask[n]);
					}
					printf("\n");
					for (n = 0; n < GridBound; n++) {
						if (n==GridIndex)
							printf("****");
						else
							printf("_");
					}
					printf("\n");
				}
			}
			count = 0;
			for (n = 0; n <= GridIndex; n++) {
				if (SLIDERMask[n] == 1 && SLIDERMask[n+1] == 1){
					count++;
					n++;
				}
				else if (SLIDERMask[n] == 1)
					count++ ;
			}
			if (count> ErrorThreshold)
				return 0;
		}

		/*  END of Search for Longest Consecutive Zeros */


	//	free(HammingMask);
		count = 0;
		for (n = 0; n <= GridIndex; n++) {
			if (SLIDERMask[n] == 1 && SLIDERMask[n+1] == 1){
				count++;
				n++;
			}
			else if (SLIDERMask[n] == 1)
				count++ ;
		}
	}
	Accepted = (count <= ErrorThreshold);
	//printf("%d\n", count);
	return Accepted;
}
