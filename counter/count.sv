`default_nettype none

/********************
 * Module
 ********************/

module counter
  (
   input   wire         clk_100m,
   input   wire         xreset,
   output  reg  [ 3: 0] count = 4'd0
   );

  always @(posedge clk_100m)  begin
    if (!xreset) begin
      count <= 4'd0;
    end
    else begin
      count <= count + 4'd1;
      //$monitor($time," : count=%d",count);
    end
  end

endmodule
