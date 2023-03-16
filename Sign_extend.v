module Sign_extend(
input [31:7] Instr, // instruction out from instruction memory without op-code
input [1:0] ImmSrc, 
output reg [31:0] ImmExt // extended output
);

always@(*) begin
case(ImmSrc)
      //I-Type --> on right side 12-bit immediate value ,, then left side is the extending of last bit
      2'b00:ImmExt = {{20{Instr[31]}},Instr[31:20]};  
      //R-Type --> on right side adding 2 registers ,, then left side is the extending of last bit
      2'b01:ImmExt = {{20{Instr[31]}},Instr[31:25],Instr[11:7]}; 
      //B-Type --> on right side adding 3 registers ,, then left side is the extending of last bit
      2'b10:ImmExt = {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
      default: ImmExt = 0;
  endcase
end

endmodule
