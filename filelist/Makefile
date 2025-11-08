# Basic Makefile

DUT ?= UART 
FLOW ?= filelist


all:
	@echo "Creating simulation and synthesis filelist."
	@$(MAKE) create_sim_filelist
	@$(MAKE) create_synth_filelist
	ln -s ${WORKAREA}/output

clean:
	rm -rf *.f

create_sim_filelist:
	touch ${DUT}.sim.f
	realpath ${WORKAREA}/src/rtl/*sv >> ${DUT}.sim.f

create_synth_filelist:
	touch ${DUT}.synth.f
	realpath ${WORKAREA}/src/rtl/*sv >> ${DUT}.synth.f

