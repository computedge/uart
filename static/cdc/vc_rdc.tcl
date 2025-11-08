source "/home/praba/Projects/eda_tool_setup/rdc/vc_rdc.tcl"

current_design UART

read_file -format sverilog -vcs {-f ${WORKAREA}/output/UART/gen_filelist/UART.synth.f }

elaborate UART

read_sdc -module UART ./constraints/uart.sdc

check_rdc -type setup

check_rdc -type corruption

report_rdc -verbose

report_violations -verbose


