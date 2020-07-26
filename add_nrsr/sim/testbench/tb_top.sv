`timescale 1ps / 1ps

`define CYCLE_72M       13889  // 1 CYCLE 13.889ns

`default_nettype none

//`include "fe_sens_bus_t.h"

module tb_top;
  // ===== Singnal ========================================================
  // clock ****************************************************************
  reg           clk_72m;
  reg           xreset;

  // sens_emu *************************************************************
  wire       	 	sens_h_start;
  wire      	       	sens_v_start;
  wire      	    	sens_h_blank;
  wire      	     	sens_v_blank;
  wire [ 3: 0][13: 0] 	sens_pix_data;

  //fe_sens_bus_t fe_sens_bus_out;
  
  // ===== Initial ========================================================
  initial begin
    clk_72m = 1'b1;
    xreset = 1'b0;

    #1000000;

    xreset = 1'b1;

    #100000000000;

    $finish();
  end

  // ===== Generate Clock =================================================
  always #(`CYCLE_72M / 2) begin
    clk_72m = ~clk_72m;
  end

  // ======================================================================
  //  Instance u_sensor
  // ======================================================================
  sens_emu u_sens_emu
    (
     .clk_sens                 ( clk_72m       ),
     .xreset                   ( xreset        ),
     .sens_h_start             ( sens_h_start  ),
     .sens_v_start             ( sens_v_start  ),
     .sens_h_blank             ( sens_h_blank  ),
     .sens_v_blank             ( sens_v_blank  ),
     .sens_pix_data            ( sens_pix_data )
     );

  // ======================================================================
  //  Instance u_addnrsr
  // ======================================================================
  
  add_nrsr u_add_nrsr
    (
     .clk_72m        		  ( clk_72m          ),
     //.sens_bus_in    ( fe_sens_bus      ),
     //.sens_bus_out   ( fe_sens_bus_out  )
     .sens_h_start_in             ( sens_h_start     ),
     .sens_v_start_in             ( sens_v_start     ),
     .sens_h_blank_in             ( sens_h_blank     ),
     .sens_v_blank_in             ( sens_v_blank     ),
     .sens_pix_data_in            ( sens_pix_data    )

     );

  initial begin
    $dumpfile("add_nrsr.vcd");
    $dumpvars(0,u_add_nrsr);
  end

  // reg [11: 0] counter = 12'd0;

  // always @( posedge clk_72m ) begin
  //   counter <= counter + 1'b1;
  // end

endmodule

`default_nettype wire
