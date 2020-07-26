`define CLK_100M 10000 //10000ps = 10ns

`timescale 1ps/1ps

`default_nettype none

/***************************************************
 * Testbench
 ***************************************************/

module testbench;
    reg          CLK;
    reg          XRST;
    wire [ 3: 0] Q;

// CLK
    always #(`CLK_100M/2) begin
        CLK = ~CLK;
    end

// initial setting
    initial begin
        CLK = 1'b1;
        XRST = 1'b0;
        # 100000;
        XRST = 1'b1;
        # 1000000;
        $finish();
    end

  counter u_counter
    (
     .CLK,
     .XRST,
     .Q
     );

  initial begin
    $monitor($time," : Q=%d",Q);
    $dumpfile("counter_test.vcd");
    $dumpvars(0,u_counter);
  end

  // integer        file;

  // initial begin
  //   file=$fopen("test.csv","w+");
  //   $fdisplay(file,"1,2,3,4,5");
  //   $fclose(file);
  // end
           
endmodule
