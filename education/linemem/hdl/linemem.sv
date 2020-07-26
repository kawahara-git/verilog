// ***********************************************
// ModuleName   : linemem
// Designer     : Kawahara
// Function     : 
// Prefix       : 
// ***********************************************

`default_nettype none

  module linemem
    (
     // input **************************************************
     input  wire           rstx,
     input  wire           clk,
     input  wire           hd,
     input  wire           de,
     input  wire [ 7: 0]   d,

     // output **************************************************
     output  wire           hdo,
     output  wire           deo,
     output  wire [ 7: 0]   qa,
     output  wire [ 7: 0]   qb

     );

  // Parameter **************************************************
  localparam  VALID_PIX = 10'd256;
  
  // count pix **************************************************
  reg	[ 7: 0]	count_pix = 8'd0;

  always @(posedge clk) begin
    if(rstx == 1'b0) begin
      count_pix <= 10'd0;
    end
    else begin
      if(hd == 1'b1) begin
        count_pix <= 10'd0;
      end
      else begin
        if(de == 1'b1) begin
          if(count_pix < (VALID_PIX - 1'b1)) begin
            count_pix <= count_pix + 10'd1;
          end
          else begin
            // NOP
          end
        end
        else begin
          //NOP
        end
      end
    end
  end

  // linemem_enable **************************************************
  reg	linemem_enable = 1'b0;

  always @(posedge clk) begin
    if(rstx == 1'b0) begin
      linemem_enable <= 1'b0;
    end
    else begin
      if(de == 1'b1) begin
        linemem_enable <= 1'b1;
      end
      else begin
        linemem_enable <= 1'b0;
      end
    end
  end
  
  // linemem_wirte_enable **************************************************
  wire	linemem_write_enable;
  reg	linemem_enable_d = 1'b0;
  reg	linemem_enable_2d = 1'b0;

  always @(posedge clk) begin
     linemem_enable_d <= linemem_enable;
     linemem_enable_2d <= linemem_enable_d;
  end

  assign	linemem_write_enable = linemem_enable_2d;

  // linemem_read_enable **************************************************
  wire	linemem_read_enable;

  assign	linemem_read_enable = linemem_enable | linemem_enable_d;

  // data delay **************************************************
  reg [ 7: 0] data_d = 8'd0;
  reg [ 7: 0] data_2d = 8'd0;
  reg [ 7: 0] data_3d = 8'd0;

  always @(posedge clk) begin
    data_d <= d;
    data_2d <= data_d;
    data_3d <= data_2d;
  end

  // count_pix delay **************************************************
  reg	[ 7: 0]	count_pix_d = 8'd0;
  reg	[ 7: 0]	count_pix_2d = 8'd0;
  reg	[ 7: 0]	count_pix_3d = 8'd0;

  always @(posedge clk) begin
     count_pix_d <= count_pix;
     count_pix_2d <= count_pix_d;
     count_pix_3d <= count_pix_2d;
  end

  // linemem_write_address **************************************************
  wire	[ 7: 0]	linemem_write_address;

  assign	linemem_write_address = count_pix_3d;

  // linemem_read_address **************************************************
  wire	[ 7: 0]	linemem_read_address;

  assign	linemem_read_address = count_pix_d;

  // ===========================================================================
  //  Instance u_ram_linemem
  // ===========================================================================
  wire [ 7: 0] linemem_data;

  ram_8x256_blk_mem_gen_0_1 u_linemem
    (
     .clka  ( clk 	               	),
     .ena   ( linemem_write_enable 	),
     .wea   ( linemem_write_enable    	),
     .addra ( linemem_write_address	),
     .dina  ( data_d		        ),
     .clkb  ( clk                     	),
     .enb   ( linemem_read_enable       ),
     .addrb ( linemem_read_address  	),
     .doutb ( linemem_data 		)
     );

  // delay hd,de **************************************************
  reg  [ 2: 0] hd_d = 3'd0;
  reg  [ 2: 0] de_d = 3'd0;
  wire	       hd_3d;
  wire	       de_3d;

  always @( posedge clk ) begin
    hd_d <= { hd_d[1:0], hd };
    de_d <= { de_d[1:0], de };
  end

  assign      	hd_3d = hd_d[2];
  assign	de_3d = de_d[2];

  // output **************************************************
  always @( posedge clk ) begin
    if(rstx == 1'b0) begin
      hdo <= 1'b0;
      deo <= 1'b0;
      qa <= 8'd0;
      qb <= 8'd0;
    end
    else begin
      hdo <= hd_3d;
      deo <= de_3d;
      qa <= data_3d;
      qb <= linemem_data;
    end
  end

  // assign  hdo = hd_3d;
  // assign  deo = de_3d;
  // assign  qa = data_3d;
  // assign  qb = linemem_data;
  
endmodule

`default_nettype wire
