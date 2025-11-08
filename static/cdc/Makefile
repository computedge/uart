# Basic Makefile
# Include the config file
include cdc.cfg
export $(shell sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' cdc.cfg)

all:
	@echo "Build step not defined for this directory."

clean:
	rm -rf novas.* vcst_*  elab_summary.rpt crash* verdi*

cdc:
	vc_static_shell -f vc_cdc.tcl -gui

rdc:
	vc_static_shell -f vc_rdc.tcl -gui
