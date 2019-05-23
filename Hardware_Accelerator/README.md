## Running a test:
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
