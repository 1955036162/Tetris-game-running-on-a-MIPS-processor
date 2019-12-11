module regfile(
    input  clock, ctrl_writeEnable, ctrl_reset,
    input  [4:0]  ctrl_writeReg, ctrl_readRegA, ctrl_readRegB,
    input  [31:0] data_writeReg,
    output [31:0] data_readRegA, data_readRegB,
    // self defined
    input  [2:0]  addPoints,
    input  [3:0]  blockType,
    input         rotate,
    input  [1:0]  fromGame,
    output [31:0] data_readReg1, data_readReg2, data_readReg3
);

    reg [31:0] registers [31:0];

    always @(posedge clock or posedge ctrl_reset)
    begin
        if(ctrl_reset)
            begin
                integer i;
                for(i = 0; i < 32; i = i + 1)
                    begin
                        registers[i] = 32'd0;
                    end
            end
        else begin
            if(ctrl_writeEnable && ctrl_writeReg != 5'd0) begin
                registers[ctrl_writeReg] = data_writeReg;
            end
            else begin
                registers[29] = fromGame[0] ? {29'b0, addPoints} : registers[29] + 0;
                registers[28] = blockType;
                registers[27] = fromGame[1] ? {31'b0, rotate} : registers[27] + 0;
            end
        end
    end

    assign data_readReg1 = registers[1];
    assign data_readReg2 = registers[2];
    assign data_readReg3 = registers[3];

    assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
    assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];

endmodule
