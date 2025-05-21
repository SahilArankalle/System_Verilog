/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.


Filename		:	test_random.sv   

Description		:	Example for Constraints

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/


module test_random;


	// In class alu_trans_c
	class alu_trans_c;

		// Declare a typedef variable OPERATION of type enum with LOGIC, ARITH and SHIFT as the values
		typedef enum {LOGIC, ARITH, SHIFT} OPERATION;

		// Add the following rand fields 
		// alu_sel_in ( logic type, size 4)
		// rand_oper ( OPERATION type)
		
		rand logic [3:0] alu_sel_in;
		rand OPERATION rand_oper;

		// Apply following constraints 
		// If rand_oper = LOGIC then alu_sel_in should be inside [0:5] 
		// If rand_oper = ARITH, then alu_sel_in should be inside [6:9]
		// If rand_oper = SHIFT, then alu_sel_in should be inside [10:15]
		// Give weightage of 2 to ARITH operation
		
		constraint SEL {rand_oper == LOGIC -> alu_sel_in inside {[0:5]};
				rand_oper == ARITH -> alu_sel_in inside {[6:9]};
				rand_oper == SHIFT -> alu_sel_in inside {[10:15]};}

	
		constraint weigh {rand_oper dist{LOGIC:=1, ARITH:=2, SHIFT:=1};}


		// In post_randomize method ,display all the randomized values
		
		function void post_randomize();
			$display("The randomized data is %s, %d", rand_oper.name, alu_sel_in);
		endfunction : post_randomize
		
	endclass : alu_trans_c

	// Within initial
		// Create an instance of alu_trans_c
		// Generate 10 set of random values for the instance alu_trans_c
		// Randomize using 'assert' or 'if' construct

	initial 
		begin
			
		alu_trans_c alu_obj = new;
		for (int i = 0; i < 10; i++)
			begin
			assert(alu_obj.randomize());
			end
		end
	   
	
endmodule 
 
