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

module syscon #(parameter clk_period = 10) 
  (
   input RST_sys,
   input CLK_stop,
   output RST_o,
   output CLK_o
   
   );
  reg 	  clk_internal;
  reg 	  rst_internal;
  
  assign CLK_o = clk_internal;
  assign RST_o = rst_internal;
  
  initial begin
    clk_internal = 0;
    rst_internal = 1;  // not reset
  end
  
  always #(clk_period/2) begin
    if (CLK_stop == 0) begin
      clk_internal = ~clk_internal;
    end
  end
  
  always @ (posedge clk_internal or RST_sys) begin
    if (RST_sys == 1) begin
      rst_internal = 1;
    end else begin
      if (RST_sys == 0) begin
	rst_internal = 0;
      end
    end
  end
  
endmodule

