/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename       :  ram_sb.sv   

Description    :  Scoreboard for dual port ram_testbench

Author Name    :  Putta Satish

Support e-mail :  techsupport_vm@maven-silicon.com 

Version        :  1.0

Date           :  02/06/2020

********************************************************************************************/
//In class ram_sb

class ram_sb;
   //Declare an event DONE
   event DONE; 

   //Declare three variables of int datatype for counting
   //number of read data received from the reference model(rm_data_count)
   //number of read data received from the monitor(mon_data_count)
   //number of read data verified(data_verified)
   int rm_data_count = 0;
   int mon_data_count = 0;
   int data_verified = 0;

   // Declare ram_trans handles as 'rm_data','rcvd_data' and cov_data 
   ram_trans rm_data;
   ram_trans rcvd_data;
   ram_trans cov_data;

   //Declare two mailboxes as 'rm2sb','rdmon2sb' parameterized by ram_trans 
   mailbox #(ram_trans) rm2sb;
   mailbox #(ram_trans) rdmon2sb;
   
   //Write the functional coverage model 
   //Define a covergroup as 'mem_coverage'   
   //Define coverpoints and bins for read, data_out and rd_address
   //Define cross for read,rd_address
   covergroup mem_coverage;

   option.per_instance = 1;

   RD : coverpoint cov_data.read{
      bins read = {1};}

   DATA : coverpoint cov_data.data_out{
      bins ZERO = {0}; 
      bins LOW1 = {[1:500]};
      bins LOW2 = {[501:1000]};
      bins MID_LOW = {[1001:1500]};
      bins MID = {[1501:2000]};
      bins MID_HIGH = {[2001:2500]};
      bins HIGH1 = {[2501:3000]};
      bins HIGH2 = {[3001:4293]};
      bins MAX = {4294};}

   RD_ADD : coverpoint cov_data.rd_address{
      bins ZERO = {0}; 
      bins LOW1 = {[1:585]};
      bins LOW2 = {[586:1170]};
      bins MID_LOW = {[1171:1755]};
      bins MID = {[1756:2340]};
      bins MID_HIGH = {[2341:2925]};
      bins HIGH1 = {[2926:3510]};
      bins HIGH2 = {[3511:4094]};
      bins MAX = {4095};}

   RDxRD_ADD : cross RD,RD_ADD;

   endgroup : mem_coverage

   //In constructor
   //pass the mailboxes as arguments
   //make the connections
   
   function new (mailbox #(ram_trans) rm2sb,
                 mailbox #(ram_trans) rdmon2sb);
      this.rm2sb = rm2sb;
      this.rdmon2sb = rdmon2sb;
      mem_coverage = new();
   endfunction : new

   //In virtual task start    
   virtual task start();
      fork
         while(1)
            begin
               rm2sb.get(rm_data);
               rm_data_count++;
               rdmon2sb.get(rcvd_data);
               mon_data_count++;

               check(rcvd_data);
            end
      join_none
   endtask : start

   // Understand and include the virtual task check
   virtual task check(ram_trans rc_data);
      string diff;
      if(rc_data.read == 1) 
         begin
            if (rc_data.data_out == 0)
               $display("SB: Random data not written");
            else if(rc_data.read == 1 && rc_data.data_out != 0)
               begin
                  if(!rm_data.compare(rc_data,diff))
                     begin:failed_compare
                        rc_data.display("SB: Received Data");
                        rm_data.display("SB: Data sent to DUV");
                        $display("%s\n%m\n\n", diff);
                        $finish;
                     end:failed_compare
                  else
                     $display("SB:  %s\n%m\n\n", diff);
            //shallow copy rm_data to cov_data
            cov_data = new rm_data;
            //Call the sample function on the covergroup 
            mem_coverage.sample();
            end
            //Increment data_verified 
            data_verified++;
            //Trigger the event if the verified data count is equal to the sum of number of read and read-write transactions 
            if(data_verified >= (number_of_transactions-rc_data.no_of_write_trans))
               begin
               ->DONE;
               end
         end
   endtask: check

   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   function void report();
      $display("------------------------SCOREBOARD REPORT----------------------------------");
      $display("%0d Read data generated, %0d Received data, %0d data verified", rm_data_count, mon_data_count, data_verified);
      $display("---------------------------------------------------------------------------");
   endfunction: report
    
endclass: ram_sb
