module Reg_File (
    input logic clk,
    input logic rst,
    input logic WE3,
    input logic [4:0] A1,A2,A3,
    input logic [31:0] WD3,
    output logic [31:0] RD1,RD2
);
    logic [31:0] register [31:0];

    assign RD1 = register[A1];
    assign RD2 = register[A2];
    assign register[0] = 32'b0;

    always_ff @(posedge clk  or negedge rst) begin 
        if (rst == 0) begin
            for (int i = 0; i<32; i++) begin
                register[i] <= 32'b0;
            end
        end else
        if (WE3 && (A3 != 'b0)) begin
            register[A3] <= WD3;
        end
    end
endmodule
