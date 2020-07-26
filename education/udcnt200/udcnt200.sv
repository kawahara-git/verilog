`default_nettype none

/***************************************************
 * Up Down Counter
 ***************************************************/

module udcnt200
  (
   input wire         rstx,
   input wire         clk,
   input wire	      upx,
   input wire	      ena,
   output reg [ 7: 0] q = 8'd0
   );

  always @(posedge clk) begin
    if (!rstx) begin
      q <= 8'd0;
    end
    else if (!ena) begin
      //NOP
    end
    else begin
      if(upx == 1'b0) begin
        if (q == 8'd199) begin
          q <= 8'd0;
        end
        else begin
          q <= q + 1'b1;
        end
      end
      else begin
        if (q == 8'd0) begin
          q <= 8'd199;
        end
        else begin
          q <= q - 1'b1;
        end
      end
    end
  end

endmodule

`default_nettype wire