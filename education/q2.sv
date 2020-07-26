`default_nettype none

/***************************************************
 * Adder
 ***************************************************/

module adder
  (
   input  wire [ 3: 0] A,
   input  wire [ 3: 0] B,
   output wire [ 3: 0] X,
   output wire     carry
   );
 
    assign {carry, X} = A + B;

endmodule
