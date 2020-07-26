`default_nettype none

/***************************************************
 * Up Down Counter
 ***************************************************/

module mode_selector
  (
   input wire         xrst,
   input wire         clk,
   input wire [ 1: 0] mode,
   output reg [ 7: 0] data = 8'd0
   );

  reg 	[ 7: 0]	count = 8'd0;

  always @(posedge clk) begin
    if (!xrst) begin
      count <= 8'd0;
    end
    else begin
      count <= count + 8'd1;
    end
  end

  always @(posedge clk) begin
    if (!xrst) begin
      data <= 8'd0;
    end
    else if (mode == 2'd1) begin
      data <= count;
    end
    else if (mode == 2'd2) begin
      data <= 8'd2;
    end
    else if (mode == 2'd3) begin
      data <= 8'd3;
    end
    else begin
      data <= 8'd0;
    end
  end

endmodule

`default_nettype wire
