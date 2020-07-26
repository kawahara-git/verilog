`define CLK_100M 10000 //10000ps = 10ns
`timescale 1ps/1ps

`default_nettype none

/***************************************************
 * Testbench
 ***************************************************/

module testbench;
  reg          CLK;
  reg          XRST;
  reg  [ 1: 0] MODE;
  wire [ 7: 0] DATA;

// CLK
  always #(`CLK_100M/2) begin
    CLK = ~CLK;
  end

  mode_selector u_mode_selector
    (
     .xrst ( XRST     ),
     .clk  ( CLK      ),
     .mode ( MODE     ),
     .data ( DATA     )
     );

  integer        file;
  reg [ 1: 0] tpat_mode[0:0];
  
  initial begin  
    $readmemb("testcase.inc", tpat_mode);
    $display("%b",tpat_mode[0]);
    file=$fopen("testcase.csv","w");
    CLK = 1'b1;
    XRST = 1'b0;
    MODE = tpat_mode[0];
    # (`CLK_100M/2);    
    XRST = 1'b1;
  end

  reg [ 9: 0] count = 10'd0;

  always @(posedge CLK) begin
    if(XRST == 1'b0) begin
      count <= 10'd0;
    end
    else begin
      count <= count + 10'd1;
    end
  end
  
  always @(posedge CLK) begin
    if(count == 10'd1000) begin
      $fclose(file);
      $finish();
    end
    else begin
      // NOP
    end
  end

  always @(posedge CLK) begin
    
    $fdisplay(file,"%02x",DATA);
  end

  initial begin
    $dumpfile("mode_selector.vcd");
    $dumpvars(0,u_mode_selector);
  end
           
endmodule

`default_nettype wire
