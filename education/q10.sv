`default_nettype none

/***************************************************
 * Counter
 ***************************************************/

module msec_counter
  (
   input wire         clk_4m,
   output reg [ 3: 0] Q = 4'd1
    );

  // clk_1k **************************************************
  reg		clk_1k = 1'b1;
  reg [10: 0]	count = 11'd1;
  
  always @(posedge clk_4m) begin
    if (count == 11'd2000) begin
      clk_1k <= ~clk_1k;
      count <= 11'd1;
    end
    else begin
      count <= count + 1'b1;
    end
  end

  // data shift **************************************************
  
  always @(posedge clk_1k)  begin
    Q <= {Q[2:0],Q[3]};
  end

endmodule

`default_nettype wire
