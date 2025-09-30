module Controller (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [1:0] funct7,
    input logic zero, greater, less, u_greater, u_less,
    output logic [1:0] PCSrc,
    output logic [2:0] RegSrc,
    output logic WE,
    output logic [3:0] ALUControl,
    output logic ALUSrc,
    output logic [2:0] Extend_Sel,
    output logic WE3
);

    always_comb begin
        WE = 0;
        WE3 = 0;
        Extend_Sel = 3'b000; 
        ALUSrc = 0;
        PCSrc = 2'b00;
        RegSrc = 3'b000;
        ALUControl = 4'b0000;
        case (opcode)
            7'b0110111: begin
                WE = 0;
                WE3 = 1;
                Extend_Sel = 3'b011; // U-type
                ALUSrc = 0;
                PCSrc = 2'b00;
                RegSrc = 3'b010;
                ALUControl = 4'b0000; // LUI
            end 
            7'b0010111: begin  
                WE = 0;
                WE3 = 1;
                Extend_Sel = 3'b011; // U-type
                ALUSrc = 0;
                PCSrc = 2'b00;
                RegSrc = 3'b110;
                ALUControl = 4'b0000;
            end
            7'b1101111: begin  
                WE = 0;
                WE3 = 1;
                Extend_Sel = 3'b100; // J-type
                ALUSrc = 0;
                PCSrc = 2'b01;
                RegSrc = 3'b011;
                ALUControl = 4'b0000;
            end
            7'b1100111: begin  
                WE = 0;
                WE3 = 1;
                Extend_Sel = 3'b000; // I-type
                ALUSrc = 1;
                PCSrc = 2'b11;
                RegSrc = 3'b011; 
                ALUControl = 4'b0000;
            end
            7'b1100011: begin
                Extend_Sel = 3'b010; // B-type
                ALUSrc = 0;
                if (funct3 == 3'b000 && zero) begin
                    ALUControl = 4'b0000;
                    PCSrc = 2'b01;
                    WE3 = 0;
                end
                else if (funct3 == 3'b001 && !zero) begin
                        ALUControl = 4'b0000;
                        PCSrc = 2'b01;
                        WE3 = 0;
                end 
                else if (funct3 == 3'b100 && less) begin
                        ALUControl = 4'b0000;
                        PCSrc = 2'b01;
                        WE3 = 0;
                end 
                else if (funct3 == 3'b101 && greater) begin
                        ALUControl = 4'b0000;
                        PCSrc = 2'b01;
                        WE3 = 0;
                end 
                else if (funct3 == 3'b110 && u_less) begin
                        ALUControl = 4'b0000;
                        PCSrc = 2'b01;
                        WE3 = 0;
                end 
                else if (funct3 == 3'b111 && u_greater) begin
                        ALUControl = 4'b0000;
                        PCSrc = 2'b01;
                        WE3 = 0;
                end
            end
            7'b0000011: begin
                WE3 = 1;
                Extend_Sel = 3'b000; // I-type
                ALUSrc = 1;
                PCSrc = 2'b00;
                RegSrc = 3'b001;    
                ALUControl = 4'b0000;
            end
            7'b0100011: begin
                WE = 1;
                WE3 = 0;
                Extend_Sel = 3'b001; // S-type
                ALUSrc = 1;
                PCSrc = 2'b00;
                RegSrc = 3'b000;
                ALUControl = 4'b0000;
            end
            7'b0010011: begin
                WE = 0;
                WE3 = 1;
                Extend_Sel = 3'b000; // I-type
                ALUSrc = 1;
                PCSrc = 2'b00;
                RegSrc = 3'b000;
                if (funct3 == 3'b000) begin
                    ALUControl = 4'b0000;
                end
                else if (funct3 == 3'b001) begin
                    ALUControl = 4'b0101;
                end
                else if (funct3 == 3'b010) begin
                    if (less) begin
                        ALUControl = 4'b1000;
                    end else if (!less) begin
                        ALUControl = 4'b1001;
                    end
                end 
                else if (funct3 == 3'b011) begin
                    if (u_less) begin
                        ALUControl = 4'b1000;
                    end else if (!u_less) begin
                        ALUControl = 4'b1001;
                    end
                end 
                else if (funct3 == 3'b100) begin
                    ALUControl = 4'b0100;
                end
                else if (funct3 == 3'b101) begin
                    if (funct7 == 2'b00) begin
                        ALUControl = 4'b0110;
                    end 
                    else if (funct7 == 2'b10) begin
                        ALUControl = 4'b0111;
                    end
                end
                else if (funct3 == 3'b110) begin
                    ALUControl = 4'b0011;
                end 
                else if (funct3 == 3'b111) begin
                    ALUControl = 4'b0010;
                end
                else if (funct3 == 3'b101) begin
                    if (funct7 == 2'b00) begin
                        ALUControl = 4'b0110;
                    end 
                    else if (funct7 == 2'b10) begin
                        ALUControl = 4'b0111;
                    end
                end
            end
            7'b0110011: begin
                WE = 0;
                WE3 = 1;
                ALUSrc = 0;
                PCSrc = 2'b00;
                RegSrc = 3'b000;
                if (funct3 == 3'b000) begin
                    if (funct7 == 2'b00) begin
                        ALUControl = 4'b0000; // ADD
                    end 
                    else if (funct7 == 2'b10) begin
                        ALUControl = 4'b0001; // SUB
                    end
                end
                else if (funct3 == 3'b001) begin
                    ALUControl = 4'b0101;
                end
                else if (funct3 == 3'b010) begin
                    if (less) begin
                        ALUControl = 4'b1000;
                    end 
                    else if (!less) begin
                        ALUControl = 4'b1001;
                    end
                end
                else if (funct3 == 3'b011) begin
                    if (u_less) begin
                        ALUControl = 4'b1000;
                    end 
                    else if (!u_less) begin
                        ALUControl = 4'b1001;
                    end
                end
                else if (funct3 == 3'b100) begin
                    ALUControl = 4'b0100;
                end
                else if (funct3 == 3'b101) begin
                    if (funct7 == 2'b00) begin
                        ALUControl = 4'b0110;
                    end 
                    else if (funct7 == 2'b10) begin
                        ALUControl = 4'b0111;
                    end
                end
                else if (funct3 == 3'b110) begin
                    ALUControl = 4'b0011;
                end
                else if (funct3 == 3'b111) begin
                    ALUControl = 4'b0010;
                end
            end
            default: begin
                WE3 = 0;
                Extend_Sel = 3'b000; 
                ALUSrc = 0;
                WE = 0;
                PCSrc = 2'b00;
                RegSrc = 3'b000;
                ALUControl = 4'b0000;
            end
        endcase
    end
    
endmodule
