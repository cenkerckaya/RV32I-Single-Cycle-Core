module Extend (
    input logic [31:7] Inst,
    input logic [2:0] Extend_Sel,
    output logic [31:0] Imm_Out
    );
    always_comb begin
        case (Extend_Sel)
            3'b000: Imm_Out = {{21{Inst[31]}}, {Inst[30:20]}}; // I-type
            3'b001: Imm_Out = {{21{Inst[31]}}, {Inst[30:25]}, {Inst[11:7]}}; // S-type
            3'b010: Imm_Out = {{20{Inst[31]}}, Inst[7], Inst[30:25], Inst[11:8], {1'b0}}; // B-type
            3'b011: Imm_Out = {{Inst[31]}, {Inst[30:12]}, {12{1'b0}}}; // U-type
            3'b100: Imm_Out = {{12{Inst[31]}}, {Inst[19:12]}, {Inst[20]}, {Inst[30:21]}, {1'b0}}; // J-type
            default: Imm_Out = 32'b0;
        endcase
    end
    
endmodule
