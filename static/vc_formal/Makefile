# Basic Makefile
DUT?=fifo
all:
	@echo "Build step not defined for this directory."

clean:
	rm -rf novas* *log *bak vcst* verdi* *rtdb

fpv:
	vcf -f ${DUT}.tcl -batch

fpv_gui:
	vcf -f ${DUT}.tcl -gui
