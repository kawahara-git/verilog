`default_nettype none

module randomgen
  (
   // ==== Clock =============================================================
   input  wire               clk,
   
   // ==== Output ============================================================
   output wire[ 3: 0][13: 0] data
   );

  // xorshift64 **************************************************
  function [63: 0] xorshift64
    (
     input [63: 0] x
     );
    begin
      x = x ^ (x << 13);
      x = x ^ (x >> 7);
      x = x ^ (x << 17);
    end
  endfunction

  // randomgen **************************************************
  reg [63: 0] random_data = 64'd88172645463325252;

  always @(posedge clk) begin
    random_data <= xorshift64(random_data);
  end
  
  // assign **************************************************
  assign data[0] = random_data[13: 0];
  assign data[1] = random_data[27:14];
  assign data[2] = random_data[41:28];
  assign data[3] = random_data[55:42];

endmodule

`default_nettype wire
