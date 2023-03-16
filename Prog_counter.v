module Prog_counter (

    input clk,PCSrc,load,areset, // input control signals 
    input [31:0] ImmExt, // in taken branch case --> output of sign extend block
    output reg [31:0] PC // current instruction that will enter I_mem
);

    reg [31:0] PCNext; // internal port (wire) that will have the calculated address out of mux (branched or not)

    always @(posedge clk or negedge areset) begin
        if(!areset) // active low reset
        PC<=0;
        else
        begin 
            if(load)
            PC<=PCNext; // output PC will have the calculated next address --> when load is high
            else
            PC<=PC;
        end
    end

    always @(*) begin
          case (PCSrc)
            1'b0:PCNext=PC+3'd4; // default increment by 4
            1'b1:PCNext=PC+ImmExt; // in case of taken branch
            default: PCNext=PC+3'd4; // default increment by 4
        endcase
    end
endmodule
