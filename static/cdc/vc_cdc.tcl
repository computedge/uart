source "/home/praba/Projects/eda_tool_setup/cdc/vc_cdc.tcl"

set current_design UART

read_file -format sverilog -vcs {-f ${WORKAREA}/output/UART/gen_filelist/UART.synth.f }

elaborate UART

read_sdc -module UART ./constraints/uart.sdc

check_cdc -type setup

check_cdc -type integ

check_cdc -type sync

check_cdc -type struct

report_cdc -verbose

report_violations -verbose

check_rdc 

