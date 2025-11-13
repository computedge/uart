source "/home/praba/Projects/eda_tool_setup/vc_formal/vc_formal.tcl"


#Read the source file
#
read_file -top sync_fifo -sva -format sverilog +define+FORMAL -vcs {-f fifo_filelist.f}

#Analyze and Elaborate the top
#
#analyze -format sverilog -vcs {-f fifo_filelist.f}
#elaborate sync_fifo -sva

#Clock and reset creation
create_clock clk -period 100
create_reset rstn -sense low

#Check design setup
#check_fv_setup

#Run Verification

check_fv

#Store the session

save_session -session fifo_formal
