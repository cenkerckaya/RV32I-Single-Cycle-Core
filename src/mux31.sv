module mux31 (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [31:0] C,
    input logic [1:0] sel,
    output logic [31:0] Result
);

    always_comb begin : mux31
        case (sel)
            2'b00: Result = A;
            2'b01: Result = B;
            2'b11: Result = C;
            default: Result = 32'b0;
        endcase
    end
    
endmodule
