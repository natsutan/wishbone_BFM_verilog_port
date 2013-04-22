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

parameter BUS_RST  = 0;
parameter BUS_IDLE = 1;
parameter RD32     = 2;
parameter RD16     = 3;
parameter RD8      = 4;
parameter WR32     = 5;
parameter WR16     = 6;
parameter WR8      = 7;
parameter RMW32    = 8;
parameter RMW16    = 9;
parameter RMW8	   = 10;
parameter BKR32    = 11;
parameter BKR16    = 12;
parameter BRW8     = 13;
parameter BKW32    = 14;
parameter BKW16    = 15;
parameter BKW8     = 16;

task clock_wait;
  input integer no_of_clocks;
  begin
    repeat (no_of_clocks) @(posedge CLK_I) ;
  end
endtask // clock_wait

// --------------------------------------------------------------------
//  wb_init
// --------------------------------------------------------------------
// usage wb_init(); -- Initalises the wishbone bus
task wb_init;
begin
  CYCLE_IS = BUS_IDLE;
  ADR_O = 32'h00000000;
  DAT_O = 32'h00000000;
  WE_O = 0;
  STB_O = 0;
  CYC_O = 0;
  LOCK_O = 0;
  SEL_O = 0;
  // allign to next clock
  @(posedge CLK_I) ;
  
end
endtask

// ----------------------------------------------------------------------
//  wb_rst
// ----------------------------------------------------------------------
// usage wb_rst( 10 ); -- reset system for 10 clocks
task wb_rst;
  input integer no_of_clocks;
  begin
    CYCLE_IS = BUS_RST;
    STB_O = 0;
    CYC_O = 0;
    SEL_O = 0;
    reset_int = 1;
    repeat (no_of_clocks) @(posedge CLK_I) ;
    #1 reset_int = 0;
  end
endtask

// ----------------------------------------------------------------------
//  rd_32
// ----------------------------------------------------------------------
// usage rd_32 ( address, data)-- read 32 bit data from a 32 bit address
//
//  Note: need read data to be a variable to be passed back to calling process;
//   If it's a signal, it's one delta out, and in the calling process
//    it will have the wrong value, the one after the clock !
task rd_32;
  input [31:0] address_data;
  output [31:0] read_data;
  integer 	bus_read_timer;
  begin
    CYCLE_IS = RD32;
    ADR_O   = address_data;
    WE_O     = 0; // read cycle
    SEL_O    = 4'b1111 ; // on all four banks
    CYC_O    = 1;
    STB_O    = 1;
    bus_read_timer = 0;

    @(posedge CLK_I) ;

    begin: loop_exit 
      while (~ACK_I) begin
	bus_read_timer = bus_read_timer + 1;
	@(posedge CLK_I) ;
	if (bus_read_timer >= read32_time_out)  disable loop_exit;
      end
    end

    #1
    read_data = DAT_I;
    CYCLE_IS  = BUS_IDLE;
    ADR_O     = 0;
    DAT_O     = 0;
    WE_O      = 0;
    SEL_O     = 4'b0000;
    CYC_O     = 0;
    STB_O     = 0;
    
  end
endtask

// ----------------------------------------------------------------------
//  wr_32
// ----------------------------------------------------------------------
// usage wr_32 ( address, data , bus_record )-- write 32 bit data to a 32 bit address
task wr_32;
  input [31:0] address_data;
  input [31:0] write_data;
  integer      bus_write_timer;
  begin
    CYCLE_IS = WR32;
    ADR_O = address_data;
    DAT_O = write_data;
    WE_O  = 1; // write cycle
    SEL_O = 4'b1111;
    CYC_O = 1;
    STB_O = 1;
    bus_write_timer = 0;

    @(posedge CLK_I) ;

    begin: loop_exit 
      while (~ACK_I) begin
	bus_write_timer = bus_write_timer + 1;
	@(posedge CLK_I) ;
	if (bus_write_timer >= write32_time_out)  disable loop_exit;
      end
    end

    CYCLE_IS = BUS_IDLE;
    ADR_O = 0;
    DAT_O = 0;
    WE_O = 0;
    SEL_O = 4'b0000;
    CYC_O = 0;
    STB_O = 0;
    
  end
endtask

// ----------------------------------------------------------------------
//  rmw_32
// ----------------------------------------------------------------------
// usage rmw_32 ( address, read_data, write_data , bus_record )-- read 32 bit data from a 32 bit address
//                                                                then write new 32 bit data to that address
task rmw_32;
  input [31:0] address_data;
  output [31:0] read_data;
  input [31:0] 	write_data;
  integer bus_read_timer;
  integer bus_write_timer;
  begin

    // first read
    CYCLE_IS = RMW32;
    ADR_O = address_data;
    WE_O = 1;
    SEL_O = 4'b1111;
    CYC_O = 1;
    STB_O = 1;
	    
    @(posedge CLK_I) ;

    begin: loop_exit_r 
      while (~ACK_I) begin
	bus_read_timer = bus_read_timer + 1;
	@(posedge CLK_I) ;
	if (bus_read_timer >= read32_time_out)  disable loop_exit_r;
      end
    end
    #1
    read_data = DAT_I;
 
    // now write
    DAT_O  = write_data;    
    WE_O = 1;
    bus_write_timer = 0;

    @(posedge CLK_I) ;

    begin: loop_exit_w 
      while (~ACK_I) begin
	bus_write_timer = bus_write_timer + 1;
	@(posedge CLK_I) ;
	if (bus_write_timer >= write32_time_out)  disable loop_exit_w;
      end
    end

    CYCLE_IS = BUS_IDLE;
    ADR_O = 0;
    DAT_O = 0;
    WE_O = 0;
    SEL_O = 4'b0000;
    CYC_O = 0;
    STB_O = 0;

  end
endtask

// not supported
// ----------------------------------------------------------------------
//  bkw_32
// ----------------------------------------------------------------------
// usage bkw_32 ( address_array, write_data_array, array_size , bus_record )
//  write each data to the coresponding address of the array


// not supported
// ----------------------------------------------------------------------
//  bkr_32
// ----------------------------------------------------------------------
// usage bkr_32 ( address_array, read_data_array, array_size , bus_record )
// read from each address data to the coresponding address of the array

