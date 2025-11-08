`timescale 1ns/1ns
module baud_gen (
	input logic clk,
	input logic rst_n,
	output logic baud_clk_tx,
	output logic baud_clk_rx,
	output logic samp_clk_16x
);
	localparam FCLK	= 1000000; 	// 1 MHz clk
	localparam BAUD_RATE = 9600; 	// 9600 Baudrate
	localparam BAUD_DIVISOR = FCLK / BAUD_RATE; 
	localparam SAMP_CLK_16X_DIVISOR = FCLK / (BAUD_RATE*16);

	logic [31:0] cnt;
	logic [31:0] cnt_16x;
	logic baud_tick;
	logic baud_tick_16x;

	assign baud_clk_tx = baud_tick;
	assign baud_clk_rx = baud_tick;
	assign samp_clk_16x = baud_tick_16x;

	always_ff@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			cnt <= 32'h0;
			baud_tick <= 1'b0;
		end else if (cnt >= BAUD_DIVISOR-1) begin
			baud_tick <= 1'b1;
			cnt <= 32'h0;
		end else begin
			cnt <= cnt + 1;
			baud_tick <= 1'b0;
		end
	end


	always_ff@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			cnt_16x <= 32'd0;
			baud_tick_16x <= 1'b0;
		end else if (cnt_16x >= (SAMP_CLK_16X_DIVISOR-1)) begin
			cnt_16x <= 32'd0;
			baud_tick_16x <= 1'b1;
		end else begin
			cnt_16x <= cnt_16x + 1;
			baud_tick_16x <= 1'b0;
		end
	end
endmodule

`ifdef TEST_BAUD
module tb_baud_gen;
	logic clk;
	logic rst_n;
	logic baud_clk_tx;
	logic samp_clk_16x;

	localparam FCLK	= 1000000; 	// 1 MHz clk
	localparam BAUD_RATE = 9600; 	// 9600 Baudrate
	localparam BAUD_DIVISOR = FCLK / BAUD_RATE; 
	localparam CLK_PERIOD = 1000;

	initial begin
	   clk = 1'b0;
	   rst_n = 1'b0;

	   #10 rst_n = 1'b1;
	end

	always #(CLK_PERIOD/2) clk = !clk;
	

	initial begin
	  $dumpfile("wave.vcd");
	  $dumpvars(0, tb_baud_gen);
	  #10000000 ; $finish;
	  $stop;
	end


	baud_gen u_dut (.*);

endmodule
`endif 
