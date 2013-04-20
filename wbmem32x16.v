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

module wb_mem_32x16
  (
   output ACK_O,
   input [3:0] ADR_I,
   input CLK_I,
   input [31:0] DAT_I,
   output [31:0] DAT_O,
   input STB_I,
   input WE_I
   );

  reg [31:0] mem [15:0];

  integer    i;
  initial begin
    for(i=0;i<2**15;i=i+1)begin
      mem[i] = 0;
    end
  end
  
  always @ (posedge CLK_I) begin
    if (STB_I && WE_I) begin
      mem[ADR_I] = DAT_I;
    end
  end
  
  assign ACK_O = STB_I;
  assign DAT_O = mem[ADR_I];
  
endmodule

