/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename		:	test_array.sv   

Description		:	Example for different type of Arrays

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/

module test_array();

	// Declare a dynamic array data_da of int data type

	int data_da[];		

	// Declare queues data_q & addr_q of int data type

	int data_q[$], addr_q[$];

	// Declare associative array data_mem of int data type and indexed with bit[7:0]

	int data_mem[bit[7:0]];	
	
	// Declare int variable result,and and an 8 bit variable idx

	int result;
	bit [7:0] idx;	


	initial
		begin
	
			// Allocate 10 memory locations for dynamic array & initialize
			
			data_da = new[10];
		
			// all the locations with some random values less than 20 & display the array
	
			foreach (data_da[i])
				data_da[i] = {$random} % 20;
				
			$display("data_da is = %p", data_da);
			
			// Call the array reduction method sum which returns the sum

			// of all elements of array and collect the return value to the variable result

			result = data_da.sum();						
			
			// Display the sum of elements, result
			
			$display("The sum is = %d", result);
	
			// Similarly explore other array reduction methods 
			// product,or,and & xor

			result = data_da.product();
			$display("The product is = %d", result);

			result = data_da.or();
			$display("The or is = %d", result);

			result = data_da.and();
			$display("The and is = %d", result);

			result = data_da.xor();
			$display("The xor is = %d", result);
	
	
			// Call the array reduction method sum with "with" clause which returns 
			// total number of elements satisfying the condition within the "with" clause 

			result = data_da.sum with (int'(item>7));
			
			// Display the value of the result
			
			$display(" no. of items greater than 7 = %0d", result);
			
			// Similarly explore other array reduction methods with "with"clause 
		
			result = data_da.sum with (int'(item>7)*item);
			$display("sum of all the items greater than 7 = %0d\n", result);
	
			// Sorting Methods
	
			// call all the sorting methods like reverse, sort, rsort & 
			// shuffle & display the array after execution of each method to 
			// understand the behaviour of the array methods
			
			data_da.reverse();
			$display("after reverse da = %p\n", data_da);

			data_da.sort();
			$display("after sort da = %p\n", data_da);

			data_da.rsort();
			$display("after rsort da = %p\n", data_da);

			data_da.shuffle();
			$display("after shuffle da = %p\n", data_da);
			
			
			// Call Array locator methods like min, max, unique,find_* with,
			// find_*_index with using dynamic array & display 
			// the contents of data_q after execution of each method to 
			// understand the behaviour of the array methods
			
			data_q.push_back(int'( data_da.min()));
			$display("minimum of da is, data_q = %p", data_q);

			data_q.push_back(int'( data_da.max()));
			$display("maximum of da is, data_q = %p", data_q);

			data_q = data_da.unique();
			$display("unique of da is, data_q = %p", data_q);

			data_q = data_da.find_first with (item>4);
			$display("finding first with item > 4 = %p", data_q);

			data_q = data_da.find_last with (item>4);
			$display("finding last with item > 4 = %p", data_q);

			data_q = data_da.find_first_index with (item>4);
			$display("finding first index with item > 4 = %p", data_q);

			data_q = data_da.find_last_index with (item>4);
			$display("finding last index with item > 4 = %p", data_q);

			data_q = data_da.find with (item>4);
			$display("find data of item > 4 = %p", data_q);
			
			//Generate some 10 random address less than 100 within a repeat loop 
			//push the address in to the addr_q
			
			repeat(10)
				begin
					result = {$random}%100;
					addr_q.push_back(result);
				end	
			
			//Display the addr_q
			
			$display("Display Random addresses in addr_q = %p \n", addr_q);
			
			
			// With in for loop update the associate array with random data less than 200
			// based on the address stored in addr_q
			// Hint: To get the address use pop method 
			
			for(int i = 0; i < 10; i++)
				begin
					data_mem[addr_q.pop_front] = {$random}%200;
				end
			
			// Display the contents of associate array using foreach loop

			foreach (data_mem[i])
				$display("data_mem[%0d] = %0d", i, data_mem[i]);			
			
			// Display the first index of the array by using associative array method first
			
			if(data_mem.first(idx))
				$display("\n index of the first element is %0d", idx);

			// Display the first element of the array

			$display("first element is %0d", data_mem[idx]);
				
			// Display the last index of the array by using associative array method last
			
			if(data_mem.last(idx))
				$display("\n index of the last element is %0d", idx);

			// Display the last element of the array

			$display("last element is %0d\n", data_mem[idx]);
				
		end
	
endmodule
	
	
	
