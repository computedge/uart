// Interface module for UART top

interface uart_intf (input logic PCLK , input logic PRESETn);

	// UART top signals
	// Other input signals - Processor interface
	logic 		PSEL,				// Slave select from AHB master
	logic 		PENABLE,			// indicates that start of access phase
	logic 		PWRITE,				// 1 - Write , 0 Read
	logic [7:0] 	PADDR,				// Address input
	logic [7:0] 	PWDATA,				// Data input from the Master
	
	// Output signals Processor interface
	logic [7:0] 	PRDATA,				// Read data from IP to master
	logic 		PREADY,				// Slave driven, insert wait state. 
	logic		PSLVERR,			// Slave driven, indicating a transaction error		
	
		
	// Serial input - for RX
	logic 		UART_SIN,			// Serial input to UART receiver module


	// Output signals - Serial interface
	logic 		UART_SOUT,			// Serial output from UART Transmitter module

	// Interface for DMA signaling 
	logic 		TXDRDYn,			// Transmit ready, signalling the DMA transfer
	logic 		RXDRDYn,			// Receive ready to signal the DMA transfer



	// Modport declaration
	
	modport uart_driver (
		// Driver interface for DUT input
		output logic PSEL, PENABLE, PWRITE; 
		output logic [7:0] PADDR; 
		output logic [7:0] PWDATA;
		output logic UART_SIN;
		);

	modport uart_monitor (
		input logic PSEL, PENABLE, PWRITE; 
		input logic [7:0] PADDR; 
		input logic [7:0] PWDATA; 
		input logic [7:0] PRDATA;
		input logic PREADY, PSLVERR;
		input logic UART_SIN;
		input logic UART_SOUT;
	);


endinterface

