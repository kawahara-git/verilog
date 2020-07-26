`timescale 1ps / 1ps

`define CYCLE_72M       13889  // 1 CYCLE 13.889ns

`default_nettype none

`include "fe_sens_bus_t.h"

module tb_top;
  // ===== Singnal ========================================================
  // clock ****************************************************************
  reg           clk_72m;
  reg           xreset;

  // sens_emu *************************************************************
  fe_sens_bus_t fe_sens_bus;
  fe_sens_bus_t fe_sens_bus_out;
  
  // ===== Initial ========================================================
  initial begin
    clk_72m = 1'b1;
    xreset = 1'b0;

    #1000000;

    xreset = 1'b1;
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
     .clk_sens                 ( clk_72m     ),
     .xreset                   ( xreset      ),
     .fe_sens_bus_out          ( fe_sens_bus )
     );

  // ======================================================================
  //  Instance u_addnrsr
  // ======================================================================
  
  add_nrsr u_add_nrsr
    (
     .clk_72m        ( clk_72m          ),
     .sens_bus_in    ( fe_sens_bus      ),
     .sens_bus_out   ( fe_sens_bus_out  )
     
     );

  reg [11: 0] counter = 12'd0;

  always @( posedge clk_72m ) begin
    counter <= counter + 1'b1;
  end

endmodule

`default_nettype wire
