// Top level fifo module.

`default_nettype none

module fifoTop
  #(parameter int DATA_W = 8
  , parameter int ADDR_W = 4
  )
  ( input  var logic              i_wClk
  , input  var logic              i_wArst
  , input  var logic              i_wInc
  , input  var logic [DATA_W-1:0] i_wData
  , input  var logic              i_wFull

  , input  var logic              i_rClk
  , input  var logic              i_rArst
  , input  var logic              i_rInc

  , output var logic [DATA_W-1:0] o_rData
  , output var logic              o_rEmpty

  , output var logic              o_wFull
  );

  logic [ADDR_W:0] wPtr, syncWptr;
  logic [ADDR_W:0] rPtr, syncRptr;

  logic [ADDR_W-1:0] wAddr, rAddr;

  // {{{ Write domain.

    sync
      #(.ADDR_W (ADDR_W))
        u_syncR2W
      ( .i_clk     (i_wClk)
      , .i_arst    (i_wArst)

      , .i_ptr     (rPtr)

      , .o_syncPtr (syncRptr)
      );

    wptr_full
      #(.ADDR_W (ADDR_W))
        u_wptr_full
      ( .i_clk   (i_wClk)
      , .i_rst   (i_wArst)

      , .i_inc   (i_wInc)
      , .i_rPtr  (syncRptr)

      , .o_wPtr  (wPtr)
      , .o_wAddr (wAddr)
      , .o_full  (o_wFull)
      );

  // {{{ Write domain.

  fifomem
    #(.DATA_W (DATA_W)
    , .ADDR_W (ADDR_W)
    ) u_fifomem
    ( .i_wClk   (i_wClk)
    , .i_wClkEn (i_wInc)
    , .i_wAddr  (wAddr)
    , .i_wData  (i_wData)
    , .i_wFull  (o_wFull)

    , .i_rAddr  (rAddr)

    , .o_rData  (o_rData)
    );

  // {{{ Read domain.

    sync
      #(.ADDR_W (ADDR_W))
        u_syncW2R
      ( .i_clk     (i_rClk)
      , .i_arst    (i_rArst)

      , .i_ptr     (wPtr)

      , .o_syncPtr (syncWptr)
      );

    rptr_empty
      #(.ADDR_W (ADDR_W))
        u_rptr_empty
      ( .i_clk   (i_rClk)
      , .i_arst  (i_rArst)

      , .i_inc   (i_rInc)
      , .i_wPtr  (syncWptr)

      , .o_rPtr  (rPtr)
      , .o_rAddr (rAddr)
      , .o_empty (o_rEmpty)
      );

  // }}} Read domain.

endmodule

`resetall
