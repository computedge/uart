module uart_glue_logic (
		// Global signals 
		input logic PCLK,
		input logic PRESETn,

		// Address and Data signals from Master
		input logic PSEL,
		input logic PENABLE,
		input logic PWRITE,
		input logic [7:0] PADDR,
		input logic [7:0] PWDATA,

		// Output signals from UART to master
		output logic [7:0] PRDATA,
		output logic PREADY,
		output logic PERROR
	);


	// This is a no wait state design, so UART is always in ready mode
	assign PREADY = 1'b1;




endmodule
