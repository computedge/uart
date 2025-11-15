// Interface module for UART top

interface uart_intf (input logic PCLK , input logic PRESETn);

	// UART top signals
	// Other input signals - Processor interface
	logic 		PSEL;				// Slave select from AHB master
	logic 		PENABLE;			// indicates that start of access phase
	logic 		PWRITE;				// 1 - Write , 0 Read
	logic [7:0] 	PADDR;				// Address input
	logic [7:0] 	PWDATA;				// Data input from the Master
	
	// Output signals Processor interface
	logic [7:0] 	PRDATA;				// Read data from IP to master
	logic 		PREADY;				// Slave driven, insert wait state. 
	logic		PSLVERR;			// Slave driven, indicating a transaction error		
	
		
	// Serial input - for RX
	logic 		UART_SIN;			// Serial input to UART receiver module


	// Output signals - Serial interface
	logic 		UART_SOUT;			// Serial output from UART Transmitter module

	// Interface for DMA signaling 
	logic 		TXDRDYn;			// Transmit ready, signalling the DMA transfer
	logic 		RXDRDYn;			// Receive ready to signal the DMA transfer


	// Clocking block for driver
	clocking cb_drv @(posedge PCLK);
		output PSEL, PENABLE, PWRITE, PADDR, PWDATA, UART_SIN;
	endclocking 

	// Clocking block for monitor
	clocking cb_mon @(posedge PCLK);
		input PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA, PREADY, PSLVERR;
	endclocking


	// Modport declaration
	
	modport uart_driver (
		input PCLK,
		input PRESETn,
		// Driver interface for DUT input
		output PSEL,
	        output PENABLE,
	       	output PWRITE,
		output PADDR, 
		output PWDATA,
		output UART_SIN,

		input PRDATA,
		input PREADY
		);

	modport uart_monitor (
		input PCLK,
		input PRESETn,
		input PSEL, PENABLE, PWRITE, 
		input PADDR, 
		input PWDATA,
		input PRDATA,
		input PREADY, PSLVERR,
		input UART_SIN,
		input UART_SOUT
	);


endinterface

