#Set the current design 
current_design UART

set current_design UART

#Create a clock constraint
create_clock -name uart_clk -period 20 [get_ports uart_clk]

#Create generated clock for baud_clk
create_generated_clock -name gen_clk_baud_tick -source {uart_clk} -divide_by 2 -duty_cycle 50 -add -master_clock {uart_clk} {u_baud_gen/baud_clk_tx}

set_clock_groups -group uart_clk -group gen_clk_baud_tick -name uart_clk_grp -asynchronous 

#Create a reset constraint
create_reset -name uart_reset -value low -async [get_ports uart_rstn]

#Port constraints

