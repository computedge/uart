// Register file for UART - Compliance to 16550 Spec
// Following registers are available
//
//`include "reg_file_pkg.sv"

module reg_file (
		// APB compatiable signal interface
       		input logic PCLK,
		input logic PRESETn,
		// Register write and read related signals
		input logic PSEL,			// Slave select
		input logic PENABLE,
		input logic PWRITE,			// 1 - Write and 0 - Read
		input logic [7:0] PADDR,		// There are 8 registers, only 3 bits needed to address them
		input logic [7:0] PWDATA,
		
//		output logic PREADY,
		output logic [7:0] PRDATA,

		// Input signals for LSR - Line status register
		input logic i_rx_data_ready,
		input logic i_rx_ovr_run_err,
		input logic i_rx_parity_err,
		input logic i_rx_framing_err,
		input logic i_tx_fifo_empty,
		input logic i_rx_fifo_empty,
		input logic i_rcvr_error,


		// Output signals for LCR
		output logic [1:0] o_word_length,
		output logic o_num_of_stop_bits,
		output logic o_parity_en,
		output logic o_odd_even_parity,
		output logic o_sticky_parity_en,
		output logic o_break_ctrl_bit,
		output logic o_divisor_latch_access_bit

		// Output of register
//		output uart_lsr_t o_lsr_out,
//		output uart_fifo_ctrl_t o_fifo_ctrl_out,
//		output uart_lcr_t o_lcr_out
);

	// Import the uart register file package
	//
	// import uart_pkg::*;


	// Internal register declaration
	uart_rx_buf_t		rx_buf_reg;		// Read Only (R)
	uart_thr_t		thr_reg;		// Write Only (W)
	uart_ier_t		ier_reg;		// Read - Write (RW)
        uart_iir_t		iir_reg;	
	uart_fifo_ctrl_t 	fifo_ctrl_reg;
	uart_lcr_t 		lcr_reg;
	uart_mcr_t		mcr_reg;
	uart_lsr_t 		lsr_reg;
	uart_msr_t		msr_reg;

	// internal wire declaration
	logic wr_en;
	logic rd_en;

	logic [7:0] rd_data;

	// Local parameter declaration - Register address
	localparam RX_BUFF 		= 	8'h0;	// Receive Buffer (R)
	localparam TX_THR		=	8'h0;	// Transmitter Hold Register (W)
	localparam IER			=	8'h1;	// Interrupt Enable Register (RW)
	localparam IIR			=	8'h2;	// Interrupt Identification Register (R)
	localparam FIFO_CTRL		=	8'h2;	// FIFO control register (W)
	localparam LCR			=	8'h3;	// Line Control Register (RW)
	localparam MCR			=	8'h4;	// Modem Control Register (W)
	localparam LSR			=	8'h5;	// Line Status Register (R)
	localparam MODEM_STAT		=	8'h6;	// Modem Status Register (R)


	// Generate the register write and read enable
	assign wr_en = (PWRITE && PENABLE && PSEL);
	assign rd_en = (!PWRITE && PSEL); 
	
	// Output assignments - LCR control signals

	assign o_word_length			= lcr_reg[1:0];
	assign o_num_of_stop_bits		= lcr_reg[2];	
	assign o_parity_en			= lcr_reg[3];		
	assign o_odd_even_parity		= lcr_reg[4];		
	assign o_sticky_parity_en		= lcr_reg[5];	
	assign o_break_ctrl_bit			= lcr_reg[6];
	assign o_divisor_latch_access_bit	= lcr_reg[7];

	// 
	// Write logic for IER register
	always_ff@(posedge PCLK or negedge PRESETn) begin
	  if(!PRESETn) begin
	    thr_reg 		<= 8'h00;
	    ier_reg 		<= 8'h00;
	    fifo_ctrl_reg 	<= 8'hC0;
	    mcr_reg 		<= 8'h00;
	    lcr_reg 		<= '{word_length:2'b11, num_of_stop_bits:1'b0, parity_enable:1'b0,
		    		     odd_even_parity:1'b0,  sticky_parity_bit:1'b0, break_ctrl:1'b0,
		    	             div_access_bit:1'b0};
          end else if (wr_en) begin
            case (PADDR)
	    	TX_THR			: thr_reg 	<= PWDATA;
	    	IER			: ier_reg 	<= PWDATA;
	    	FIFO_CTRL		: fifo_ctrl_reg <= PWDATA;
	    	LCR			: lcr_reg 	<= PWDATA;
	    	MCR			: mcr_reg 	<= PWDATA;
	    default		:;
	    endcase;	    
	  end
	end

	// Write Logic - Line control register (LCR)
//	always_ff@(posedge PCLK or negedge PRESETn) begin
//	  if(!PRESETn) begin
//	    lcr_reg <= '{word_length:2'b11, num_of_stop_bits:1'b0, parity_enable:1'b0,
//		    odd_even_parity:1'b0,  sticky_parity_bit:1'b0, break_ctrl:1'b0,
//		    div_access_bit:1'b0};
//          end else if(wr_en && PADDR == LCR) begin
//	    // lcr_reg <= uart_lcr_t(PWDATA);
//	    lcr_reg <= PWDATA;
//	  end
//	end
	
	


	// Read logic
	always_comb begin 
	  unique case(PADDR)
	     IER: rd_data = ier_reg;
	     LCR: rd_data = lcr_reg;
	     LSR: rd_data = lsr_reg;
     	     default:;
	  endcase
	end

 	// Read - Ouptut assignment
	assign PRDATA = (rd_en) ? rd_data : 8'd0;
//	assign PREADY = 1'b1; 	// Always ready, No wait state
	 
//      assign o_lcr_out = lcr_reg;
//	assign o_lsr_out = lsr_reg;
//	assign o_fifo_ctrl_out = fifo_ctrl_reg;	


endmodule

