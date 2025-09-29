module PC (
    input logic [31:0] PCNext,
    input logic clk,rst,
    output logic [31:0] PC
);
    
    always_ff @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            PC <= 32'h8000_0000;
        end else begin
            PC <= PCNext;
        end
    end 
endmodule
