module Inst_Mem (
    input logic[31:0] A,
    output logic[31:0] RD
);
    parameter MEM_SIZE = 16384; // 8KB memory size
    
    logic [31:0] memory [MEM_SIZE-1:0];
    logic [13:0] addr;
    
    assign addr = A[15:2];
    assign RD = memory[addr];
    // Memory read operation
    initial begin
        $readmemh("imem.hex", memory);
    end
endmodule
