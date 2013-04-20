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
// 
// --
// -- wbtb_1m_1s
// -- 
// -- this testbench joins together 
// --  one wishbone master and one wishbone slave,
// --  along with the required sys_con module
// --
// --  having only on emaster and one slave, no logic is 
// --   required, outputs of one connect to inputs of the other.
// --
// 
// 

module wbtb_1m_1s_tb ();
  wire RST_sys;
  wire CLK_stop;
  wire RST_I;
  wire CLK_I;

  wire ACK_I;
  wire [3:0] ADR_O;
  wire [31:0] DAT_I;
  wire [31:0] DAT_O;
  wire 	      STB_O;
  wire        WE_O;
  
  parameter CYCLE = 10;

  syscon #(.clk_period(CYCLE)) sc 
    (
     .RST_sys(RST_sys),
     .CLK_stop(CLK_stop),
     .RST_o(RST_I),
     .CLK_o(CLK_I)
     );
  
  mb_master #(.clk_period(CYCLE)) master 
    (
     .RST_sys(RST_sys),
     .CLK_stop(CLK_stop),
     
     .RST_I(RST_I),
     .CLK_I(CLK_I),
     
     .ADR_O(ADR_O),
     .DAT_I(DAT_I),
     .DAT_O(DAT_O),
     .WE_O(WE_O),
     
     .STB_O(STB_O),
     .CYC_O(),
     .ACK_I(ACK_I),
     .ERR_I(),
     .RTY_I(),
     
     .LOCK_O(),
     .SEL_O(),
     
     .CYCLE_IS()
     );
  
  wb_mem_32x16 memory
  (
   .ACK_O(ACK_I),
   .ADR_I(ADR_O),
   .CLK_I(CLK_I),
   .DAT_I(DAT_O),
   .DAT_O(DAT_I),
   .STB_I(STB_O),
   .WE_I(WE_O)
   );
  
endmodule
