# Basic Makefile
DUT ?=UART
FLOW ?=VCS

INCDIR=${WORKAREA}/src/rtl

all: clean compile sim gui

clean:
	rm -rf novas* simv* ucli.key verdi*  csrc *.fsdb

compile:
	# vcs -full64 -debug_acc+all+dmptf -sverilog -debug_access -kdb +incdir+../../src/rtl ../../src/rtl/reg_file_pkg.sv ../../src/rtl/reg_file.sv  ../testbench/reg_file_tb.sv
	#vcs -full64 -debug_acc+all+dmptf -sverilog -debug_access -kdb ../../src/rtl/tx.sv ../testbench/tx_tb.sv
	#vcs -full64 -debug_acc+all+dmptf -sverilog -debug_access -kdb ../../src/rtl/rx.sv ../testbench/rx_tb.sv
	vcs -full64 -debug_acc+all+dmptf -sverilog -debug_access -kdb -f ${WORKAREA}/output/${DUT}/gen_filelist/${DUT}.sim.f

sim:
	./simv 

gui:
	verdi -ssf verdi.fsdb -nologo &

