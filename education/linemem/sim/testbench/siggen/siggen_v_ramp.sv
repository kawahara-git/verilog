`default_nettype none
  
  module siggen_v_ramp
    (
     // input *************************************************************
     input  wire          clk,
     input  wire          xreset,
     input  wire          siggen_hd_in,
     input  wire          siggen_de_in,

     // output ************************************************************
     output wire 	  siggen_hd,
     output wire 	  siggen_de,
     output wire [ 7: 0]  siggen_d
     );

  // siggen_d **************************************************
  reg	[ 7: 0]	reg_d = 8'd0;

  always @(posedge clk) begin
    if(xreset == 1'b0) begin
      reg_d <= 8'd0;
    end
    else begin
      if(siggen_hd_in == 1'b1) begin
        reg_d <= reg_d + 8'd1;
      end
      else begin
        //NOP
      end
    end
  end

  // ***** output *******************************************************
  assign    siggen_hd = siggen_hd_in;
  assign    siggen_de = siggen_de_in;
  assign    siggen_d = reg_d;
  
endmodule

`default_nettype wire
