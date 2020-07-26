`default_nettype none

/***************************************************
 * Counter & 7SegLED
 ***************************************************/

module segLEDdec
  (
   input wire         CLK,
   input wire         XRST,        
   output reg [ 7: 0] LED
   );
    
/***************************************************
 * Counter
 ***************************************************/
  wire [ 3: 0] Q;

  counter u_counter
    (
     .CLK,
     .XRST,
     .Q
     );

/***************************************************
 * 7SegLED
 ***************************************************/
  segLED u_segLED
    (
     .data( Q ),
     .LED
     );

endmodule

`default_nettype wire
