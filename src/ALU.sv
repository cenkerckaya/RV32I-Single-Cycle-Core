module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] ALUControl,
    input logic add_sub_mode,
    output logic [31:0] ALUResult,
    output logic zero, greater, less, u_greater, u_less
);

    logic [31:0] add_result, sub_result, and_result, or_result, xor_result;
    logic [31:0] sll_result, srl_result, sra_result;
    logic signed [31:0] A_sign, B_sign;

    genvar i;
    
    generate
        for (i = 0; i < 32; i++) begin
            assign and_result[i] = A[i] & B[i];
        end
    endgenerate

    generate
        for (i = 0; i<32; i++) begin
            assign or_result[i] = A[i] | B[i];
        end
    endgenerate

    generate
        for (i = 0; i<32; i++) begin
            assign xor_result[i] = A[i] ^ B[i];
        end
    endgenerate

    assign sll_result = A << B[4:0];

    assign srl_result = A >> B[4:0];

    assign sra_result = $signed(A) >>> B[4:0];

    assign zero = (A == B) ? 1'b1 : 1'b0;

    assign u_less = (A < B) ? 1'b1 : 1'b0;
    assign u_greater = (A >= B) ? 1'b1 : 1'b0;
    
    assign A_sign = $signed(A);
    assign B_sign = $signed(B);
    
    assign less = (A_sign < B_sign) ? 1'b1 : 1'b0; 
    assign greater = (A_sign >= B_sign) ? 1'b1 : 1'b0;

    assign add_result = A + B;

    assign sub_result = A - B;

    always_comb begin
        case (ALUControl)
            4'b0000: ALUResult = add_result; // ADD
            4'b0001: ALUResult = sub_result; // SUB
            4'b0010: ALUResult = and_result; // AND
            4'b0011: ALUResult = or_result;  // OR
            4'b0100: ALUResult = xor_result; // XOR
            4'b0101: ALUResult = sll_result; // SLL
            4'b0110: ALUResult = srl_result; // SRL
            4'b0111: ALUResult = sra_result; // SRA
            4'b1000: ALUResult = 32'b1; // rs1 is less than rs2
            4'b1001: ALUResult = 32'b0; // rs1 is not less than rs2
            default: ALUResult = 32'b0;
        endcase
    end

endmodule
