`default_nettype none
  
  module siggen
    (
     // input *************************************************************
     input  wire          clk,
     input  wire          xreset,
     input  wire          mode_sel,

     // output ************************************************************
     output wire 	  siggen_hd,
     output wire 	  siggen_de,
     output wire [ 7: 0]  siggen_d
     );

  // ***** Parameter ******************************************************	  
  localparam  H_RAMP_MODE = 1'b0;
  localparam  V_RAMP_MODE = 1'b1;

  // ======================================================================
  //  Instance u_siggen_ssg
  // ======================================================================
  wire	siggen_ssg_hd;
  wire	siggen_ssg_de;

  siggen_h_ramp u_siggen_h_ramp
    (
     .clk,
     .xreset,
     .siggen_hd	( siggen_ssg_hd ),
     .siggen_de	( siggen_ssg_de )
     );

  // ======================================================================
  //  Instance u_siggen_h_ramp
  // ======================================================================
  wire		siggen_h_ramp_hd;
  wire		siggen_h_ramp_de;
  wire [ 7: 0]  siggen_h_ramp_d;

  siggen_h_ramp u_siggen_h_ramp
    (
     .clk,
     .xreset,
     .siggen_hd_in	( siggen_ssg_hd ),
     .siggen_de_in	( siggen_ssg_de ),
     .siggen_hd		( siggen_h_ramp_hd ),
     .siggen_de		( siggen_h_ramp_de ),
     .siggen_d		( siggen_h_ramp_d )
     );

  // ======================================================================
  //  Instance u_siggen_v_ramp
  // ======================================================================
  wire		siggen_v_ramp_hd;
  wire		siggen_v_ramp_de;
  wire [ 7: 0]  siggen_v_ramp_d;

  siggen_h_ramp u_siggen_h_ramp
    (
     .clk,
     .xreset,
     .siggen_hd_in	( siggen_ssg_hd ),
     .siggen_de_in	( siggen_ssg_de ),
     .siggen_hd		( siggen_v_ramp_hd ),
     .siggen_de		( siggen_v_ramp_de ),
     .siggen_d		( siggen_v_ramp_d )
     );

  // ***** output ***************************************************
  always @( * ) begin
    if( mode_sel == 1'b0 ) begin
      siggen_hd <= siggen_h_ramp_hd;
      siggen_de <= siggen_h_ramp_de;
      siggen_d <= siggen_h_ramp_d;
    end
    else begin
      siggen_hd <= siggen_v_ramp_hd;
      siggen_de <= siggen_v_ramp_de;
      siggen_d <= siggen_v_ramp_d;
    end
  end
  
endmodule

`default_nettype wire
