`default_nettype none

/***************************************************
 * Counter
 ***************************************************/

module sec_counter
  (
   input wire         clk_6m,
   input wire         xrst,
   output reg [ 7: 0] Q
   );

  reg [22: 0]	count = 23'd1;

  always @(posedge clk_6m)  begin
    if (!xrst) begin
      Q <= 8'd0;
      count <= 23'd1;
    end
    else begin
      if (count == 23'd6000000) begin
        Q <= Q + 8'd1;
        count <= 23'd1;
      end
      else begin
        count <= count + 1'b1;
      end
    end
  end

endmodule

`default_nettype wire
