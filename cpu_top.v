module cpu_top(
    input clk,
    input reset
);

wire [31:0] pc_out;
wire [31:0] next_pc;
wire [31:0] branch_target;

wire branch_taken;

wire [31:0] instruction;

wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;

wire reg_write;
wire mem_read;
wire mem_write;
wire alu_src;
wire branch;
wire mem_to_reg;

wire [2:0] alu_op;
wire [2:0] alu_sel;

wire [31:0] read_data1;
wire [31:0] read_data2;

wire [31:0] immediate;

wire [31:0] alu_input_b;
wire [31:0] alu_result;

wire carry;
wire zero;

wire [31:0] memory_data;
wire [31:0] write_back_data;

assign branch_target =pc_out + immediate;

assign branch_taken = branch & zero;

assign next_pc =
       (branch_taken) ?branch_target :(pc_out + 32'd4);

// select second ALU operand
assign alu_input_b =(alu_src) ? immediate : read_data2;

// select data to write back
assign write_back_data = (mem_to_reg) ? memory_data : alu_result;


// Program Counter
pc pc_inst(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc_out(pc_out)
);

// Instruction Memory
instruction_memory imem(
    .address(pc_out),
    .instruction(instruction)
);

// Decode instruction fields
instruction_decoder decoder(
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
);

// Generate control signals
control_unit ctrl(
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .branch(branch),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op)
);

// Register file
register_file rf(
    .clk(clk),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Immediate generator
sign_extend se(
    .instruction(instruction),
    .immediate(immediate)
);

// ALU control
alu_control alu_ctrl(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_sel(alu_sel)
);

// Execute stage
alu alu_inst(
    .A(read_data1),
    .B(alu_input_b),
    .sel(alu_sel),
    .Y(alu_result),
    .carry(carry),
    .zero(zero)
);

// Data memory
data_memory dmem(
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(alu_result),
    .write_data(read_data2),
    .read_data(memory_data)
);

endmodule