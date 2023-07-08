// Instantiate a synchronous dual-port RAM that can be accessed by both the write
// and read clock domains.

`default_nettype none

module fifomem
  #(parameter int DATA_W = 8
  , parameter int ADDR_W = 4
  )
  ( input  var logic          i_wclk
  , input  var logic          i_wclkEn
  , input  var logic [ADDR_W] i_waddr
  , input  var logic [DATA_W] i_wdata
  , input  var logic          i_wfull

  , input  var logic [ADDR_W] i_raddr

  , output var logic [DATA_W] o_rdata
  );

  `ifdef FPGA

   // {{{

    // TODO

   // }}}

  `else

   // {{{ RTL SV memory model.

   localparam DEPTH = 1<<ADDR_W;
   logic [DATA_W-1:0] mem [0:DEPTH-1];

   always_comb o_rdata = mem[i_raddr];

   always_ff @(posedge i_wclk)
    if (i_wclkEn && !i_wfull)
      mem[i_waddr] <= i_wdata;

   // }}} RTL SV memory model.

   `endif

endmodule

`resetall
