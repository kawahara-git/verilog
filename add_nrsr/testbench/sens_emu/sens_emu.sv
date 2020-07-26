// ========================================================================
// ModuleName   : sens_emu
// Designer     : 
// Function     : Emulate Sensoer for D216_sdi72M
// Prefix       : 
// ========================================================================

`default_nettype none

 `include "./fe_sens_bus_t.h"
  
  module sens_emu
    (
     // clock *************************************************************
     input  wire          clk_sens,
     
     // reset *************************************************************
     input  wire          xreset,

     // output ************************************************************
     output fe_sens_bus_t fe_sens_bus_out
     );

  // ***** Parameter ******************************************************	  
  localparam  SENS_HOB_PIXEL_LENGTH = 11'd38;		//	152pix /4 = 38
  localparam  SENS_PIXEL_LENGTH = 11'd540;			//	2160pix /4 = 540	

  localparam  SENS_NULL_LINE_LENGTH = 11'd8;        //  8Line
  localparam  SENS_VOB_LINE_LENGTH = 11'd80;        //  80Line
  localparam  SENS_LINE_LENGTH = 11'd1168;			//	1168Line
  
  // ***** Internal Signal ***********************************************
  reg  [10: 0] pix_count = 11'd1;
  reg  [10: 0] line_count = 11'd1;
  wire [10: 0] pix_max;
  wire [10: 0] line_max;
  wire [10: 0] pix_valid_th;
  wire [10: 0] line_valid_th;

  reg          h_start = 1'b0;
  reg          v_start = 1'b0;
  reg          h_blank = 1'b1;
  reg          v_blank = 1'b1;

  assign      pix_max = SENS_PIXEL_LENGTH - 1'b1;
  assign      pix_valid_th = SENS_HOB_PIXEL_LENGTH - 1'b1;
  assign      line_max = SENS_LINE_LENGTH;
  assign      line_valid_th = SENS_NULL_LINE_LENGTH + SENS_VOB_LINE_LENGTH;
  
  // ***** pix count ***************************************************
  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      pix_count <= 11'd0;
    end
    else begin
      if( pix_max <= pix_count ) begin
        pix_count <= 11'd0;
      end
      else begin
        pix_count <= pix_count + 1'b1;
      end
    end
  end

  // ***** line count ****************************************************
  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      line_count <= 11'd1;
    end
    else if( pix_max <= pix_count ) begin
      if( line_max <= line_count ) begin
        line_count <= 11'd1;
      end
      else begin
        line_count <= line_count + 1'b1;
      end
    end
    else begin
      //NOP
    end
  end

  // ***** h_start *******************************************************
  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      h_start <= 1'b0;
    end
    else begin
      if( pix_count == pix_max ) begin
        h_start <= 1'b1;
      end
      else begin
        h_start <= 1'b0;
      end
    end
  end
  
  // ***** v_start *******************************************************
  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      v_start <= 1'b0;
    end
    else if( line_count == line_max ) begin
      if( pix_count == pix_max ) begin
        v_start <= 1'b1;
      end
      else begin
        v_start <= 1'b0;
      end
    end
    else begin
      v_start <= 1'b0;
    end
  end
  
  // ***** h_blank *******************************************************
  always @( posedge clk_sens ) begin
    if( pix_count <= pix_valid_th ) begin
      h_blank <= 1'b1;
    end
    else begin
      h_blank <= 1'b0;
    end
  end
  
  // ***** v_blank *******************************************************
  always @( posedge clk_sens ) begin
    if( line_count <= line_valid_th ) begin
      v_blank <= 1'b1;
    end
    else begin
      v_blank <= 1'b0;
    end
  end

  // ***** pix_data *****************************************************
  reg [ 3: 0][13: 0] pix_data;
  wire       [13: 0] count;

  assign count = {3'd0,pix_count};

  always @( posedge clk_sens) begin
    if( h_blank == 1'b0 &&
        v_blank == 1'b0) begin
      pix_data <= '{4{count}};
    end
    else begin
      pix_data <= '{4{14'd0}};
    end
  end            

  // ***** ssg delay ***********************************************
  reg          h_start_d = 1'b0;
  reg          v_start_d = 1'b0;
  reg          h_blank_d = 1'b1;
  reg          v_blank_d = 1'b1;  

  always @( posedge clk_sens) begin
    h_start_d <= h_start;
    v_start_d <= v_start;
    h_blank_d <= h_blank;
    v_blank_d <= v_blank;
  end

  // ***** output *******************************************************
  assign    fe_sens_bus_out.h_start = h_start_d;  
  assign    fe_sens_bus_out.v_start = v_start_d;
  assign    fe_sens_bus_out.h_blank = h_blank_d;
  assign    fe_sens_bus_out.v_blank = v_blank_d;
  assign	fe_sens_bus_out.pix_data = pix_data;
  
endmodule

`default_nettype wire
