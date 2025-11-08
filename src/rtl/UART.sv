module UART (
	// Input signals - Global signals
	input logic 		PCLK,				// System clock
	input logic 		PRESETn,			// System reset

	// Other input signals - Processor interface
	input logic 		PSEL,				// Slave select from AHB master
	input logic 		PENABLE,			// indicates that start of access phase
	input logic 		PWRITE,				// 1 - Write , 0 Read
	input logic [7:0] 	PADDR,				// Address input
	input logic [7:0] 	PWDATA,				// Data input from the Master
	
	// Output signals Processor interface
	output logic [7:0] 	PRDATA,				// Read data from IP to master
	output logic 		PREADY,				// Slave driven, insert wait state. 
	output logic		PSLVERR,			// Slave driven, indicating a transaction error		
	
		
	// Serial input - for RX
	input logic 		UART_SIN,			// Serial input to UART receiver module


	// Output signals - Serial interface
	output logic 		UART_SOUT,			// Serial output from UART Transmitter module

	// Interface for DMA signaling 
	output logic 		TXDRDYn,			// Transmit ready, signalling the DMA transfer
	output logic 		RXDRDYn				// Receive ready to signal the DMA transfer
	
	// Modem interface signals
	
);

// Logic signals
logic baud_clk_rx;
logic baud_clk_tx;
logic samp_clk_rx_16x;
logic r_frame_error;
logic r_rx_valid;

// Internal signals for status register. - LSR
logic r_rx_data_ready	;
logic r_rx_ovr_run_err	;
logic r_rx_parity_err	;
logic r_rx_framing_err	;
logic r_tx_fifo_empty	;
logic r_rx_fifo_empty	;
logic r_rcvr_error	;

// Internal signals from Line Control Register - LCR

logic [1:0] r_word_length;
logic r_num_of_stop_bits;
logic r_parity_en;
logic r_odd_even_parity;
logic r_sticky_parity_en;
logic r_break_ctrl_bit;
logic r_divisor_latch_access_bit;



// Register file integration

reg_file u_reg_file 	(
			.PCLK				(PCLK				),
			.PRESETn			(PRESETn			),
			.PSEL 				(PSEL				),
			.PENABLE 			(PENABLE			),
			.PWRITE 			(PWRITE				),
			.PADDR				(PADDR				),
			.PWDATA 			(PWDATA				),
			.PRDATA				(				),
			.i_rx_data_ready		(r_rx_data_ready		),
			.i_rx_ovr_run_err		(r_rx_ovr_run_err		),
			.i_rx_parity_err		(r_rx_parity_err		),
			.i_rx_framing_err		(r_rx_framing_err		),
			.i_tx_fifo_empty		(r_tx_fifo_empty		),
			.i_rx_fifo_empty		(r_rx_fifo_empty		),
			.i_rcvr_error			(r_rcvr_error			),
			.o_word_length			(r_word_length			),
			.o_num_of_stop_bits            	(r_num_of_stop_bits		),
			.o_parity_en                   	(r_parity_en			),
			.o_odd_even_parity             	(r_odd_even_parity		),
			.o_sticky_parity_en            	(r_sticky_parity_en		),
			.o_break_ctrl_bit              	(r_break_ctrl_bit		),
			.o_divisor_latch_access_bit     (r_divisor_latch_access_bit	)
);


// Baud rate clock generator instantiation
baud_gen u_baud_gen	(
			.clk 				(PCLK				),
			.rst_n				(PRESETn			),
			.baud_clk_tx			(baud_clk_tx			),
			.baud_clk_rx			(baud_clk_rx			),
			.samp_clk_16x			(samp_clk_rx_16x		)
		);


// UART Transmitter
uart_tx u_transmitter (
       			.clk				(baud_clk_tx			),
			.rst_n				(PRESETn			),
			.tx_start			(1'b1				),
			.data_in			(PWDATA				),
			.parity_en			(r_parity_en			),
			.even_odd_parity		(r_odd_even_parity		),
			.data_bit_len			(r_word_length			),
			.num_of_stop_bits		(r_num_of_stop_bits		),
			.sout				(UART_SOUT			)
		);



// UART receiver
uart_rx  U_receiver (
			.clk 				(baud_clk_rx			),
			.rst_n				(PRESETn			),
			.baud_tick_16x			(samp_clk_rx_16x		),
			.parity_en			(1'b0				),
			.odd_even_parity		(1'b0				),
			.sin				(UART_SIN			),
			.frame_error			(r_frame_error			),
			.rx_data			(PRDATA				),
			.rx_valid			(r_rx_valid			)
		);


uart_glue_logic u_glue_logic	(
			.PCLK				(PCLK				),
			.PRESETn			(PRESETn			),
			.PSEL				(PSEL				),
			.PENABLE			(PENABLE			),
			.PWRITE				(PWRITE				),
			.PADDR				(PADDR				),
			.PWDATA				(PWDATA				),
			.PRDATA				(				),
			.PREADY				(PREADY				),
			.PERROR 			(PERROR				)
		);
	

endmodule
