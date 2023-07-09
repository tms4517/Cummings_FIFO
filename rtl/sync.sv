// Two flip-flop synchronizer used to pass an n-bit pointer from one clock domain
// to another.

`default_nettype none

module sync
  #(parameter int ADDR_W = 4)
  ( input  var logic            i_clk
  , input  var logic            i_arst

  , input  var logic [ADDR_W:0] i_ptr

  , output var logic [ADDR_W:0] o_syncPtr
  );

  logic [ADDR_W:0] syncPtr_q1, syncPtr_q2;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      syncPtr_q1 <= '0;
    else
      syncPtr_q1 <= i_ptr;

  always_ff @(posedge i_clk, posedge i_arst)
    if (i_arst)
      syncPtr_q2 <= '0;
    else
      syncPtr_q2 <= syncPtr_q1;

  always_comb o_syncPtr = syncPtr_q2;

endmodule

`resetall
