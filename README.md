# Shōji
Shōji: Fast and Efficient Computation of Banded Sequence Alignment

## Motivation:
The ability to generate massive amounts of sequencing data continues to overwhelm the processing capacity of existing algorithms and compute infrastructures. In this work, we explore the use of hardware/software co-design and hardware acceleration to significantly reduce the execution time of short sequence alignment, a crucial step in analyzing sequenced genomes. We introduce Shōji, a highly parallel and accurate pre-alignment filter that remarkably reduces the need for computationally-costly dynamic programming algorithms. The first key idea of our proposed pre-alignment filter is to provide high filtering accuracy by correctly detecting all common subsequences shared between two given sequences. The second key idea is to design a hardware ac-celerator design that adopts modern FPGA (field-programmable gate array) architectures to further boost the performance of our algorithm.

## Results: 
Shōji significantly improves the accuracy of pre-alignment filtering by up to two orders of magnitude compared to the state-of-the-art pre-alignment filters, GateKeeper and SHD. Our FPGA accelerator is up to three orders of magnitude faster than the equivalent CPU implementation of Shōji. Using a single FPGA chip, we benchmark the benefits of integrating Shōji with five state-of-the-art sequence aligners, designed for different computing platforms. The addition of Shōji as a pre-alignment step reduces the execution time of five state-of-the-art sequence aligners by up to 18.8x. Shōji can be adopted for any bioinformatics pipeline that performs sequence alignment for verification. Unlike most existing methods that aim to accelerate sequence alignment, Shōji does not sacrifice any of the aligner capabilities, as it does not modify or replace the alignment step.

## Key Ideas:
Shōji is based on two key ideas: (1) A new filtering algorithm that remarkably accelerates the computation of the banded optimal alignment by rapidly excluding dissimilar sequences from the opti-mal alignment calculation. (2) Judicious use of the parallelism-friendly architecture of modern FPGAs to greatly speed up this new filtering algorithm.

## Key Mechanism:
![alt text](https://github.com/BilkentCompGen/Shoji/blob/master/Figure1-GitHub.png)
