// This module resides within the write clock domain and implements a (n-1) bit
// pointer to address the FIFO buffer. A dual n-bit Gray code counter implements
// the wptr that is passed to the read clock domain. The module also detects
// when the FIFO is full.

`default_nettype none

module wptr_full
  #(parameter int ADDR_W = 4)
  ( input  var logic              i_clk
  , input  var logic              i_rst

  , input  var logic              i_inc
  , input  var logic [ADDR_W:0]   i_rPtr

  , output var logic [ADDR_W:0]   o_wPtr
  , output var logic [ADDR_W-1:0] o_wAddr
  , output var logic              o_full
  );

  // {{{ Binary counter.

    logic [ADDR_W:0] counter_d, counter_q;

    always_ff @(posedge i_clk, posedge i_rst)
      if (i_rst)
        counter_q <= '0;
      else
        counter_q <= counter_d;

    always_comb counter_d = counter_q + {4'b0, (i_inc && !o_full)};

    // Memory write-address pointer.
    always_comb o_wAddr = counter_q[ADDR_W-1:0];

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

    // Write-pointer that will be passed to read clock domain.
    always_comb o_wPtr = grayCounter_d;

  // {{{ Gray counter.

  // {{{ Full.

  logic full_d, full_q;

  always_ff @(posedge i_clk, posedge i_rst)
    if (i_rst)
      full_q <= '0;
    else
      full_q <= full_d;

  // Full occurs when the two MSBs of the wptr and rptr are not equal but the
  // rest of the bits are equal.
  always_comb full_d = (o_wPtr == {~i_rPtr[ADDR_W:ADDR_W-1],
                                       i_rPtr[ADDR_W-2:0]});

  always_comb o_full = full_q;

  // }}} Full.

endmodule

`resetall
