/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename		:	test_class_defn.sv   

Description		:	Example for handles and objects

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/



module test_class_defn;


	// Declare class account_c

		// Within class account_c
		
		// Declare variable balance as int type


		// Write a function summary that returns balance from it


		// Write a task deposit with pay (type int) as the input argument and add pay with the balance

	class account_c;
		int balance;

	function int summary();
		return balance;
	endfunction : summary


	task deposit (input int pay);
	balance = balance + pay;
	endtask 

	endclass : account_c
	
	
	
	// Declare a handle for class account_c
	
	account_c acnt_h;

	// Within initial block

		// Create an instance of the class account_c
	
	initial 
	begin
	acnt_h = new;
	
	
		// Call method deposit and pass pay value as the input argument and call method summary to display balance
	
	acnt_h.deposit(1000);
	$display("The account balance is %d", acnt_h.summary());
	$display("The account balance is %d", acnt_h.balance);

	end

endmodule



