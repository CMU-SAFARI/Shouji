onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.SLIDER_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {SLIDER_fifo.udo}

run -all

quit -force
