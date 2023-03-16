module CU (
    input [31:0] Instr, // whole instruction coming from I_mem --> will be divided to ports (wires)
    input ZF,SF, // Zero and Sign flags
    output reg PCSrc, // output signal for PC that says branch taken or not
    output load, // for PC
    output reg ALUSrc, // for mux entering to ALU says from which source is op2 --> register file or extend block
    output reg [1:0] ImmSrc, // signal for extend block
    output reg [2:0] ALUControl, // sel line for ALU operation
    output reg RegWrite, // write_en of register file
    output reg ResultSrc, // signal out of mux that says whether input of register file is from D_mem or alu 
    output reg MemWrite // write_en of D_mem
);

    reg Branch; // internal wire from main decoder to and gate to determine address of next instruction for PC

    reg[1:0] ALUOp; // internal wire from main decoder to ALU decoder

    // the division of instruction to 3 wires entering main decoder and ALU decoder
    reg [6:0] op; 
    reg [2:0] funct3;
    reg funct7;

    always @(*) begin // assign the instr parts to internal wires
        op     = Instr[6:0];
        funct3 = Instr[14:12];
        funct7 = Instr[30];
    end


always @(*) begin // ALU decoder output signal cases
    case (ALUOp)
            2'b00:      ALUControl = 3'b000;
            2'b01:
                begin
                    case (funct3)
                        3'b000:  ALUControl = 3'b010; 
                        3'b001:  ALUControl = 3'b010;
                        3'b100:  ALUControl = 3'b010;
                        default: ALUControl = 3'b000;
                    endcase
                end
            2'b10:
                begin
                    case (funct3)
                        3'b000: 
                        begin
                            if ({op[5], funct7}==2'b11) begin
                                ALUControl = 3'b010; // subtract
                            end
                            else begin
                                ALUControl = 3'b000; // add
                            end
                        end 
                        3'b001: ALUControl = 3'b001; // SHL
                        3'b100: ALUControl = 3'b100; // XOR
                        3'b101: ALUControl = 3'b101; // SHR
                        3'b110: ALUControl = 3'b110; // OR
                        3'b111: ALUControl = 3'b111; // AND
                        default: ALUControl = 3'b000;
                    endcase
                end            
            default:    ALUControl = 3'b000;
        endcase
    end


    always @(*) begin // main decoder output signals cases
        case (op)
        7'b000_0011:begin // loadWord
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 1'b1;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end 
        7'b010_0011:begin // storeWord
            RegWrite = 1'b0;
            ImmSrc = 2'b01;
            ALUSrc = 1'b1;
            MemWrite = 1'b1;
	    ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end
        7'b011_0011:begin // R-Type 
            RegWrite = 1'b1;
	    ImmSrc = 2'b00;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b10;
        end
        7'b001_0011:begin // I-Type 
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b10;
        end
        7'b110_0011:begin // Branch Instructions
            RegWrite = 1'b0;
            ImmSrc = 2'b10;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
	    ResultSrc = 1'b0;
            Branch = 1'b1;
            ALUOp = 2'b01;
        end
        default: begin
            RegWrite = 1'b0;
            ImmSrc = 2'b00;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            Branch = 1'b0;
            ALUOp = 2'b00;
        end
        endcase
    end


    always @(*) begin // for PCSrc
        /*if(Branch == 1'b1)
        begin*/
            case (funct3)
            3'b000: PCSrc = Branch & ZF;     // Beq
            3'b001: PCSrc = Branch & ~(ZF); // Bnq 
            3'b100: PCSrc = Branch & SF;  // Blt 
            default: PCSrc=1'b0;
            endcase
        //end
        /*else
        begin
            PCSrc=1'b0; // default PC+4 not taken
        end*/
    end
    
    assign load = 1'b1; 
    
endmodule
