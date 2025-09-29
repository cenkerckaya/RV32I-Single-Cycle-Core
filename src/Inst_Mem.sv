module Inst_Mem (
    input logic[31:0] A,
    output logic[31:0] RD
);
    parameter MEM_SIZE = 65536; // 8KB memory size
    
    logic [31:0] memory [MEM_SIZE-1:0];
    logic [15:0] addr;
    
    assign addr = A[17:2];
    assign RD = memory[addr];
    // Memory read operation
    initial begin
        $readmemh("/home/reva/RISC_V/rv-32-single-cycle/src/imem.hex", memory);
    end
endmodule
