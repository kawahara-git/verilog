`define CLK_100M 10000 //10000ps

`timescale 1ps/1ps

`default_nettype none

module tb_top;
  //input
  reg         clk_100m;
  //  reg         xreset;
  //output
  wire [ 3: 0][13: 0] data;

  initial begin
    clk_100m = 1'b1;
    // xreset = 1'b0;
    // #(`CLK_100M/2);
    // xreset = 1'b1;
  end

  //CLK
  always #(`CLK_100M/2) begin
    clk_100m = ~clk_100m;
  end

  randomgen u_randomgen
    (
     .clk(clk_100m),
     .data
     );

  initial begin
    #100000 $finish();
  end

  initial begin
    $monitor($time," : data0=%d",data[0]);
    $monitor($time," : data1=%d",data[1]);
    $monitor($time," : data2=%d",data[2]);
    $monitor($time," : data3=%d",data[3]);
    $dumpfile("randomgen.vcd");
    $dumpvars(0,u_randomgen);
  end

  // integer        file;

  // initial begin
  //   file=$fopen("test.csv","w+");
  //   $fdisplay(file,"1,2,3,4,5");
  //   $fclose(file);
  // end
           
endmodule
