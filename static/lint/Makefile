# Basic Makefile
include lint.cfg
export $(shell sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' lint.cfg)

all: clean lint_gui

clean:
	rm -rf ${WORKAREA}/output/${DUT}/${FLOW}/ ./output

lint:
	mkdir -p ${WORKAREA}/output/${DUT}/${FLOW}	
	ln -s ${WORKAREA}/output/${DUT}/${FLOW} ./output
	vc_static_shell -mode64 -f vc_lint.tcl -batch -out_dir ./output

lint_gui:
	mkdir -p ${WORKAREA}/output/${DUT}/${FLOW}	
	ln -s ${WORKAREA}/output/${DUT}/${FLOW} ./output
	vc_static_shell -mode64 -f vc_lint.tcl -out_dir ./output

gui:
	vc_static_shell -gui -out_dir ./output
