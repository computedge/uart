
//`include reg_file_pkg.sv 
module reg_file_tb;

		// APB compatiable signal interface
       		logic PCLK;
		logic PRESETn;
		// Register write and read related signals
		logic [2:0] PADDR;		// There are 8 registers, only 3 bits needed to address them
		logic PSEL;			// Slave select
		logic PENABLE;
		logic PWRITE;			// 1 - Write and 0 - Read
		logic [7:0] PWDATA;
		
		logic PREADY;
		logic [7:0] PRDATA;

		// Input signals for LSR - Line status register
		logic i_rx_data_ready;
		logic i_rx_ovr_run_err;
		logic i_rx_parity_err;
		logic i_rx_framing_err;
		logic i_tx_fifo_empty;
		logic i_rx_fifo_empty;
		logic i_rcvr_error;    


		// Output signals for LCR
		logic [1:0] o_word_length;
		logic o_num_of_stop_bits;
		logic o_parity_en;
		logic o_odd_even_parity;
		logic o_sticky_parity_en;
		logic o_break_ctrl_bit;
		logic o_divisor_latch_access_bit;

		// Output of register
//		uart_lsr_t 		o_lsr_out;
//		uart_fifo_ctrl_t 	o_fifo_ctrl_out;
//		uart_lcr_t 		o_lcr_out;


		// Import the UART register file package
//		import uart_pkg::*;

	// Clock generation
	initial PCLK = 1'b0;
	always #5 PCLK = ~PCLK;
	
	// Reset generation
	initial begin
	  PRESETn = 1'b0;
	  #20;
	  PRESETn = 1'b1;
	end
	
	initial begin
	// Initialize the input signals
	 i_rx_data_ready 	= 'd0 ;
         i_rx_ovr_run_err	= 'd0 ;
         i_rx_parity_err 	= 'd0 ;
         i_rx_framing_err	= 'd0 ;
         i_tx_fifo_empty 	= 'd0 ;
         i_rx_fifo_empty 	= 'd0 ;
         i_rcvr_error	 	= 'd0 ;    
	end


	initial begin
	  // Wait for reset deassertion
	  @(posedge PRESETn);
	  #10;

	  // Write to LCR
	  PSEL = 1; PENABLE = 1; PWRITE = 1;
	  PADDR = 3'h3; PWDATA = 8'h1B; #10;
	  PSEL = 0; PENABLE = 0; PWRITE = 0;
	  #10;

	  // Display the register contents
	  $display ("------------- LCR - Begin -----------------");
	  $display ("Word Length			= %0b", o_word_length			);
	  $display ("Num of Stop Bits			= %0b", o_num_of_stop_bits		);
	  $display ("Parity En				= %0h", o_parity_en                	);  	 	  
	  $display ("ODD or Even Parity			= %0h", o_odd_even_parity          	);
	  $display ("Sticky Parity Enable		= %0h", o_sticky_parity_en         	);
	  $display ("Break Ctrl Bit			= %0h", o_break_ctrl_bit           	);
	  $display ("Div latch access bit		= %0h", o_divisor_latch_access_bit 	);
	  $display ("------------- LCR - End -----------------");
	end


reg_file u_reg_file (
	// Instantiate the DUT
	.PCLK				(PCLK				),
	.PRESETn			(PRESETn			),
	.PADDR				(PADDR				),		
	.PSEL				(PSEL				),		
	.PENABLE			(PENABLE			),
	.PWRITE				(PWRITE				),		
	.PWDATA				(PWDATA				),
	.PREADY				(PREADY				),
	.PRDATA				(PRDATA				),
	
	// Input signals for LSR - Line status register
	.i_rx_data_ready 		(i_rx_data_ready		),
	.i_rx_ovr_run_err		(i_rx_ovr_run_err		),
	.i_rx_parity_err 		(i_rx_parity_err		),
	.i_rx_framing_err		(i_rx_framing_err		),
	.i_tx_fifo_empty 		(i_tx_fifo_empty		),
	.i_rx_fifo_empty 		(i_rx_fifo_empty		),
	.i_rcvr_error			(i_rcvr_error			),
	
	// Output signals for LCR
	.o_word_length              	(o_word_length			),
	.o_num_of_stop_bits         	(o_num_of_stop_bits		),
	.o_parity_en                	(o_parity_en			),
	.o_odd_even_parity          	(o_odd_even_parity		),
	.o_sticky_parity_en         	(o_sticky_parity_en		),
	.o_break_ctrl_bit           	(o_break_ctrl_bit		),
	.o_divisor_latch_access_bit 	(o_divisor_latch_access_bit	)
	
//	// Output of register
//	.o_lsr_out			(o_lsr_out			),
//	.o_fifo_ctrl_out		(o_fifo_ctrl_out		),
//	.o_lcr_out			(o_lcr_out			)
);

	initial begin
		$fsdbDumpfile("verdi.fsdb");
		$fsdbDumpvars(0,reg_file_tb);
	 #50000 $finish;
	 	$stop;
	end

endmodule

