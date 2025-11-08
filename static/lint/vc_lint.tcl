source "/home/praba/Projects/eda_tool_setup/lint/lint.tcl"
#source "lint.cfg"

puts "Workarea is $::env(WORKAREA)"
puts "DUT is $::env(DUT)"
puts "TOP is $::env(TOP)"

if {[info exists ::env(TOP)]} {
	set current_design $::env(TOP)
	puts "setting current design as $::env(TOP)"
} else {
	puts "CURRENT_DESIGN is not set"
	exit
}

#analyze -format sverilog -vcs {-f $::env(WORKAREA)/output/$::env(DUT)/gen_filelist/$::env(DUT).synth.f}
analyze -format sverilog -vcs {-f ${WORKAREA}/output/${DUT}/gen_filelist/${DUT}.synth.f}

elaborate $::env(TOP)

check_lint

#report_violations -app lint -verbose -f violatios.rpt -limit 0
save_session -session ./output/$::env(DUT).session
view_activity
#report_violations -verbose

#exit
