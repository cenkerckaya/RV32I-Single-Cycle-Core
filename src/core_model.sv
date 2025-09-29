module core_model       // instruction memory initialization file
(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic [32-1:0] addr_i,
    output logic [32-1:0] data_o,
    output logic update_o,
    output logic [32-1:0] pc_o,
    output logic [32-1:0] instr_o,
    output logic [4:0] reg_addr_o,
    output logic [32-1:0] reg_data_o,
    output logic [32-1:0] mem_addr_o,
    output logic [32-1:0] mem_data_o,
    output logic mem_wrt_o
);

    import riscv_pkg::*;
    
    logic [32-1:0] PC, PCNext;
    logic [32-1:0] instr;
    logic [32-1:32-25] instr_ext;
    logic [32-1:0] RD1, RD2, WD3,WD3_Mux, RD, SrcB, Extend_out, MUX_PC;
    logic [4:0] A1, A2, A3;
    logic [32-1:0] imm_out;
    logic ALUSrc, PCSrc, ResultSrc, PC4Src, OffSrc, ExtendSrc, S_OffSrc;
    logic [32-1:0] pc4, pcOffset, sign_offset;
    logic [32-1:0] ALUResult;
    logic [32-1:0] DataMux_o;
    logic [2:0] Extend_Sel;
    logic [3:0] ALUControl;
    logic WE3, WE;
    logic zero, greater, less, u_greater, u_less;
    logic add_sub_mode;
    logic add_mode = 1'b0;
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [1:0] funct7;
    logic [4:0] c_sel;
    assign instr_ext = instr[31:7];
    assign A1 = instr[19:15];
    assign A2 = instr[24:20];
    assign A3 = instr[11:7];
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[30:29];
    assign c_sel = instr[24:20];

    // input output assignments
    assign pc_o = PC;
    assign instr_o = instr;
    assign reg_addr_o = WE3 ? A3 : 'b0;
    assign reg_data_o = WD3;
    assign mem_addr_o = ALUResult;
    assign mem_data_o = RD2;
    assign mem_wrt_o = WE;


    initial update_o = 1'b0;

    always_ff @(clk_i) begin 
        update_o <= ~update_o;        
    end


    // Instantiate the instruction memory
    Inst_Mem imem (
        .A(PC),
        .RD(instr)
    );

    // Instantiate the data memory
    Data_Mem dmem (
        .clk(clk_i),
        .WE(WE),
        .funct3(funct3),
        .A(ALUResult),
        .WD(RD2),
        .RD(RD),
        .debug_addr(addr_i),
        .debug_data(data_o)
    );

    // Instantiate the program counter
    PC pc (
        .PCNext(PCNext),
        .clk(clk_i),
        .rst(rstn_i),
        .PC(PC)
    );

    // Instantiate the register file
    Reg_File regfile (
        .clk(clk_i),
        .rst(rstn_i),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    ALU alu(
        .A(RD1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .add_sub_mode(add_sub_mode),
        .ALUResult(ALUResult),
        .zero(zero),
        .greater(greater),
        .less(less),
        .u_greater(u_greater),
        .u_less(u_less)
    );

    Extend ext(
        .Inst(instr_ext),
        .Extend_Sel(Extend_Sel),
        .Imm_Out(imm_out)
    );

    assign pcOffset = PC + imm_out;

    assign pc4 = PC + 4;

    mux21 muxALU(
        .A(RD2),
        .B(imm_out),
        .sel(ALUSrc),
        .Result(SrcB)
    );

    mux21 muxPC(
        .A(pc4),
        .B(pcOffset),
        .sel(PCSrc),
        .Result(MUX_PC)
    );

    mux21 muxData(
        .A(ALUResult),
        .B(RD),
        .sel(ResultSrc),
        .Result(DataMux_o)
    );

    mux21 mux4(
        .A(DataMux_o),
        .B(pc4),
        .sel(PC4Src),
        .Result(WD3_Mux)
    );

    mux21 muxExtend(
        .A(WD3_Mux),
        .B(imm_out),
        .sel(ExtendSrc),
        .Result(Extend_out)
    );

    mux21 muxOffset(
        .A(Extend_out),
        .B(pcOffset),
        .sel(OffSrc),
        .Result(WD3)
    );

    assign sign_offset = RD1 + imm_out;

    mux21 muxPCNext(
        .A(MUX_PC),
        .B(sign_offset),
        .sel(S_OffSrc),
        .Result(PCNext)
    );

    Controller ctrl(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .c_sel(c_sel),
        .zero(zero),
        .greater(greater),
        .less(less),
        .u_greater(u_greater),
        .u_less(u_less),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .WE(WE),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .Extend_Sel(Extend_Sel),
        .WE3(WE3),
        .PC4Src(PC4Src),
        .OffSrc(OffSrc),
        .ExtendSrc(ExtendSrc),
        .S_OffSrc(S_OffSrc),
        .add_sub_mode(add_sub_mode)
    );


endmodule
