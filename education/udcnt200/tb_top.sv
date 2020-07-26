`define CLK_100M 10000 //10000ps = 10ns
`timescale 1ps/1ps

`default_nettype none

/***************************************************
 * Testbench
 ***************************************************/

module testbench;
  reg          CLK;
  reg          XRST;
  reg	       UPX;
  reg	       COUNT_EN;
  wire [ 7: 0] Q;

// CLK
  always #(`CLK_100M/2) begin
    CLK = ~CLK;
  end

  udcnt200 u_udcnt200
    (
     .rstx ( XRST     ),
     .clk  ( CLK      ),
     .upx  ( UPX      ),
     .ena  ( COUNT_EN ),
     .q    ( Q        )
     );


  `include "testcase.inc"

  initial begin
    $dumpfile("udcnt200.vcd");
    $dumpvars(0,u_udcnt200);
  end
           
endmodule
