module sync_fifo #(
	parameter FIFO_DEPTH=8,
	parameter DATA_WIDTH=8,
	parameter ADDR_WIDTH=$clog2(FIFO_DEPTH)	
)(
		input logic clk,				// Clock
		input logic rstn,				// Low active reset signal
		
		// Write side signals
		input logic wr,					// Write enable 
		input logic [DATA_WIDTH-1:0] wr_data,		// Write data
		output logic fifo_full,				// Fifo full - status signal
		
		// Read side signals 
		input logic rd,					// Read enable signal
		output logic [DATA_WIDTH-1:0] rd_data,		// Read data from FIFO
		output logic fifo_empty,			// FIFO empty - status signal

		// Other signals - Interrupt and status
		input logic [1:0] fifo_int_level_trigger,	// FIFO filling - Interrupt level setting input - Read side
		output logic [ADDR_WIDTH-1:0] mem_used,	// Status signal - Provides the fifo address pointer 
		output logic fifo_int				// FIFO filling interrupt level reached - interrupt signal
);

	// Internal signals
	logic [ADDR_WIDTH:0] wr_ptr;	// Write pointer with one extra MSB address bit - to calculate the full and empty conditions 
	logic [ADDR_WIDTH:0] rd_ptr; 	// Read pointer with one extra MSB address bit - to calculate the full and empty conditions

	logic [ADDR_WIDTH-1:0] int_trigger_val;

	logic wr_en;
	logic rd_en;
	
	// FIFO read trigger level for interrupt generation - currently
	// supporting till 8 Bytes.
	localparam ONE_BYTE 	= 2'h0;
	localparam FOUR_BYTE 	= 2'h1;
	localparam EIGHT_BYTE 	= 2'h2;
	localparam FOURTEEN_BYTE 	= 2'h3;

	// FIFO memory declaration
	logic [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

	
	// FIFO Full and Empty condition calculations
	assign fifo_empty  = wr_ptr == rd_ptr;
	assign fifo_full = ((wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]));

	// Write and Read enable generation
	assign wr_en = (wr && !fifo_full);
	assign rd_en = (rd && !fifo_empty);
	
	// Interrupt level trigger
	assign int_trigger_val =  (fifo_int_level_trigger == ONE_BYTE) ? 'd0: 
				  (fifo_int_level_trigger == FOUR_BYTE) ? 'd1:
				  (fifo_int_level_trigger == EIGHT_BYTE) ? 'd2:'d0; 

	// FIFO write and read block
	always_ff@(posedge clk or negedge rstn) begin
	  if(~rstn) begin
            wr_ptr <= {ADDR_WIDTH{1'b0}};
	  end else if (wr_en) begin
	    mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
	    wr_ptr <= wr_ptr + 1;
	  end else if (rd_en) begin
	    rd_data <= mem[rd_ptr[ADDR_WIDTH-1]];
	    rd_ptr <= rd_ptr + 1;
	  end else begin
	    wr_ptr <= wr_ptr;
	    rd_ptr <= rd_ptr;
	  end
	end


	// Logic to generate fifo interrupt
		
	assign fifo_int = (rd_ptr == int_trigger_val) ? 1'b1 : 1'b0;

	// Logic to generate how many memory locations occupied (Used)
	assign mem_used = wr_ptr[ADDR_WIDTH-1:0] - rd_ptr[ADDR_WIDTH-1:0];

`ifdef FORMAL	
	sequence fifo_wr_seq;
	 @(posedge clk) 
	 (!rd && wr && wr_data == 8'h01);
	endsequence

	// Formal verification properties
	property wr_ptr_inc;
	@(posedge clk) disable iff(~rstn)
	(fifo_wr_seq ) |=> (wr_ptr == $past(wr_ptr)+1);
	// (wr && !fifo_full) |=> (wr_ptr == $past(wr_ptr) + 1);
	endproperty


	assert_wr_ptr_inc: assert property (wr_ptr_inc);	
`endif

endmodule
