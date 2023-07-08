// Two flip-flop synchronizer used to pass an n-bit pointer from one clock domain
// to another.

`default_nettype none

module sync
  #(parameter int DATA_W = 8)
  ( input  var logic          i_clk
  , input  var logic          i_rst

  , input  var logic [ADDR_W] i_ptr

  , output var logic [ADDR_W] o_syncPtr
  );

  logic [ADDR_W-1;0] syncPtr_q1, syncPtr_q2;

  always_ff @(posedge i_clk, posedge i_rst)
    if (i_rst)
      syncPtr_q1 <= '0;
    else
      syncPtr_q1 <= i_ptr;

  always_ff @(posedge i_clk, posedge i_rst)
    if (i_rst)
      syncPtr_q2 <= '0;
    else
      syncPtr_q2 <= syncPtr_q1;

  always_comb o_syncPtr = syncPtr_q2;

endmodule

`resetall
