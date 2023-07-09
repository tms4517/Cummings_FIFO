// Instantiate a synchronous dual-port RAM that can be accessed by both the write
// and read clock domains.

`default_nettype none

module fifomem
  #(parameter int DATA_W = 8
  , parameter int ADDR_W = 4
  )
  ( input  var logic              i_wClk
  , input  var logic              i_wClkEn
  , input  var logic [ADDR_W-1:0] i_wAddr
  , input  var logic [DATA_W-1:0] i_wData
  , input  var logic              i_wFull

  , input  var logic [ADDR_W-1:0] i_rAddr

  , output var logic [DATA_W-1:0] o_rData
  );

  `ifdef FPGA

   // {{{

    // TODO

   // }}}

  `else

   // {{{ RTL SV memory model.

   localparam DEPTH = 1<<ADDR_W;
   logic [DATA_W-1:0] mem [0:DEPTH-1];

   always_comb o_rData = mem[i_rAddr];

   always_ff @(posedge i_wClk)
    if (i_wClkEn && !i_wFull)
      mem[i_wAddr] <= i_wData;

   // }}} RTL SV memory model.

   `endif

endmodule

`resetall
