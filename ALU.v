module ALU (
input [31:0] SrcA , SrcB ,
input [2:0] sel , 
output reg SF , ZF ,
output reg [31:0] out
);


always@(*) begin

case (sel)
3'b000: out = SrcA+SrcB;
3'b001: out = SrcA<<SrcB;
3'b010: out = SrcA - SrcB;
3'b100: out = SrcA ^ SrcB;
3'b101: out = SrcA >> SrcB;
3'b110: out = SrcA | SrcB;
3'b111: out = SrcA & SrcB;
default: out = 0;

endcase // for case

SF =  out[31];
ZF =  ~(|out);

end  // for always

endmodule
