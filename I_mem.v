module I_mem(
input [31:0] PC, // address of instruction in instruction memory
output reg [31:0] Instr // output of instruction memory
);


reg [31:0] Imem [0:63]; // means instruction memory with total number 64 instruction each of width = 32 bits

 
    initial begin
        $readmemh("program.txt", Imem , 0);
    end

always@(*) begin
Instr = Imem [PC[31:2]]; // instruction memory is word aligned
end

endmodule
