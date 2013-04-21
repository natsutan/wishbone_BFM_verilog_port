// -------------------------------------------------------------------------------
// ----                                                                       ----
// ---- WISHBONE Wishbone_BFM IP Core                                         ----
// ----                                                                       ----
// ---- This file is part of the Wishbone_BFM project                         ----
// ---- http://www.opencores.org/cores/Wishbone_BFM/                          ----
// ----                                                                       ----
// ---- Description                                                           ----
// ---- Implementation of Wishbone_BFM IP core according to                   ----
// ---- Wishbone_BFM IP core specification document.                          ----
// ----                                                                       ----
// ---- To Do:                                                                ----
// ----	NA                                                                 ----
// ----                                                                       ----
// ---- Author(s):                                                            ----
// ----   Andrew Mulcock, amulcock@opencores.org                              ----
// ----                                                                       ----
// -------------------------------------------------------------------------------
// ----                                                                       ----
// ---- Copyright (C) 2008 Authors and OPENCORES.ORG                          ----
// ----                                                                       ----
// ---- This source file may be used and distributed without                  ----
// ---- restriction provided that this copyright statement is not             ----
// ---- removed from the file and that any derivative work contains           ----
// ---- the original copyright notice and the associated disclaimer.          ----
// ----                                                                       ----
// ---- This source file is free software; you can redistribute it            ----
// ---- and/or modify it under the terms of the GNU Lesser General            ----
// ---- Public License as published by the Free Software Foundation           ----
// ---- either version 2.1 of the License, or (at your option) any            ----
// ---- later version.                                                        ----
// ----                                                                       ----
// ---- This source is distributed in the hope that it will be                ----
// ---- useful, but WITHOUT ANY WARRANTY; without even the implied            ----
// ---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR               ----
// ---- PURPOSE. See the GNU Lesser General Public License for more           ----
// ---- details.                                                              ----
// ----                                                                       ----
// ---- You should have received a copy of the GNU Lesser General             ----
// ---- Public License along with this source; if not, download it            ----
// ---- from http://www.opencores.org/lgpl.shtml                              ----
// ----                                                                       ----
// -------------------------------------------------------------------------------
// -- file to 'exercise' the Wishbone bus.
// --
// --  Idea is to look like a wishbone master, 
// --   and provide procedures to exercise the bus.
// --
// --  syscon is an external module that provides the reset and clocks 
// --   to all the other modules in the design.
// --
// --  to enable the test script in this master to control
// --   the syscon reset and clock stop,
// --    this master provides tow 'extra' outputs
// --   rst_i and clk_stop
// --
// --    when rst_sys is high, then syscon will issue a reset
// --    when clk_stop is high, then syscon will stop the clock
// --     on the next low transition. i.e. stopped clock is low.

module mb_master #(parameter write32_time_out = 6, read32_time_out = 6, clk_period = 10, max_block_size = 128)
    (
    output RST_sys,
    output reg CLK_stop,
    
    // WISHBONE master interface:
    input RST_I,
    input CLK_I,

    output reg [31:0] ADR_O,
    input  [31:0] DAT_I,
    output reg [31:0] DAT_O,
    output reg WE_O,

    output reg STB_O,
    output reg CYC_O,
    input ACK_I,
    input ERR_I,
    input RTY_I,
    
    output reg LOCK_O,
    output reg [3:0] SEL_O,
    
    output reg [5:0] CYCLE_IS
    );

  reg 	   reset_int;
  reg 	   [31:0] read_data;
  
  assign RST_sys = reset_int;
     
`include "io_package.v"
  
  initial begin
    #1 CLK_stop = 0;
    reset_int = 0;
    wb_init();
    
    wb_rst(2);    
    clock_wait(2); //  Wait 100 ns for global reset to finish

    wr_32(0,32'h12345678);
    wr_32(1,32'h9ABCDEF0);
    clock_wait(1);
    
    rd_32(0, read_data);
    $display("RD 0 %08X", read_data);
    clock_wait(1);

    rd_32(1, read_data);
    $display("RD 1 %08X", read_data);
    clock_wait(1);

    rmw_32(1, read_data, 32'hdeadbeaf);
    rd_32(1, read_data);
    $display("RD 1 %08X", read_data);
    clock_wait(1);
    
    # 100 CLK_stop = 1;
    # 100 $finish();
  end
endmodule 






