module uart_tx (
		input logic 	  clk,
		input logic 	  rst_n,
		input logic 	  tx_start,
		input logic [7:0] data_in,
		input logic 	  parity_en, // Enable signal for parity bit
		input logic 	  even_odd_parity, // Indicates it is even or odd parity
		input logic [1:0] data_bit_len, // 00 -5 bits, 01 - 6 bits, 10 - 7 bits, 11 -8 bits
		input logic 	  num_of_stop_bits, // Number of stop bits, 0 - 1 stop bit, 1 - 2 stop bit
		output logic 	  sout
		);



   // TX Buffer
   logic [7:0] 			  tx_buffer;

   // Other internal signals
   logic [3:0] 			  tx_cnt;
   logic 			  parity_val;
   logic [3:0] 			  tx_data_len;

   assign tx_data_len = (data_bit_len == 2'b00) ? 4'b0101: (data_bit_len == 2'b01) ? 4'b0110 :
	   		(data_bit_len == 2'b10) ? 4'b0111: (data_bit_len == 2'b11) ? 4'b1000 : 4'b1000;
   // TX FSM state declaration
   typedef enum 		  logic [2:0] {
					       IDLE 	= 3'b000, 
					       START 	= 3'b001, 
					       TX_DATA  = 3'b010, 
					       PARITY 	= 3'b011,
					       STOP 	= 3'b100 
					       } fsm_state_e;

   fsm_state_e current_state, next_state;



   // Parity calculation logic
   assign parity_val = (parity_en) ? ^tx_buffer : 8'h00;

   // Combinational next state generation logic 

   always_comb begin
      next_state = current_state;

      case(current_state) 
	IDLE	:  
	  begin 
	     if(tx_start) next_state = START;
	  end
 	START	:  
	  next_state = TX_DATA;
	TX_DATA : 
	  begin  
	     if(tx_cnt == tx_data_len) begin
		if(parity_en) 
		  next_state = PARITY;
		else 
		  next_state = STOP;
	     end
             else begin
		next_state = TX_DATA;
	     end	     
	  end
	PARITY	: begin
	  next_state = STOP;
  	end
	STOP : begin 
	   if(num_of_stop_bits) next_state = STOP;
	   else next_state = IDLE;
	end
	default :; 
      endcase 
   end

   // Bit counter for logic 
   always_ff@(posedge clk or negedge rst_n) begin
      if(~rst_n) 
	tx_cnt <= 4'b0;
      else if(current_state == TX_DATA)
	tx_cnt <= tx_cnt + 1;
      else if(current_state == IDLE)
	tx_cnt <= 4'd0;
      else 
	tx_cnt <= 4'd0;
   end


   // Shift register logic
   always_ff@(posedge clk or negedge rst_n) begin
      if(~rst_n) begin 
	 tx_buffer <= 8'h00;
      end else if (current_state == IDLE && tx_start) begin
	 tx_buffer <= data_in;
      end else if (current_state == TX_DATA) begin
	 tx_buffer <= {1'b0, tx_buffer[7:1]};
      end
   end


   // Output assignment on each state
   always_ff@(posedge clk or negedge rst_n) begin
      if(~rst_n) begin
	 sout <= 1'b1;
      end else if (current_state == IDLE) begin
	 sout <= 1'b1; 
      end else if (current_state == START) begin
	 sout <= 1'b0; 
      end else if (current_state == TX_DATA) begin
	 sout <= tx_buffer[0];
      end else if (current_state == PARITY) begin
	 sout <= parity_val;
      end else if (current_state == STOP) begin
	 sout <= 1'b1;
      end else begin
	 sout <= 1'b1;
      end
   end




   // FSM state register assignment
   always_ff@(posedge clk or negedge rst_n) begin
      if(~rst_n) begin
	 current_state <= IDLE;
      end else begin
	 current_state <= next_state;
      end
   end

endmodule
