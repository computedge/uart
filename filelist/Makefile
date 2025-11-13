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

rtl_filelist:
	rm -rf ${DUT}.rtl.f
	touch ${DUT}.rtl.f
	realpath ${WORKAREA}/src/rtl/*.sv >> ${DUT}.rtl.f

create_sim_filelist: rtl_filelist
	touch ${DUT}.sim.f
##	realpath ${WORKAREA}/filelist/${DUT}.rtl.f >> ${DUT}.sim.f
##	realpath ${WORKAREA}/verif/env/verif_env.f >> ${DUT}.sim.f
	@echo "-f $(shell realpath ${WORKAREA}/filelist/${DUT}.rtl.f)" >> ${DUT}.sim.f
	@echo "-f $(shell realpath ${WORKAREA}/verif/env/verif_env.f)" >> ${DUT}.sim.f

create_synth_filelist: rtl_filelist
	touch ${DUT}.synth.f
	@echo "-f $(shell realpath ${WORKAREA}/filelist/${DUT}.rtl.f)" >> ${DUT}.synth.f

