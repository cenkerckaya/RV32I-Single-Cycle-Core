module Data_Mem  (
    input logic clk,WE,
    input logic [2:0] funct3,
    input logic [31:0] A,WD,
    output logic [31:0] RD,

    // debug part
    input logic [31:0] debug_addr,
    output logic [31:0] debug_data
);
    parameter MEM_SIZE = 65536; // 64KB memory size
    
    logic [7:0] memory [MEM_SIZE-1:0];

    always_ff @(posedge clk) begin
        if (WE) begin
            case (funct3)
                3'b000:  memory[A] <= WD[7:0]; 
                3'b001: begin
                        memory[A] <= WD[7:0];
                        memory[A+1] <= WD[15:8];
                end
                3'b010: begin
                        memory[A] <= WD[7:0];
                        memory[A+1] <= WD[15:8];
                        memory[A+2] <= WD[23:16];
                        memory[A+3] <= WD[31:24];
                end
                default: begin 
                        memory[A] <= WD[7:0];
                        memory[A+1] <= WD[15:8];
                        memory[A+2] <= WD[23:16];
                        memory[A+3] <= WD[31:24];
                end
            endcase
        end
    end

    always_comb begin
        case (funct3)
            3'b000: RD = {{24{memory[A][7]}},memory[A]}; 
            3'b001: RD = {{16{memory[A+1][7]}},memory[A+1],memory[A]};
            3'b010: RD = {memory[A+3],memory[A+2],memory[A+1],memory[A]};
            3'b100: RD = {{24{1'b0}},memory[A]};
            3'b101: RD = {{16{1'b0}},memory[A+1],memory[A]};
            default: RD = {memory[A+3],memory[A+2],memory[A+1],memory[A]};
        endcase
    end

    assign debug_data = {memory[debug_addr+3],memory[debug_addr+2],memory[debug_addr+1],memory[debug_addr]};

    integer i;

    initial begin
        for (i = 0; i<65536; i++) begin
            memory[i] = 8'b0;
        end
    end

endmodule
