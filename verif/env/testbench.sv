module uart_tb_top;

	logic pclk, presetn;

	uart_intf intf (pclk, presetn);

	//DUT instantiation
	uart_top u_dut (
			.PCLK			(pclk			),			
			.PRESETn		(presetn		),		
			.PSEL			(intf.PSEL		),			
			.PENABLE		(intf.PENABLE		),  
			.PWRITE			(intf.PWRITE   		),
			.PADDR			(intf.PADDR		),   
			.PWDATA			(intf.PWDATA   		),
			.PRDATA			(intf.PRDATA   		),
			.PREADY			(intf.PREADY   		),
			.PSLVERR		(intf.PSLVERR  		),	
			.UART_SIN		(intf.UART_SIN		), 
			.UART_SOUT		(intf.UART_SOUT		),
			.TXDRDYn		(intf.TXDRDYn		),
			.RXDRDYn		(intf.RXDRDYn		)
		);


	// Initialize uart_env
	env uart_env;


	// Generate clock
	initial begin
	pclk = 0;

	forever #5 pclk = ~pclk;
	end

	// Regerate reset
	//
	initial begin
		presetn = 0;
		#20 presetn = 1;
	end

	// Environemnt setup and start
	initial begin
		uart_env = new(intf);
		uart_env.run();
	end

	// Dump the fsdb file
	initial begin
		$fsdbDumpfile("verdi.fsdb");
		$fsdbDumpvars(0,uart_tb_top);
	 	#500 $finish;
	 	$stop;
 	end	
	

endmodule
