/**
 * READ THIS DESCRIPTION!
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal
    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem
    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem
    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock;
    input reset;
    // Imem
    output [11:0] address_imem;
    input  [31:0] q_imem;
    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input  [31:0] q_dmem;
    // Regfile
    output ctrl_writeEnable;
    output [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input  [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
    // instructions
    wire [4:0]  rd, rs, rt;
    wire [16:0] Imme_17bit;
    wire [4:0]  Opcode;
    wire [26:0] Target_27bit;
    wire [31:0] Imme_32bit, Target_32bit;
    // PC
    wire [31:0] pc_in, pc_out;
    wire [31:0] pc_plus1, pc_plus1N, next_pc;
    wire Br, Br_1, Br_2, Br_Jp, Br_Jp_1, Br_Jp_2, Br_Jp_3;
    wire [31:0] pc_jump;
    // Regfile
    wire Rwe_1, Rwe_2, Rwe_3;
    wire [4:0] rd_r30, rd_rt;
    wire Rd_R30, Rd_R31, Rs_R0, Rd_Rt;
    wire Rd_R30_1, Rd_R30_2, Rd_R30_3, Rd_Rt_1, Rd_Rt_2, Rd_Rt_3;
    // ALU
    wire [31:0] data_operandA, data_operandB;
    wire [4:0]  ctrl_ALUopcode, ctrl_shiftamt;
    wire [31:0] data_result;
    wire isNE, isNotEqual, isLT, isLessThan, ovf, overflow;
    wire ALUin, ALUin_1, ALUin_2;
    // Reg_write
    wire [1:0] Rwd, Ovf;
    wire QDmem, DataR, PC1, T, Ovf_1, Ovf_2, Ovf_3;
    wire [31:0] data_write;

    // Instructions
    assign Opcode = q_imem[31:27];
    // Rd Rs Rt
    assign rd = q_imem[26:22];
    assign rs = q_imem[21:17];
    assign rt = q_imem[16:12];
    // ALU
    assign ctrl_ALUopcode = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] 
        & ~Opcode[1] & ~Opcode[0] ? q_imem[6:2] : 5'b00000;
    assign ctrl_shiftamt  = q_imem[11:7];
    // Imme and Target
    assign Imme_17bit   = q_imem[16:0];  // I type
    assign Target_27bit = q_imem[26:0];  // JI type
    // signed/unsigned extension
    assign Imme_32bit   = Imme_17bit[16] ? {15'b1, Imme_17bit} : {15'b0, Imme_17bit};
    assign Target_32bit = {5'b0, Target_27bit};

    // PC: in, out, clk, reset
    program_counter pc(pc_in, pc_out, clock, reset);
    // last 12bit of PC is the addr of imem
    assign address_imem = pc_out[11:0];
    // PC + 1
    alu_plus1 alu_pc_plus1(pc_out, pc_plus1);
    // PC + 1 + N
    alu_plusn alu_pc_plus1N(pc_plus1, Imme_32bit, pc_plus1N);
    // 00010 bne use isNotEqual
    assign Br_1 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] 
        & ~Opcode[0] & isNotEqual;
    // 00110 blt use ~isLessThan and isNotEqual
    // because a < b means a != b and !(a>b)
    assign Br_2 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & Opcode[1]
        & ~Opcode[0] & ~isLessThan & isNotEqual;
    // Br = 1 when bne or blt
    assign Br = Br_1 | Br_2;
    // PC+1 or PC+1+N
    mux_32bit mux_1_1N(pc_plus1N, pc_plus1, Br, next_pc);
    // Jump mux: jump to R2 when 00100, jump to T when 00001 00011 10110
    mux_32bit mux_jump(data_readRegB, Target_32bit, Br_Jp_2, pc_jump);
    // branch or jump mux
    // Jump when 00001 00011 00100 10110
    // 00001 00011 j T / jal T
    assign Br_Jp_1 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[0];
    // 00100 jr
    assign Br_Jp_2 = ~Opcode[4] & ~Opcode[3] & Opcode[2] 
        & ~Opcode[1] & ~Opcode[0];
    // 10110 bex T
    assign Br_Jp_3 = Opcode[4] & ~Opcode[3] & Opcode[2] 
        & Opcode[1] & ~Opcode[0] & isNotEqual;
    assign Br_Jp = Br_Jp_1 | Br_Jp_2 | Br_Jp_3;
    mux_32bit mux_br_jp(pc_jump, next_pc, Br_Jp, pc_in);

    // Regfile
    // 00101 and 10101 addi setx T
    assign Rwe_1 = ~Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0];
    // 00000 and 01000 alu lw
    assign Rwe_2 = ~Opcode[4] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0];
    // 00011 jal T
    assign Rwe_3 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & Opcode[0];
    // write enable
    assign ctrl_writeEnable = Rwe_1 | Rwe_2 | Rwe_3;
    // Rd = Rstatus
    // 00000(00000 00001) add sub & ovf
    assign Rd_R30_1 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & ~Opcode[1] 
    & ~Opcode[0] & ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] 
    & ~ctrl_ALUopcode[2] & ~ctrl_ALUopcode[1] & overflow;
    // 00101 addi & ovf
    assign Rd_R30_2 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] 
        & Opcode[0] & overflow;
    // 10101 setx T
    assign Rd_R30_3 = Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0];
    assign Rd_R30 = Rd_R30_1 | Rd_R30_2 | Rd_R30_3;
    // Rd = Rstatus
    mux_5bit mux_rd_r30(5'b11110, rd, Rd_R30, rd_r30);
    // 00011 jal T
    assign Rd_R31 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & Opcode[0];
    mux_5bit mux_rd_r30_r31(5'b11111, rd_r30, Rd_R31, ctrl_writeReg);
    // Rs = R0 when 10110 bex T
    assign Rs_R0 = Opcode[4] & ~Opcode[3] & Opcode[2] & Opcode[1] & ~Opcode[0];
    mux_5bit mux_rs_r0(5'b00000, rs, Rs_R0, ctrl_readRegA);
    // Rt = Rd when 00111 00010 00100 00110
    // 00110 00100 blt jr
    assign Rd_Rt_1 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[0];
    // 00010 bne
    assign Rd_Rt_2 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & ~Opcode[0];
    // 00111 sw
    assign Rd_Rt_3 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & Opcode[1] & Opcode[0];
    assign Rd_Rt = Rd_Rt_1 | Rd_Rt_2 | Rd_Rt_3;
    mux_5bit mux_rd_rt(rd, rt, Rd_Rt, rd_rt);
    // R2 = Rstatus when 10110
    mux_5bit mux_rd_rt_r30(5'b11110, rd_rt, Rs_R0, ctrl_readRegB);

    // ALU
    // operandA is always readRegA
    assign data_operandA = data_readRegA;
    // ALUin = 1, choose Imme for I type
    // 00101 00111 addi sw
    assign ALUin_1 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & Opcode[0];
    // 01000 lw
    assign ALUin_2 = ~Opcode[4] & Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0];
    assign ALUin = ALUin_1 | ALUin_2;
    mux_32bit ALUinB(Imme_32bit, data_readRegB, ALUin, data_operandB);
    // ALU module
    alu ALU(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, 
        data_result, isNE, isLT, ovf);
    //overflow needs to be initialized
    assign overflow   = ovf  ? 1'b1 : 1'b0;
    assign isNotEqual = isNE ? 1'b1 : 1'b0;
    assign isLessThan = isLT ? 1'b1 : 1'b0;

    // D-Mem
    // dmem's write enable = 1 only when sw, opcode = 00111
    assign wren = ~Opcode[4] & ~Opcode[3] & Opcode[2] & Opcode[1] & Opcode[0];
    // dmem's address always comes from alu's result
    assign address_dmem = data_result[11:0];
    // input data of dmem always comes from reg_data_b
    assign data = data_readRegB;

    // 01000 lw
    assign QDmem = ~Opcode[4] & Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0];
    // 10101 setx T
    assign T = Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0];
    // 00011 jal T R31 = PC + 1
    assign PC1 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & Opcode[1] & Opcode[0];
    assign Rwd[1] = QDmem | T;
    assign Rwd[0] = QDmem | PC1;
    // select which data will be written into register
    mux_4_1_32bit dmem_Rwd(q_dmem, Target_32bit, pc_plus1, data_result, 
        Rwd, data_write);
    // add 00000(00000)
    assign Ovf_1 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0] 
        & ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2] 
        & ~ctrl_ALUopcode[1] & ~ctrl_ALUopcode[0] & overflow;
    // addi
    assign Ovf_2 = ~Opcode[4] & ~Opcode[3] & Opcode[2] & ~Opcode[1] & Opcode[0] & overflow;
    // sub 00000(00001)
    assign Ovf_3 = ~Opcode[4] & ~Opcode[3] & ~Opcode[2] & ~Opcode[1] & ~Opcode[0] 
        & ~ctrl_ALUopcode[4] & ~ctrl_ALUopcode[3] & ~ctrl_ALUopcode[2]
        & ~ctrl_ALUopcode[1] & ctrl_ALUopcode[0] & overflow;
    assign Ovf[1] = Ovf_1 | Ovf_2;
    assign Ovf[0] = Ovf_1 | Ovf_3;
    // Rstatus = 1 2 3 when add addi sub
    mux_4_1_32bit reg_write_data(32'h00000001, 32'h00000002, 32'h00000003, 
        data_write, Ovf, data_writeReg);

endmodule
