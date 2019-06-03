# Shouji: a fast and efficient pre-alignment filter for sequence alignment
Shouji is fast and accurate pre-alignment filter for banded sequence alignment calculation. It is named after a traditional Japanese door that is designed to slide open [http://www.aisf.or.jp/~jaanus/deta/s/shouji.htm].

## Citation:
Mohammed Alser, Hasan Hassan, Akash Kumar, Onur Mutlu, Can Alkan, Shouji: a fast and efficient pre-alignment filter for sequence alignment, Bioinformatics, 2019 [https://doi.org/10.1093/bioinformatics/btz234]

## Motivation:
The ability to generate massive amounts of sequencing data continues to overwhelm the processing capacity of existing algorithms and compute infrastructures. In this work, we explore the use of hardware/software co-design and hardware acceleration to significantly reduce the execution time of short sequence alignment, a crucial step in analyzing sequenced genomes. **We introduce Shouji, a highly parallel and accurate pre-alignment filter that remarkably reduces the need for computationally-costly dynamic programming algorithms**. The first key idea of our proposed pre-alignment filter is to provide high filtering accuracy by correctly detecting all common subsequences shared between two given sequences. The second key idea is to design a hardware accelerator design that adopts modern FPGA (field-programmable gate array) architectures to further boost the performance of our algorithm.

## Results: 
Shouji significantly improves the accuracy of pre-alignment filtering by up to two orders of magnitude compared to the state-of-the-art pre-alignment filters, GateKeeper and SHD. Our FPGA accelerator is up to three orders of magnitude faster than the equivalent CPU implementation of Shouji. Using a single FPGA chip, we benchmark the benefits of integrating Shouji with five state-of-the-art sequence aligners, designed for different computing platforms. The addition of Shouji as a pre-alignment step reduces the execution time of five state-of-the-art sequence aligners by up to 18.8x. Shouji can be adopted for any bioinformatics pipeline that performs sequence alignment for verification. Unlike most existing methods that aim to accelerate sequence alignment, Shouji does not sacrifice any of the aligner capabilities, as it does not modify or replace the alignment step.

## Key Ideas:
Shouji is based on two key ideas: (1) A new filtering algorithm that remarkably reduces the need for computationally-expensive banded optimal alignment by rapidly excluding dissimilar sequences from the optimal alignment calculation. (2) Judicious use of the parallelism-friendly architecture of modern FPGAs to greatly speed up this new filtering algorithm.

## Key Mechanism:
![alt text](https://github.com/BilkentCompGen/Shoji/blob/master/Figure1-GitHub.png)

## Shouji Directory Structure:
```
Shouji-master
├───1. CPU_Implementation
├───2. Datasets
└───3. Hardware_Accelerator
    └───4. Shouji_VC709
```            
1. In the "CPU_Implementation" directory, you will find all the source code of the CPU implementation of Shouji. Follow the instructions provided in the README.md inside the directory to compile and execute the program. We also provide an example of how the output of Shouji looks like using both verbose mode and silent mode.
2. In the "Datasets" directory, you will find four sample datasets that you can start with. You will also find details on how to obtain the other datasets that we used in our evaluation, so that you can reproduce the exact same experimental results.
3. In the "Hardware_Accelerator" directory, you will find all the design files (in 4.) and host application that are needed to run Shouji on an FPGA board. You will find details on how to synthesize the design and program the FPGA chip.

## Running Shouji-CPU:

```
make
./main 0 4 100 ../Datasets/ERR240727_1_E3_30million.txt 3000000 
./main [DebugMode] [GridSize] [ReadLength] [ReadFile] [# of reads]
```

## Output [DebugMode OFF]:
```
./main 0 4 100 ../Datasets/ERR240727_1_E3_30million.txt 30000
Edit Distance 	 CPU Time(seconds) 	 Alignment_Needed 	 Not_Needed 
Threshold 
 0 		 0.0223 	         13 	 29987
 1 		 0.0569 	         28 	 29972
 2 		 0.0746 	         70 	 29930
 3 		 0.1243 	        398 	 29602
 4 		 0.1994 	       1657 	 28343
 5 		 0.2689 	       4214 	 25786
 6 		 0.3470 	       8820 	 21180
 7 		 0.4116 	      13538 	 16462
 8 		 0.4772 	      18101 	 11899
 9 		 0.5406 	      23382 	 6618
 10 		 0.5928 	      25483 	 4517
```
The output for DebugMode-enabled Shouji is provided in: https://github.com/CMU-SAFARI/Shouji/tree/master/CPU_Implementation

## Running Shouji-FPGA:
To run a test using Shouji, you need to prepare the following:

1. Computer that supports PCIe Gen3 4-lane.
2. Virtex®-7 FPGA VC709 Connectivity Kit.
3. Vivado v2015.4 (64-bit).
4. Ubuntu 14.4.
5. Genomic read dataset in ACGT format.
6. Synthesize and implement the design.
7. Run the host application provided in Shouji\Hardware_Accelerator\Shouji_test.cpp using the following command:
```
$ ./Shouji_test [INPUT_SIZE_IN_BYTES] [OUTPUT_FILE_NAME]
$ ./Shouji_test [INPUT_FILE_NAME] [OUTPUT_FILE_NAME]
```
The size argument should be a positive integer! You can verify if your VC709 board is configured correctly and reachable through your PCIe using the following command:
```
sudo lspci -vvv -d 10EE:*
```

## How to install Vivado on UBUNTU?
*give root permissions to the current username
```
$ pkexec visudo
*then add: 
$ alser ALL=(ALL:ALL) ALL
*after this line: $ root ALL=(ALL:ALL) ALL
```

*create folder in home to install xilinx inside it
```
$ sudo mkdir /home/Xilinx
$ sudo chmod 777 /home/Xilinx
$ sudo ln -s /home/Xilinx /opt/Xilinx
```

*install xilinx
```
$ cd /home/alser/Downloads/Xilinx_Vivado_SDK_Lin_2014.2_0626_1 
$ sudo chmod +x ./xsetup
$ sudo chmod +x /home/alser/Downloads/Xilinx_Vivado_SDK_Lin_2014.2_0626_1/tps/lnx64/jre/bin
$ sudo ./xsetup 
```
*change the Admin permission, alser is a username
```
$ sudo chgrp -R alser .Xilinx
$ sudo chown -R alser .Xilinx

$ sudo chgrp -R alser /home/Xilinx
$ sudo chown -R alser /home/Xilinx
```
*install the drivers
```
$ cd /home/Xilinx/Vivado/2014.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/
$ sudo /home/Xilinx/Vivado/2014.2/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers
```
*prepare the environment and create alias to start vivado
```
$ sudo gedit .bashrc
```
*then add to the end of the output file:
(you may or not need this line, but try first without it)
```
$ export XILINXD_LICENSE_FILE=/home/alser/.Xilinx/Xilinx.lic
$ alias vivado='source /home/Xilinx/Vivado/2014.2/settings64.sh && vivado'
```
*to start vivado type in the terminal: 
```
$ vivado
````

