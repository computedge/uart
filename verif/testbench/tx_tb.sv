module uart_tx_tb ;
	logic 	  clk;
	logic 	  rst_n;
	logic 	  tx_start;
	logic [7:0] data_in;
	logic 	  parity_en; // Enable signal for parity bit
	logic 	  even_odd_parity; // Indicates it is even or odd parity
	logic [1:0] data_bit_len; // 00 -5 bits, 01 - 6 bits, 10 - 7 bits, 11 -8 bits
	logic 	  num_of_stop_bits; // Number of stop bits, 0 - 1 stop bit, 1 - 2 stop bit
	logic 	  sout;


	

	initial begin
		clk = 1'b0;
		rst_n	= 1'b0;
		tx_start = 1'b0;
		data_in	= 8'h00;
		parity_en = 1'b0;
		even_odd_parity = 1'b0;
		data_bit_len = 2'b11;
		num_of_stop_bits = 1'b0;

		#20 rst_n = 1'b1;
	end
	
	
	always begin 
	   #500 clk = ~clk;
	end 

	initial begin
	    @(posedge clk) data_in = 8'h05;
	    @(posedge clk) tx_start = 1'b1;

	end

	initial begin
		$fsdbDumpfile("tx.fsdb");
		$fsdbDumpvars(0,uart_tx_tb);
	 #20000 $finish;
	 	$stop;
	end

	// DUT instantiation
	uart_tx u_tx (
	       		.clk 			(clk		),
			.rst_n			(rst_n		),
			.tx_start		(tx_start	),
			.data_in		(data_in	),
			.parity_en		(parity_en	),
			.even_odd_parity	(even_odd_parity),
			.data_bit_len		(data_bit_len	),
			.num_of_stop_bits	(num_of_stop_bits),
			.sout			(sout		)
		);	

endmodule

