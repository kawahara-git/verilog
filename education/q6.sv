`default_nettype none

/***************************************************
 * 7SegLED
 ***************************************************/

module segLED
  (
   input wire [ 3: 0] data,
   output reg [ 7: 0] LED
   );
    
    always @(*) begin
        case(data)
          4'd0 : LED = 8'b00000011;
          4'd1 : LED = 8'b00111111;
          4'd2 : LED = 8'b01001001;
          4'd3 : LED = 8'b00011001;
          4'd4 : LED = 8'b00110101;
          4'd5 : LED = 8'b10010001;
          4'd6 : LED = 8'b10000001;
          4'd7 : LED = 8'b00111011;          
          4'd8 : LED = 8'b00000001;
          4'd9 : LED = 8'b00010001;
          default : LED = 8'bxxxxxxxx; 
        endcase
    end

endmodule

`default_nettype wire
