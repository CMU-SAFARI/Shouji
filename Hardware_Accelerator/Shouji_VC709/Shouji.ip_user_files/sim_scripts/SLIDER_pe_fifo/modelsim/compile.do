vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../SLIDER.srcs/sources_1/ip/SLIDER_pe_fifo/SLIDER_pe_fifo_sim_netlist.v" \


vlog -work xil_defaultlib "glbl.v"

