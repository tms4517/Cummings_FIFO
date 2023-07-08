// This module resides within the read clock domain and implements a (n-1) bit
// pointer to address the FIFO buffer. A dual n-bit Gray code counter implements
// the rptr that is passed to the write clock domain. THe module also detects
// when the FIFO is empty.

`default_nettype none

module rptr_empty
  #(parameter int ADDR_W = 4)
  ( input  var logic            i_clk
  , input  var logic            i_rst

  , input  var logic            i_inc
  , input  var logic [ADDR_W:0] i_writePtr

  , output var logic [ADDR_W:0] o_readPtr
  , output var logic [ADDR_W:0] o_readAddr
  , output var logic            o_empty
  );

  // {{{ Binary counter.

    logic [ADDR_W:0] counter_d, counter_q;

    always_ff @(posedge i_clk, posedge i_rst)
      if (i_rst)
        counter_q <= '0;
      else
        counter_q <= counter_d;

    always_comb counter_d = counter_q + (i_inc && !o_empty);

    // Memory read-address pointer.
    always_comb o_readAddr = counter_q[ADDR_W-1:0];

  // }}} Binary counter.

  // {{{ Gray counter.

    logic [ADDR_W:0] grayCounter_d, grayCounter_q;

    always_ff @(posedge i_clk, posedge i_rst)
      if (i_rst)
        grayCounter_q <= '0;
      else
        grayCounter_q <= grayCounter_d;

    // Binary to gray conversion.
    always_comb grayCounter_d = (counter_d>>1) ^ counter_d;

    // Read-pointer that will be passed to write clock domain.
    always_comb o_readPtr = grayCounter_d;

  // {{{ Gray counter.

  // {{{ Empty.

  logic empty_d, empty_q;

  always_ff @(posedge i_clk, posedge i_rst)
    if (i_rst)
      empty_q <= '0;
    else
      empty_q <= empty_d;

  // Empty occurs when the read pointer catches up to the syncd write pointer.
  always_comb empty_d = (o_readPtr == i_writePtr);

  always_comb o_empty = empty_q;

  // }}} Empty.

endmodule

`resetall
