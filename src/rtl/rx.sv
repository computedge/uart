`timescale 1ns/1ns
module uart_rx (
		// Global signals
		input logic 	   clk,
		input logic 	   rst_n,

		// 16x fast of 9600 baud clock for oversampling the serial
		// input
		input logic 	   baud_tick_16x,

		// Parity enable signals
		input logic 	   parity_en,
		input logic 	   odd_even_parity,

		// Serial Input
		input logic 	   sin,

		//Ouptut signals
		output logic 	   frame_error,
		output logic [7:0] rx_data,
		output logic 	   rx_valid
		);

   // 2FF sync signals for incoming data.
   logic 			   sync_1, sync_2;
   logic [7:0] 			   rx_data_nxt;
   logic 			   rx_valid_nxt ;
   logic [3:0] 			   sample_cnt;
   logic [3:0] 			   sample_cnt_nxt;		// Sample count
   logic [3:0] 			   rx_bit_cnt;
  //  logic [3:0] 			   rx_bit_cnt_nxt;
   
   logic [7:0] 			   rx_shift; // rx_shift_nxt;



   // RX State declaration
   typedef enum 		   logic [2:0] {
						IDLE,
						//		START,
						DATA,
						PARITY,
						STOP
//						DONE
						} rx_state_t;

   rx_state_t current_state, next_state;

   // Synchronize the incoming data 
   always_ff@(posedge clk or negedge rst_n) begin
      if(~rst_n) begin
	 sync_1 <= 1'b1;
	 sync_2 <= 1'b1;
      end else begin
	 sync_1 <= sin;
	 sync_2 <= sync_1;
      end
   end
   
   always_comb begin
//      rx_bit_cnt_nxt = 'd0;
//      rx_shift_nxt = 'd0;
  //    rx_shift = 'd0;
      frame_error = 1'b0;
      rx_valid_nxt = 1'b0;
      case(current_state)
	IDLE : begin
	   if ( sync_2 == 1'b0) begin
	      next_state = DATA;
	   end
	   else begin
	      next_state = IDLE;
	   end
	end
       
	DATA: begin
	   if(rx_bit_cnt <= 4'h7) begin
	      next_state = DATA;
//	      rx_bit_cnt_nxt = rx_bit_cnt_nxt + 1;
	      //rx_shift_nxt = {sync_2, rx_shift_nxt[7:1]};
//	      rx_shift = {sync_2, rx_shift[7:1]};
	   end else begin
	      next_state = STOP;
//	      rx_bit_cnt_nxt = 'd0;
	   end
	end

	STOP: begin
	   next_state = IDLE;
	   if (sync_2 == 1'b1) begin
	      frame_error = 1'b0;
	      rx_valid_nxt = 1'b1;
	   end else begin
	      frame_error = 1'b1;
	   end
	end

//// 	DONE:begin 
//// 	  // rx_valid_nxt = 1'b1;
//// 	   rx_data_nxt = rx_shift_nxt;
//// //	   rx_data = rx_shift;
//// 	   next_state = IDLE;
//// 	end
	
	default: begin 
	end
      endcase // case (current_state)
          
   end // always_comb:



	always_ff@(posedge clk or negedge rst_n) begin
	   if(~rst_n) begin
	      rx_data <= 8'h00;
	      rx_valid <= 1'b0;
	      current_state <= IDLE;
//	      rx_bit_cnt <= 'd0;
	   end else begin
//	      rx_data <= rx_data_nxt;
	      rx_data <= rx_shift;
	      rx_valid <= rx_valid_nxt;
	      current_state <= next_state;
//	      rx_bit_cnt <= rx_bit_cnt_nxt;
	   end
	end


	// Bit counter and data shift logic
	always_ff@(posedge clk or negedge rst_n) begin
	  if(~rst_n) begin
            rx_bit_cnt <= 4'd0;
	    rx_shift <= 8'd0;
	  end else if (next_state != DATA) begin
	    rx_bit_cnt <=4'd0;
	  end else if (current_state == DATA) begin
            rx_bit_cnt <= rx_bit_cnt +  1;
	    rx_shift <= {sync_2, rx_shift[7:1]};
	  end
	end
 



   /*
    // Implementation with oversampling 
    // FSM next state generation logic
    always_comb begin
    rx_valid_nxt = 1'b0;
    rx_shift_nxt = 8'h0;
    sample_cnt_nxt = 4'h0;
    //   next_state = current_state;
    if(baud_tick_16x) begin
    case(current_state)
    IDLE: begin
    if (sync_2 == 1'b0) begin 	// Detect the start bit
    next_state = START;
    sample_cnt_nxt = 4'h0;
	      end
       	   end
    
    START: begin
    if (sample_cnt_nxt == 7) 
    begin
    if(sync_2 == 1'b0) 
    begin   // Detect the mid point of start bit
    next_state = DATA;
    sample_cnt_nxt = 0;
    rx_bit_cnt_nxt = 3'h0;
		     end 
    else 
    begin
    next_state = IDLE;
		     end
		end // if (sample_cnt_nxt == 7)
    else 
    begin
    sample_cnt_nxt = sample_cnt_nxt + 1;
		end // else: !if(sync_2 == 1'b0)
	   end // case: START
    
    DATA: begin
    if(sample_cnt_nxt == 15) begin
    sample_cnt_nxt = 4'h0;
    rx_shift_nxt = {sync_2, rx_shift_nxt[7:1]};
    if(rx_bit_cnt == 7) begin
    if(parity_en) 
    next_state = PARITY;
    else 
    next_state = STOP;
		 end else begin
    rx_bit_cnt_nxt = rx_bit_cnt_nxt;
		 end
	      end // if (sample_cnt_nxt == 15)
    
	   end // case: DATA
    
    PARITY: begin
    next_state = STOP;
	   end
    
    STOP: begin
    if(sample_cnt_nxt == 15 && sync_2) begin
    next_state = DONE;
	      end else begin
    sample_cnt_nxt = sample_cnt_nxt + 1;
	      end
	   end
    
    
    DONE: begin
    rx_valid_nxt = 1'b1;
    rx_data_nxt = rx_shift_nxt;
    next_state = IDLE;
	   end
	 endcase // case (current_state)
      end // if (baud_tick_16x)
   end // always_comb
    

    // Receiver FSM regsiter logic 
    // always_ff@(posedge clk or negedge rst_n) begin
    always_ff@(posedge baud_tick_16x or negedge rst_n) begin
    if(~rst_n) begin
    rx_data <= 8'h0;
    rx_valid <= 1'b0;
    sample_cnt <= 4'h0;
    rx_bit_cnt <= 3'h0;
    current_state <= IDLE;
      end else begin
    rx_data <= rx_data_nxt;
    rx_valid <= rx_valid_nxt;
    sample_cnt <= sample_cnt_nxt;
    rx_bit_cnt <= rx_bit_cnt_nxt;
    current_state <= next_state;
      end
   end

    
    */

endmodule
