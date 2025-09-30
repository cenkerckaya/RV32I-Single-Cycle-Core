module mux51 (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [31:0] C,
    input logic [31:0] D,
    input logic [31:0] E,
    input logic [2:0] sel,
    output logic [31:0] Result
);

always_comb begin : mux51
    case (sel)
        3'b000: Result = A;
        3'b001: Result = B;
        3'b011: Result = C;
        3'b010: Result = D;
        3'b110: Result = E;
        default: Result = 32'b0;
    endcase
end
    
endmodule
