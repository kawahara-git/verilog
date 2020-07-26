`default_nettype none

/***************************************************
 * Counter
 ***************************************************/

module counter
  (
   input wire         CLK,
   input wire         XRST,
   output reg [ 3: 0] Q
   );

  always @(posedge CLK)  begin
    if (!XRST) begin
      Q <= 4'd0;
    end
    else begin
      Q <= Q + 4'd1;
    end
  end

endmodule
