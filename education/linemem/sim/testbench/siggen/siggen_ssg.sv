`default_nettype none
  
  module siggen_ssg
    (
     // input *************************************************************
     input  wire          clk,
     input  wire          xreset,

     // output ************************************************************
     output wire 	  siggen_hd,
     output wire 	  siggen_de
     );

  // ***** Parameter ***************a***************************************	  
  localparam  LINE_DATA = 9'd288;
  localparam  BLANK_DATA = 9'd16;
  localparam  VALID_DATA = 9'd256;

  // counter **************************************************
  reg	[ 8: 0]	count = 9'd0;

  always @(posedge clk) begin
    if(xreset == 1'b0) begin
      count <= 9'd0;
    end
    else begin
      if(count == ( LINE_DATA - 1'b1)) begin
        count <= 9'd0;
      end
      else begin
        count <= count + 9'd1;
      end
    end
  end

  // ***** siggen_hd ***************************************************
  reg	reg_hd = 1'b0;

  always @( posedge clk ) begin
    if( xreset == 1'b0 ) begin
      reg_hd <= 1'b0;
    end
    else begin
      if(count == 9'd0) begin
        reg_hd <= 1'b1;
      end
      else begin
        reg_hd <= 1'b0;
      end
    end
  end

  // ***** siggen_de ***************************************************
  reg	reg_de = 1'b0;

  always @( posedge clk ) begin
    if( xreset == 1'b0 ) begin
      reg_de <= 1'b0;
    end
    else begin
      if(count <= BLANK_DATA) begin
        reg_de <= 1'b0;
      end
      if(count <= (BLANK_DATA + VALID_DATA)) begin
        reg_de <= 1'b1;
      end
      else begin
        reg_de <= 1'b0;
      end
    end
  end

  // ***** output *******************************************************
  assign    siggen_hd = reg_hd;
  assign    siggen_de = reg_de;
  
endmodule

`default_nettype wire
