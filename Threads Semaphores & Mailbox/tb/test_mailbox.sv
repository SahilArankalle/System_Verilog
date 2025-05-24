/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.


Filename		:	test_mailbox.sv   

Description		:	Example for mailbox

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/

module test_mailbox;

	// In class packet
	class packet;

		// Add the following rand fields 
		
		// addr (bit type , size 4)
		rand bit [3:0] addr;
		// data (bit type , size 4)
		rand bit [3:0] data;

		// In display function pass a string as an input argument
			// Display the input string message
			// Display the data and address

		function void display (input string message);
			$display("-------------------------------------------");
			$display("\t The message is %s", message);
			$display("\t data is %0d and address is %0d",data,addr);
			$display("-------------------------------------------");
		endfunction : display
		// In post_randomize method call display method 
		// and pass the string argument as "randomized data"

		function void post_randomize();
			this.display("randomized data");
		endfunction : post_randomize

	endclass : packet

	// In class generator 
	class generator;
		// Declare a handle of packet class
		packet pkt;
			// Declare the mailbox parameterized by type class packet 
		mailbox #(packet) mbx;
			// In constructor
				// Pass the mailbox parameterized by packet as an argument of the constructor
				// Assign the mailbox handle argument to the local mailbox handle of generator
		
		function new (mailbox #(packet) gen2drv);
			this.mbx = gen2drv;
		endfunction

		// In task start, within fork - join_none,
		
		task start();
			fork

		// create 10 random packets 
			repeat(10)
		// Randomize each packet using assert & randomize method
				
		// Put the generated random packets into the mailbox 

				begin
					pkt = new;
					assert(pkt.randomize());
					mbx.put(pkt);
				end
			join_none
		endtask : start
	endclass : generator

	// In class driver
	class driver;
		// Declare a handle of packet class
		packet pkt;
		// Declare a mailbox parameterized by type class packet
		mailbox #(packet) mbx;
		// In constructor

			// Pass the mailbox parameterized by packet as an argument

			// Assign the mailbox handle argument to local mailbox handle of driver

		function new (mailbox #(packet) gen2drv);
			this.mbx = gen2drv;
		endfunction

	// In task start, within fork - join_none,

		// Get the 10 generated random packets from the mailbox 

		// Use display method in the packet class to display the received data

		task start();
			fork
			repeat(10)
				begin
				mbx.get(pkt);
				pkt.display("data in driver");
				end
			join_none
		endtask : start
	endclass : driver	


	// In class env
	class env;
		// Create the mailbox instance parameterized by packet
		mailbox #(packet) mbx = new;
		// Declare handles of generator and driver 
		generator gen;
		driver drv;
		// In build function

			// Create instance of generator and driver by passing mailbox as an input argument

		task build();
			gen = new(mbx);
			drv = new(mbx);
		endtask : build

		// In task start

			// call start task of generator and driver

		task start();
			gen.start;
			drv.start;
		endtask : start
	endclass : env

	// Within initial block

		// Create an instance of env

		// Call build and start task of env

	initial 
		begin
		env env_h = new;
		env_h.build();
		env_h.start();
		end

endmodule 

