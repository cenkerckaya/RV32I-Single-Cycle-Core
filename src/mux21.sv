module mux21 (
    input logic [31:0] A,B,
    input logic sel,
    output logic [31:0] Result
);
    assign Result = (sel == 1'b0) ? A : B;
endmodule
