`default_nettype none

/***************************************************
 * Comb
 ***************************************************/

module comb
  (
   input wire a,
   input wire b,
   input wire c,
   output wire x
   );

  assign x = (a | b) & ~c;

endmodule
