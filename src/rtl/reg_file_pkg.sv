// Register file package declaration
//
//
//--------------------------------------------------------------------
//	UART - 16550 compliance - Register Matrix
//----------------------------------------------------------------------------------------------------------------------//
// |              Name 			|     Address	|	Width	| 	Access		| Description		//
//----------------------------------------------------------------------------------------------------------------------//
// |Receive Buffer                      |     3'h0	|	[7:0]	|       Read-Only (R)   |                       
// | 					|         	|            	|                       |
// |Transmitter Hold Register (THR)	|     3'h0	|	[7:0]	|       Write-Only (W)  |       
// |					|         	|            	|                       |
// |Interrupt Enable			|     3'h1	|	[7:0]	|       Read-Write (RW) |                           
// |					|         	|            	|                       |
// |Interrupt Identification		|     3'h2	|	[7:0]	|	Read-Only (R)   |                                          
// |					|         	|            	|                       |
// |FIFO Control			|     3'h3	|	[7:0]	|       Write-Only (W)  |          
// |					|         	|            	|                       |
// |Line control register (LCR)		|     3'h4	|	[7:0]	|       Read-Write (RW) |      
// |					|         	|	     	|                       |
// |Modem control			|     3'h5	|	[7:0]	|       Write-Only (W)  | 
// |					|         	|	     	|                       |
// |Line Status Register (LSR)		|     3'h6	|	[7:0]	|       Read-Only (R)   |  
// |					|         	|	     	|                       |
// |Modem Status			|     3'h7	|	[7:0]	|       Read-Only (R)   |               
// |					|         	|            	|                       |
//-----------------------------------------------------------------------------------------------------------------------//
//

package uart_pkg;

// UART receive buffer
typedef struct packed {
	logic [7:0] rx_buf;
} uart_rx_buf_t;

// UART TX Hold register
typedef struct packed {
	logic [7:0] uart_thr;
} uart_thr_t;

//	Interrupt enable register 

typedef struct packed {
	logic rx_data_ready;	// Received data availability 0 - Disable, 1 - Enable
	logic thr_empty;	// Transmitter Hold Register empty; 0 - Disable, 1 - Enable
	logic rx_line_status;	// Receiver line status , 0 - Disable, 1 - enable
	logic modem_status;	// Modem status , 0 -disable, 1 -enable
} uart_ier_t;

// Interrupt identification register
typedef struct packed {
	logic [7:0] iir_reg_bits;
} uart_iir_t;

// Register field declaration for FIFO Control register
typedef struct packed {
						// Bit 0 - Ignored
	logic rx_fifo_rst;			// Bit 1 - Receiver fifo reset when set to logic 1 (No reset on rx shift reg)
	logic tx_fifo_rst;			// Bit 2 - Transmitter fifo reset when set to logic 1 (No reset on tx shift register)
						// Bit [5:3] - Ignored
	logic [1:0] fifo_int_level;		// To set the FIFO interrupt trigger level
						// 00 - 1 Byte
						// 01 - 4 Byte
						// 10 - 8 Byte
						// 11 - 14 Bytes
} uart_fifo_ctrl_t;

//
// Register field declaration for LCR - Line control register
//
typedef struct packed {
	logic [1:0]	word_length;  		// [1:0] - 00 - 5 bits, 01 - 6 bits , 10 - 7 bits , 11 - 8 bit
	logic num_of_stop_bits;			// 0 - 1 Stop bit , 1 - 2 Stop bits
	logic parity_enable;			// 0 - No Parity, 1 - Parity enabled,
	logic odd_even_parity;			// 0 - Odd parity (Odd number of 1's transmitted, 1 - even number of 1's transmitted)
	logic sticky_parity_bit;		// 0 - Sticky parity disabled, 1 - enabled (if bit 3 and 4 are logic 1, then the parity 
						// is transmitted and checked as 0, if bit 3 is 1 and bit 4 is 0, 
						// then the parity is transmitted and checked as 1
	logic break_ctrl;			// 1 the serial out is forced to logic s0 (Break state)
	logic div_access_bit;			// Divisor latch access bit. 
						// 1 - The divisoir latches can be accessed, 
						// 0 - Normal register access
} uart_lcr_t;


// Modem control register (MCR) - Write only register
typedef struct packed {
	logic dtr;				// Data Terminal ready  - 0 - DTR is '1' and  1 - DTR is '0'
	logic rts;				// Request to send - '0' - RTS is '1'and 1 - RTS is '0'
	logic loopback_en;			// Loop back mode enable. 0 - Normal operation, 1 - Loop back mode enabled
} uart_mcr_t;


// UART line status register - Register field declaration
//
typedef struct packed {
	logic data_ready;			// Data ready indicator
						// 0 - No character in the fifo (RX_FIFO)
						// 1 - Atleaset 1 character has been receieved and it is in the FIFO
	logic overrun_err;			// Overrun error indicator
						// 1 - if FIFO is full, and another character is received in the shift register,if another character is starting to arrive, 
						// then the data in the shift register will overwrite, but the FIFO remains intact,
						// 0 - No overrun state
	logic parity_error;			// 1 - the character is that currenty on top of the FIFO has parity error, cleared on reading the register
       						// 0 - No parity error
	logic framing_error;			// 1 - The received character did not received a valid stop bit.
						// 0 - No parity error
	logic break_interrupt;			// 1 - A break condition occured in the current character. the break occurs whtn the line is held 0 for a time of 
						// one character (START+DATA+PARITY+STOP). 
						// 0 - No break condition
	logic tx_fifo_empty;			// 1 - Transmitter FIFO is empty
						// 0 - Otherwise
	logic rx_fifo_empty;			// 1 - Receiver FIFO is empty
						// 0 - Otherwise
	logic rx_error_flag;			// Receiver Error flag
						// 1 - Atleast 1 error (Parity, framing or break) in the received character and are inside the FIFO
						// 0 -Otherwise
} uart_lsr_t;

// UART Modem status register
typedef struct packed {
	logic dcts;				// Delta clear to send (DCTS)
	logic ddsr;				// Delta data set ready (DDSR)
} uart_msr_t;

endpackage: uart_pkg

import uart_pkg::*;


