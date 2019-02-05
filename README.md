# Shouji
Shouji*: Fast and Efficient Computation of Banded Sequence Alignment


## Motivation:
The ability to generate massive amounts of sequencing data continues to overwhelm the processing capacity of existing algorithms and compute infrastructures. In this work, we explore the use of hardware/software co-design and hardware acceleration to significantly reduce the execution time of short sequence alignment, a crucial step in analyzing sequenced genomes. We introduce Shouji, a highly parallel and accurate pre-alignment filter that remarkably reduces the need for computationally-costly dynamic programming algorithms. The first key idea of our proposed pre-alignment filter is to provide high filtering accuracy by correctly detecting all common subsequences shared between two given sequences. The second key idea is to design a hardware accelerator design that adopts modern FPGA (field-programmable gate array) architectures to further boost the performance of our algorithm.

## Results: 
Shouji significantly improves the accuracy of pre-alignment filtering by up to two orders of magnitude compared to the state-of-the-art pre-alignment filters, GateKeeper and SHD. Our FPGA accelerator is up to three orders of magnitude faster than the equivalent CPU implementation of Shouji. Using a single FPGA chip, we benchmark the benefits of integrating Shouji with five state-of-the-art sequence aligners, designed for different computing platforms. The addition of Shouji as a pre-alignment step reduces the execution time of five state-of-the-art sequence aligners by up to 18.8x. Shouji can be adopted for any bioinformatics pipeline that performs sequence alignment for verification. Unlike most existing methods that aim to accelerate sequence alignment, Shouji does not sacrifice any of the aligner capabilities, as it does not modify or replace the alignment step.

## Key Ideas:
Shouji is based on two key ideas: (1) A new filtering algorithm that remarkably reduces the need for computationally-expensive banded optimal alignment by rapidly excluding dissimilar sequences from the optimal alignment calculation. (2) Judicious use of the parallelism-friendly architecture of modern FPGAs to greatly speed up this new filtering algorithm.

## Key Mechanism:
![alt text](https://github.com/BilkentCompGen/Shoji/blob/master/Figure1-GitHub.png)

* Named after a traditional Japanese door that is designed to slide open [http://www.aisf.or.jp/~jaanus/deta/s/shouji.htm].

## Shouji Directory Structure:
```
Shouji-master
├───(1) CPU_Implementation
├───(2) Datasets
└───(3) Hardware_Accelerator
    └───(4) Shouji_VC709
```            
(1) In the "CPU_Implementation" directory, you will find all the source code of the CPU implementation of Shouji. Follow the instructions provided in the README.md inside the directory to compile and execute the program. We also provide an example of how the output of Shouji looks like using both verbose mode and silent mode.
(2) In the "Datasets" directory, you will find four sample datasets that you can start with. You will also find details on how to obtain the other datasets that we used in our evaluation, so that you can reproduce the exact same experimental results.
(3) In the "Hardware_Accelerator" directory, you will find all the design files (in (4)) and host application that are needed to run Shouji on an FPGA board. You will find details on how to synthesize the design and program the FPGA chip.
