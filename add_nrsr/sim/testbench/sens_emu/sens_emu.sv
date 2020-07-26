// ========================================================================
// ModuleName   : sens_emu
// Designer     : 
// Function     : Emulate Sensoer for D216_sdi72M
// Prefix       : 
// ========================================================================

`default_nettype none

 //`include "fe_sens_bus_t.h"
  
  module sens_emu
    (
     // clock *************************************************************
     input  wire          clk_sens,
     
     // reset *************************************************************
     input  wire          xreset,

     // output ************************************************************
     output  wire       	 sens_h_start,
     output  wire      	  	 sens_v_start,
     output  wire      	  	 sens_h_blank,
     output  wire      	  	 sens_v_blank,
     output  wire [ 3: 0][13: 0] sens_pix_data
     );

  // ***** Parameter ******************************************************	  
  localparam  SENS_HOB_PIXEL_LENGTH = 11'd38;			//	152pix /4 = 38
  localparam  SENS_PIXEL_LENGTH = 11'd540;			//	2160pix /4 = 540

  localparam  SENS_NULL_LINE_LENGTH = 11'd8;        		//  8Line
  localparam  SENS_VOB_LINE_LENGTH = 11'd80;        		//  80Line
  localparam  SENS_VALID_LINE_LENGTH = 11'd1080;	      	//  1080Line
  //pre
  localparam  SENS_BLANK_LINE_LENGTH = 11'd40;			//  40Line
  
  // ***** Internal Signal ***********************************************
  wire [10: 0] pix_max;
  wire [10: 0] line_max;
  wire [10: 0] pix_valid_th;
  wire [10: 0] line_valid_th1;
  wire [10: 0] line_valid_th2;

  reg          h_start = 1'b0;
  reg          v_start = 1'b0;
  reg          h_blank = 1'b1;
  reg          v_blank = 1'b1;

  assign      pix_valid_th = SENS_HOB_PIXEL_LENGTH - 1'b1;
  assign      pix_max = SENS_PIXEL_LENGTH - 1'b1;
  assign      line_valid_th1 = SENS_NULL_LINE_LENGTH + SENS_VOB_LINE_LENGTH;
  assign      line_valid_th2 = line_valid_th1 + SENS_VALID_LINE_LENGTH;
  assign      line_max = line_valid_th2 + SENS_BLANK_LINE_LENGTH;  

  // ***** pix count ***************************************************
  reg  [10: 0] pix_count = 11'd0;

  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      pix_count <= 11'd0;
    end
    else begin
      if( pix_count == pix_max ) begin
        pix_count <= 11'd0;
      end
      else begin
        pix_count <= pix_count + 1'b1;
      end
    end
  end

  // ***** line count ****************************************************
  reg  [10: 0] line_count = 11'd1;

  always @( posedge clk_sens ) begin
    if( xreset == 1'b0 ) begin
      line_count <= 11'd1;
    end
    else if( pix_count == pix_max ) begin
      if( line_count == line_max ) begin
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
    if( line_count <= line_valid_th1 ) begin
      v_blank <= 1'b1;
    end
    else if( line_count <= line_valid_th2 ) begin
      v_blank <= 1'b0;
    end
    else begin
      v_blank <= 1'b1;
    end
  end

  // ***** pix_data *****************************************************
  reg [ 3: 0][13: 0] pix_data = 56'd0;
  reg  [10: 0] pix_count_d = 11'd0;
  reg  [10: 0] line_count_d = 11'd1;

  always @( posedge clk_sens) begin
    pix_count_d <= pix_count;
    line_count_d <= line_count;
    pix_data[0] <= {3'd0,pix_count_d};
    pix_data[1] <= {3'd0,pix_count_d};
    pix_data[2] <= {3'd0,line_count_d};
    pix_data[3] <= {3'd0,line_count_d};
  end

  //for debug  
  wire       [13: 0] pix_count_data;
  wire       [13: 0] line_count_data;

  assign pix_count_data = pix_data[0];
  assign line_count_data = pix_data[2];

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
  assign    sens_h_start = h_start_d;  
  assign    sens_v_start = v_start_d;
  assign    sens_h_blank = h_blank_d;
  assign    sens_v_blank = v_blank_d;
  assign    sens_pix_data = pix_data;
  
endmodule

`default_nettype wire
