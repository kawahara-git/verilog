`timescale 1ps / 1ps

`define CYCLE_100M       10000  // 1 CYCLE 10.000ns

`default_nettype none

module tb_top;
  reg           clk_100m;
  reg           xreset;
  reg           siggen_mode;

  // ***** Parameter ******************************************************	  
  localparam  H_RAMP_MODE = 1'b0;
  localparam  V_RAMP_MODE = 1'b1;

  initial begin
    clk_100m = 1'b1;
    xreset = 1'b0;
    siggen_mode = H_RAMP_MODE;

    #1000000;

    xreset = 1'b1;
  end

  // ===== Generate Clock =================================================
  always #(`CYCLE_100M / 2) begin
    clk_100m = ~clk_100m;
  end

  // ======================================================================
  //  Instance u_siggen
  // ======================================================================
  wire		siggen_hd;
  wire		siggen_de;
  wire [ 7: 0]  siggen_d;

  siggen u_siggen
    (
     .clk	               ( clk_100m    ),
     .xreset                   ( xreset      ),
     .mode_sel		       ( siggen_mode ),
     .siggen_hd,
     .siggen_de,
     .siggen_d,
     );

  // ======================================================================
  //  Instance u_linemem
  // ======================================================================
  wire		linemem_hd;
  wire         	linemem_de;
  wire [ 7: 0]	linemem_qa;
  wire [ 7: 0] 	linemem_qb;

  linemem u_linemem
    (
     .rstx		( xreset	),
     .clk        	( clk_100m	),
     .hd    		( siggen_hd 	),
     .de    		( siggen_de 	),
     .d    		( siggen_d 	),
     .hdo		( linemem_hd	),
     .deo		( linemem_de	),
     .qa	       	( linemem_qa	),
     .qb		( linemem_qb	)
     );

endmodule

`default_nettype wire
