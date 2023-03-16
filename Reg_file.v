module Reg_file( 
input [31:0] in_data, // WD3
input [4:0] read_addr_A, // A1
input [4:0] read_addr_B, // A2
input write_en, // WE3
input [4:0] write_addr, // A3
input clk,    // for synch
output reg [31:0] read_data_A, // RD1
output reg [31:0] read_data_B  // RD2  
);

reg [31:0] regfile [0:31]; // means 32-registers each one of width 32-bits

integer i; // counter for all registers

initial // for initialization all registers by zeros
  begin
    for(i=0 ; i<32 ; i=i+1)
    begin
      regfile[i]<=0;
    end 
  end


always@(posedge clk) // write synch
begin
 if(write_en)
  begin
    regfile[write_addr]<= in_data;  
  end
end // for always block 


always@(*) // read asynch
 begin 
   read_data_A = regfile[read_addr_A];
   read_data_B = regfile[read_addr_B];
 end

endmodule
