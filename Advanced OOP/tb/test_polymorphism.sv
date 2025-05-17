/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename		:	test_polymorphism.sv  

Description		:	Example for Polymorphism

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/

module test_polymorphism;


	// In class packet_c
	class packet_c;
	
		// In task send
			// Display message "Sending base class packet"

		virtual task send();
			$display("send is called from the object of class %s class, and it is sending base class packet", $typename(this));
		endtask : send
	
	endclass : packet_c


	// Extend badpacket_c from packet_c
	
	class badpacket_c extends packet_c;

		// Override task send
			// Display message "Sending derived class packet"

		task send();
			$display("send is called from the object of class %s class, and it is sending derived class packet", $typename(this));
		endtask : send

	endclass : badpacket_c

	// Within initial
		// Create instances for badpacket_c and packet_c 

	initial

		begin

		badpacket_c bpkt = new;
		packet_c pkt = new;	

		// Call send tasks using base and extended class handles

		pkt.send();
		bpkt.send();

		// Assign extended class handle to base class handle
		
		pkt = bpkt;

		// Call send task using base class object
		
		pkt.send();

		end

endmodule
