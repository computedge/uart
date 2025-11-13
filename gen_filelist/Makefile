# Basic Makefile

DUT ?= UART
FLOW=gen_filelist

all:
	@echo "Executing clean filelist and gen_filelist targets"
	@$(MAKE) clean_filelist
	@$(MAKE) gen_filelist

clean_filelist:
	rm -rf ${WORKAREA}/output/${DUT}/${FLOW}/ ./output 

gen_filelist:
	mkdir -p ${WORKAREA}/output/${DUT}/${FLOW}/
	cp -rfv ${WORKAREA}/filelist/${DUT}.s*.f ${WORKAREA}/output/${DUT}/${FLOW}/
	ln -s ${WORKAREA}/output/${DUT}/${FLOW}/ ./output
