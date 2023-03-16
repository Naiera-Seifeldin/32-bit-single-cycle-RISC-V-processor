module RISC_V (
	input clk,
        input areset
);

    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;
    wire ZF, SF, load, PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite;
    wire [31:0] PC, Instr, SrcA, ALUResult, ReadData, WriteData, ImmExt;
    reg [31:0] SrcB, Result;


 // Instantiations for connecting all modules together
 I_mem i_mem(.PC(PC),.Instr(Instr));

 Sign_extend s_extend(.Instr(Instr[31:7]),.ImmSrc(ImmSrc),.ImmExt(ImmExt));

 ALU alu(.SrcA(SrcA),.SrcB(SrcB),.sel(ALUControl),.out(ALUResult),.ZF(ZF),.SF(SF)); 

 Prog_counter pc(.clk(clk),.PCSrc(PCSrc),.load(load),.areset(areset),.ImmExt(ImmExt),.PC(PC));

 D_mem d_mem(.clk(clk),.write_en(MemWrite),.A_in(ALUResult),.write_data(WriteData),.read_data(ReadData));

 CU cu(.ZF(ZF),.SF(SF),.Instr(Instr),.PCSrc(PCSrc),.load(load),.ALUSrc(ALUSrc),.ALUControl(ALUControl),.ResultSrc(ResultSrc),.MemWrite(MemWrite),.ImmSrc(ImmSrc),.RegWrite(RegWrite));

 Reg_file reg_file(.clk(clk),.write_en(RegWrite),.read_addr_A(Instr[19:15]),.read_addr_B(Instr[24:20]),.write_addr(Instr[11:7]),.in_data(Result),.read_data_A(SrcA),.read_data_B(WriteData));

 // Mux_1 for operand2 (SrcB) in ALU
always@(*)begin
    if(ALUSrc == 0)
    SrcB = WriteData; 
    else
    SrcB = ImmExt;
    //SrcB = ALUSrc?ImmExt:WriteData; // if ALUSrc = 0 >> flase --> WriteData
end

 // MUX_2 out of D_mem
always@(*)begin 
    if(ResultSrc == 1)
    Result = ReadData;
    else
    Result = ALUResult;
    //Result = ResultSrc?ReadData:ALUResult;
end

endmodule
