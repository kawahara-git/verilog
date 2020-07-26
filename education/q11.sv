`define CLK_4M 250000 //250000ps = 10ns

`timescale 1ps/1ps

`default_nettype none

/***************************************************
 * Testbench
 ***************************************************/

module testbench;
  reg          CLK;
  wire [ 3: 0] Q;

// CLK
  always #(`CLK_4M/2) begin
    CLK = ~CLK;
  end

// initial setting
  initial begin
    CLK = 1'b1;
     # 10000000000000;
    $finish();
  end

  msec_counter u_msec_counter
    (
     .clk_4m ( CLK ),
     .Q
     );

  initial begin
    $monitor($time," : Q=%d",Q);
  end
           
endmodule
