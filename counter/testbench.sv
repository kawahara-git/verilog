`define CLK_100M 10000 //10000ps

`timescale 1ps/1ps

`default_nettype none

module testbench;
  //input
  reg         clk_100m;
  reg         xreset;
  //output
  wire [ 3: 0] count;

  initial begin
    clk_100m = 1'b1;
    xreset = 1'b0;
    #(`CLK_100M/2);
    xreset = 1'b1;
  end

  //CLK
  always #(`CLK_100M/2) begin
    clk_100m = ~clk_100m;
  end

  counter u_counter
    (
     .clk_100m,
     .xreset,
     .count
     );

  initial begin
    #100000 $finish();
  end

  initial begin
    $monitor($time," : count=%d",count);
    $dumpfile("counter_test.vcd");
    $dumpvars(0,u_counter);
  end

  integer        file;

  initial begin
    file=$fopen("test.csv","w+");
    $fdisplay(file,"1,2,3,4,5");
    $fclose(file);
  end
           
endmodule
