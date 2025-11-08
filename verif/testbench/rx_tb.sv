`timescale 1ns/1ns
module uart_rx_tb ;
		// Global signals
		logic 	   clk;
		logic 	   rst_n;

		// 16x fast of 9600 baud clock for oversampling the serial
		// input
		logic 	   baud_tick_16x;

		// Parity enable signals
		logic parity_en;
		logic odd_even_parity;

		// Serial Input
		logic 	   sin;

		//Ouptut signals
		logic [7:0] rx_data;
		logic 	   rx_valid;


	initial begin
	  clk = 1'b0;
	  rst_n = 1'b0;
	  baud_tick_16x = 1'b0;
	  parity_en = 1'b0;
	  odd_even_parity = 1'b0;
	  sin = 1'b1;
	  @(posedge clk) rst_n = 1;
	end
		
	always begin 
	   #500 clk = ~clk;
	end 
	
	always begin 
	   #31.25 baud_tick_16x = ~baud_tick_16x;
	end 

	initial begin
		@(posedge clk) sin = 1'b1;		// Line IDLE
		@(posedge clk) sin = 1'b0;		// Start bit
		@(posedge clk) sin = 1'b1;		// Bit 1
		@(posedge clk) sin = 1'b0;		// Bit 2
		@(posedge clk) sin = 1'b1;		// Bit 3
		@(posedge clk) sin = 1'b0;		// Bit 4
		@(posedge clk) sin = 1'b0;		// Bit 5
		@(posedge clk) sin = 1'b1;		// Bit 6
		@(posedge clk) sin = 1'b1;		// Bit 7
		@(posedge clk) sin = 1'b0;		// Bit 8
		@(posedge clk) sin = 1'b1;		// STOP bit


		@(posedge clk) sin = 1'b1;		// Line IDLE
		@(posedge clk) sin = 1'b0;		// Start bit
		@(posedge clk) sin = 1'b1;		// Bit 1
		@(posedge clk) sin = 1'b1;		// Bit 2
		@(posedge clk) sin = 1'b0;		// Bit 3
		@(posedge clk) sin = 1'b0;		// Bit 4
		@(posedge clk) sin = 1'b0;		// Bit 5
		@(posedge clk) sin = 1'b0;		// Bit 6
		@(posedge clk) sin = 1'b0;		// Bit 7
		@(posedge clk) sin = 1'b0;		// Bit 8
		@(posedge clk) sin = 1'b1;		// STOP bit
		
		
		@(posedge clk) sin = 1'b1;		// Line IDLE
		@(posedge clk) sin = 1'b0;		// Start bit
		@(posedge clk) sin = 1'b1;		// Bit 1
		@(posedge clk) sin = 1'b1;		// Bit 2
		@(posedge clk) sin = 1'b1;		// Bit 3
		@(posedge clk) sin = 1'b1;		// Bit 4
		@(posedge clk) sin = 1'b0;		// Bit 5
		@(posedge clk) sin = 1'b0;		// Bit 6
		@(posedge clk) sin = 1'b0;		// Bit 7
		@(posedge clk) sin = 1'b0;		// Bit 8
		@(posedge clk) sin = 1'b0;		// STOP bit  - Frame error condition
	end 
	

	initial begin
		$fsdbDumpfile("rx.fsdb");
		$fsdbDumpvars(0,uart_rx_tb);
	 #50000 $finish;
	 	$stop;
	end

	uart_rx u_dut (
		.clk			(clk),
		.rst_n			(rst_n),
		.baud_tick_16x		(baud_tick_16x),
		.parity_en		(parity_en),
		.odd_even_parity	(odd_even_parity),
		.sin			(sin),
		.rx_data		(rx_data),
		.rx_valid		(rx_valid)
		);	

endmodule

