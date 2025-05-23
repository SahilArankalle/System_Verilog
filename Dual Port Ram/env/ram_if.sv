/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_if.sv   

Description    :  Interface for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

*********************************************************************************************/   
// Definition of an interface block ram_if with clock as an input

interface ram_if(input bit clock);
   // Declare the interface signals:            
   // data_in, data_out(logic type , size 64)
   // read, write (logic type, size 1)
   // rd_address, wr_address (logic type, size 12)

	logic [63:0] data_in;
	logic [63:0] data_out;
	logic read;
	logic write;
	logic [11:0] rd_address;
	logic [11:0] wr_address;	

   // Add clocking block wr_drv_cb for write driver that is triggered at posedge of clock
   
      // define the input skew as #1 & output skew as #1

      // define the direction of the signals as:

     // output: data_in, wr_address, write

	clocking wr_drv_cb @(posedge clock);
	default input #1 output #1;
	output wr_address;
	output write;
	output data_in;
	endclocking : wr_drv_cb

   // Add clocking block rd_drv_cb for read driver that is triggered at posedge of clock
   
      // define the input skew as #1 & output skew as #1

      // define the direction of the signals as:

     // output:  rd_address, read

	clocking rd_drv_cb @(posedge clock);
	default input #1 output #1;
	output rd_address;
	output read;
	endclocking : rd_drv_cb

   // Add monitor clocking block wr_mon_cb for write monitor that is triggered at the posedge of clock
   
      // define the input skew as #1 & output skew as #1

      // define the direction of the signals as:

     // input: data_in, wr_address, write

	clocking wr_mon_cb @(posedge clock);
	default input #1 output #1;
	input wr_address;
	input write;
	input data_in;
	endclocking : wr_mon_cb

   // Add monitor clocking block rd_mon_cb for read monitor that is triggered at the posedge of clock
   
      // define the input skew as #1 & output skew as #1

      // define the direction of the signals as:

     // input: rd_address,read, data_out

	clocking rd_mon_cb @(posedge clock);
	default input #1 output #1;
	input rd_address;
	input read;
	input data_out;
	endclocking : rd_mon_cb

   // Add write driver modport WR_DRV_MP with driver clocking block(wr_drv_cb) as the input argument

	modport WR_DRV_MP (clocking wr_drv_cb);

   // Add read driver modport RD_DRV_MP with driver clocking block(rd_drv_cb) as the input argument

	modport RD_DRV_MP (clocking rd_drv_cb);

   // Add write monitor modport WR_MON_MP with monitor clocking block (wr_mon_cb) as the input argument

	modport WR_MON_MP (clocking wr_mon_cb);

   // Add read monitor modport RD_MON_MP with monitor clocking block(rd_mon_cb) as the input argument

	modport RD_MON_MP (clocking rd_mon_cb);

endinterface: ram_if

