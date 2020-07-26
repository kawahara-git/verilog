// ***********************************************
// ModuleName   : add_nrsr
// Designer     : Kawahara
// Function     : 
// Prefix       : 
// ***********************************************

`default_nettype none

//`include "./../../fe_sens_bus_t.h"

  module add_nrsr
    (
     // ==== Clock =============================================================
     input  wire           clk_72m,

     // ==== Input =============================================================
     //input  fe_sens_bus_t  sens_bus_in,
     input  wire   	    	 sens_h_start_in,
     input  wire      	  	 sens_v_start_in,
     input  wire      	  	 sens_h_blank_in,
     input  wire      	  	 sens_v_blank_in,
     input  wire [ 3: 0][13: 0]	 sens_pix_data_in

     // ==== Output ============================================================
     //output fe_sens_bus_t  sens_bus_out
     // output  wire       	 sens_h_start_out,
     // output  wire      	  	 sens_v_start_out,
     // output  wire      	  	 sens_h_blank_out,
     // output  wire      	  	 sens_v_blank_out,
     // output  wire [ 3: 0][13: 0] sens_pix_data_out
     );

  // Parameter **************************************************
  localparam  HEIGHT = 11'd1080;

  // assign **************************************************
  wire h_start;
  wire v_start;
  wire h_blank;
  wire v_blank;
  wire [ 3: 0][13: 0] pix_data;

  assign h_start = sens_h_start_in;
  assign v_start = sens_v_start_in;
  assign h_blank = sens_h_blank_in;
  assign v_blank = sens_v_blank_in;
  assign pix_data = sens_pix_data_in;

  // nedge v_blank ************************************************** 
  reg	v_blank_d = 1'b1;
  wire	nedge_v_blank;

  always @(posedge clk_72m) begin
     v_blank_d <= v_blank;
  end

  assign	nedge_v_blank = ~v_blank & v_blank_d;
  
  // count pix **************************************************
  reg	[ 9: 0]	count_pix = 10'd0;

  always @(posedge clk_72m) begin
    if(h_start == 1'b1) begin
      count_pix <= 10'd0;
    end
    else begin
      if(h_blank == 1'b0) begin
        count_pix <= count_pix + 10'd1;
      end
      else begin
      //NOP
      end
    end
  end

  // count line **************************************************
  reg	[10: 0]	count_line = 11'd1;

  always @(posedge clk_72m) begin
    if(nedge_v_blank == 1'b1) begin
      count_line <= 11'd1;
    end
    else begin
      if(h_start == 1'b1) begin
        count_line <= count_line + 11'd1;
      end
      else begin
      //NOP
      end
    end
  end

  // linemem_nrsr_0 write_enable **************************************************
  reg	write_enable_linemem_nrsr_0 = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if(count_line == 11'd1 ||
         count_line == HEIGHT - 11'd1) begin
        write_enable_linemem_nrsr_0 <= 1'b1;
      end
      else begin
        write_enable_linemem_nrsr_0 <= 1'b0;
      end
    end
    else begin
      write_enable_linemem_nrsr_0 <= 1'b0;
    end
  end
  
  // linemem_nrsr_1 write_enable **************************************************
  reg	write_enable_linemem_nrsr_1 = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if(count_line == 11'd2 ||
         count_line == HEIGHT) begin
        write_enable_linemem_nrsr_1 <= 1'b1;
      end
      else begin
        write_enable_linemem_nrsr_1 <= 1'b0;
      end
    end
    else begin
      write_enable_linemem_nrsr_1 <= 1'b0;
    end
  end

  // linemem_nrsr0 read_enable **************************************************
  reg	read_enable_linemem_nrsr_0 = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if((11'd3 <= count_line) &&
         (count_line <= 11'd8)) begin
        if(count_line[0] == 1'b1) begin
          read_enable_linemem_nrsr_0 <= 1'b1;
        end
        else begin
          read_enable_linemem_nrsr_0 <= 1'b0;
        end
      end
      else if((HEIGHT + 11'd9 <= count_line) &&
              (count_line <= HEIGHT + 11'd16)) begin
        if(count_line[0] == 1'b1) begin
          read_enable_linemem_nrsr_0 <= 1'b1;
        end
        else begin
          read_enable_linemem_nrsr_0 <= 1'b0;
        end
      end
      else begin
        read_enable_linemem_nrsr_0 <= 1'b0;
      end
    end
    else begin
      read_enable_linemem_nrsr_0 <= 1'b0;
    end
  end

// linemem_nrsr1 read_enable **************************************************
  reg	read_enable_linemem_nrsr_1 = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if((11'd3 <= count_line) &&
         (count_line <= 11'd8)) begin
        if(count_line[0] == 1'b1) begin
          read_enable_linemem_nrsr_1 <= 1'b0;
        end
        else begin
          read_enable_linemem_nrsr_1 <= 1'b1;
        end
      end
      else if((HEIGHT + 11'd9 <= count_line) &&
              (count_line <= HEIGHT + 11'd16)) begin
        if(count_line[0] == 1'b1) begin
          read_enable_linemem_nrsr_1 <= 1'b0;
        end
        else begin
          read_enable_linemem_nrsr_1 <= 1'b1;
        end
      end
      else begin
        read_enable_linemem_nrsr_1 <= 1'b0;
      end
    end
    else begin
      read_enable_linemem_nrsr_1 <= 1'b0;
    end
  end

  // delay h_blank  **************************************************
  // reg  [ 7: 0] h_blank_d = 8'b11111111;
  // wire	       h_blank_8hd;

  // always @( posedge clk_72m ) begin
  //   h_blank_d <= { h_blank_d[6:0], h_blank };
  // end

  // assign	h_blank_8hd = h_blank_hd[7];

  // linemem write_enable **************************************************
  reg	write_enable_linemem = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if((11'd1 <= count_line) &&
         (count_line <= HEIGHT + 11'd8)) begin
        write_enable_linemem <= 1'b1;
      end
      else begin
        write_enable_linemem <= 1'b0;
      end
    end
    else begin
      write_enable_linemem <= 1'b0;
    end
  end

  reg	[ 7: 0]	write_enable_linemem_d = 8'd0;

  always @( posedge clk_72m ) begin
    write_enable_linemem_d <= { write_enable_linemem_d[ 6: 0], write_enable_linemem };
  end

  // linemem read_enable **************************************************
  reg	read_enable_linemem = 1'b0;

  always @(posedge clk_72m) begin
    if(h_blank == 1'b0) begin
      if((11'd1 <= count_line) &&
         (count_line <= HEIGHT + 11'd8)) begin
        read_enable_linemem <= 1'b1;
      end
      else begin
        read_enable_linemem <= 1'b0;
      end
    end
    else begin
      read_enable_linemem <= 1'b0;
    end
  end

  reg	[ 7: 0]	read_enable_linemem_d = 8'd0;

  always @( posedge clk_72m ) begin
    read_enable_linemem_d <= { read_enable_linemem_d[ 6: 0], read_enable_linemem };
  end

  // pix_data delay **************************************************
  reg [ 3: 0][13: 0] pix_data_d = 56'd0;

  always @(posedge clk_72m) begin
    pix_data_d <= pix_data;
  end

  // count_pix delay **************************************************
  reg	[ 7: 0][ 9: 0]	count_pix_d = 80'd0;

  always @( posedge clk_72m ) begin
    count_pix_d[0] <= count_pix;
    count_pix_d[ 7: 1] <= count_pix_d[ 6: 0];
  end

  // // ===========================================================================
  // //  Instance u_ram_linemem_nrsr_0
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_nrsr_0;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_nrsr_0
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem_nrsr_0 ),
  //    .wea   ( write_enable_linemem_nrsr_0 ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_d                  ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem_nrsr_0  ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_nrsr_0     )
  //    );

  // // ===========================================================================
  // //  Instance u_ram_linemem_nrsr_1
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_nrsr_1;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_nrsr_1
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem_nrsr_1 ),
  //    .wea   ( write_enable_linemem_nrsr_1 ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_d                  ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem_nrsr_0  ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_nrsr_1     )
  //    );

  // // ===========================================================================
  // //  Instance u_ram_linemem_0
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_0;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_0
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem  	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_d                  ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_0          )
  //    );

  // // ===========================================================================
  // //  Instance u_ram_linemem_1
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_1;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_1
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_0          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_1          )
  //    );

  // // ===========================================================================
  // //  Instance u_ram_linemem_2
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_2;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_2
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_1          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_2          )
  //    );
  // // ===========================================================================
  // //  Instance u_ram_linemem_3
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_3;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_3
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_2          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_3          )
  //    );
  // // ===========================================================================
  // //  Instance u_ram_linemem_4
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_4;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_4
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_3          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_4          )
  //    );
  // // ===========================================================================
  // //  Instance u_ram_linemem_5
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_5;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_5
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_4          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_5          )
  //    );
  // // ===========================================================================
  // //  Instance u_ram_linemem_6
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_6;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_6
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_5          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_6          )
  //    );

  // // ===========================================================================
  // //  Instance u_ram_linemem_7
  // // ===========================================================================
  // reg [ 3: 0][13: 0] pix_data_linemem_7;

  // ram_add_nrsr_56x540_d_blk_mem_gen_0_1 u_linemem_7
  //   (
  //    .clka  ( clk_72m                     ),
  //    .ena   ( write_enable_linemem	  ),
  //    .wea   ( write_enable_linemem        ),
  //    .addra ( count_pix_d		  ),
  //    .dina  ( pix_data_linemem_6          ),
  //    .clkb  ( clk_72m                     ),
  //    .enb   ( read_enable_linemem         ),
  //    .addrb ( count_pix_d  		  ),
  //    .doutb ( pix_data_linemem_7          )
  //    );

  // // delay 8H timing signal **************************************************
  // reg  [ 7: 0] v_blank_hd = 8'b11111111;
  // reg  [ 7: 0] v_start_hd = 8'b00000000;
  // wire	       v_blank_8hd;
  // wire	       v_start_8hd;

  // always @( posedge clk_72m ) begin
  //   if( sens_bus_in.h_start == 1'b1 ) begin
  //     v_blank_hd <= { v_blank_hd[6:0], v_blank };
  //     v_start_hd <= { v_start_hd[6:0], v_start };
  //   end
  //   else begin
  //     // NOP
  //   end
  // end

  // assign      	v_blank_8hd = v_blank_hd[7];
  // assign	v_start_8hd = v_start_hd[7];

  // // output selector **************************************************
  // reg [ 3: 0][13: 0] pix_data_sel;

  // always @( posedge clk_72m ) begin
  //   if(count_line == 11'd1 ||
  //      count_line == 11'd2) begin
  //     pix_data_sel <= pix_data;
  //   end
  //   else if((11'd3 <= count_line) &&
  //           (count_line <= 11'd8)) begin
  //     if(count_line[0] == 1'b1) begin
  //       pix_data_sel <= pix_data_linemem_nrsr_0;
  //     end
  //     else begin
  //       pix_data_sel <= pix_data_linemem_nrsr_1;
  //     end
  //   end
  //   else if((HEIGHT + 11'd9 <= count_line) &&
  //           (count_line <= HEIGHT + 11'd16)) begin
  //     if(count_line[0] == 1'b1) begin
  //       pix_data_sel <= pix_data_linemem_nrsr_0;
  //     end
  //     else begin
  //       pix_data_sel <= pix_data_linemem_nrsr_1;
  //     end
  //   end
  //   else begin
  //     pix_data_sel <= pix_data_linemem_7;
  //   end
  // end

  // // ssg delay **************************************************
  // fe_sens_bus_t  sens_bus_in_d;
  // fe_sens_bus_t  sens_bus_in_2d;
  // fe_sens_bus_t  sens_bus_in_3d;

  // always @( posedge clk_72m) begin
  //   sens_bus_in_d <= sens_bus_in;
  //   sens_bus_in_2d <= sens_bus_in_d;
  //   sens_bus_in_3d <= sens_bus_in_2d;
  // end

  // // output **************************************************
  // assign  sens_bus_out.h_start = sens_bus_in_3d.h_start;
  // assign  sens_bus_out.v_start = sens_bus_in_3d.v_start;
  // assign  sens_bus_out.h_blank = sens_bus_in_3d.h_blank;
  // assign  sens_bus_out.v_blank = sens_bus_in_3d.v_blank;
  // assign  sens_bus_out.pix_data = pix_data_sel;
  
endmodule

`default_nettype wire
