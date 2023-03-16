module D_mem(
input clk,
input write_en, // WE
input [31:0] A_in, // AlU result signal --> used as address
input [31:0] write_data, // WD
output reg [31:0] read_data // RD
);

reg [31:0] Data_mem [0:63]; // means 64-locations each one of width 32-bits

always@(posedge clk)begin // write synch
if(write_en)
   Data_mem[A_in[31:2]]<= write_data; // word aligned method
end

always@(*)begin // read asynch
  read_data = Data_mem[A_in[31:2]];
end

endmodule

