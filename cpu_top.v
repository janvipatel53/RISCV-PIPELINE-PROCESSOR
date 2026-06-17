module cpu_top(
    input clk,
    input reset
);

wire [31:0] pc_out;
wire [31:0] next_pc;
wire [31:0] branch_target;

wire branch_taken;

wire [31:0] instruction;
wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;

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

wire [31:0] id_ex_alu_input_b;
wire [31:0] alu_result;

wire carry;
wire zero;

wire [31:0] memory_data;
wire [31:0] write_back_data;

wire [31:0] id_ex_pc;
wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;
wire [31:0] id_ex_immediate;

wire [4:0] id_ex_rd;
wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;

wire [2:0] id_ex_funct3;
wire [6:0] id_ex_funct7;

wire id_ex_reg_write;
wire id_ex_mem_read;
wire id_ex_mem_write;
wire id_ex_alu_src;
wire id_ex_branch;
wire id_ex_mem_to_reg;

wire [2:0] id_ex_alu_op;

wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_read_data2;

wire [4:0] ex_mem_rd;

wire ex_mem_reg_write;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire ex_mem_branch;

wire [31:0] mem_wb_memory_data;
wire [31:0] mem_wb_alu_result;

wire [4:0] mem_wb_rd;

wire mem_wb_reg_write;
wire mem_wb_mem_to_reg;

assign branch_target =pc_out + immediate;

assign branch_taken = branch & zero;

assign next_pc =
       (branch_taken) ?branch_target :(pc_out + 32'd4);

// select second ALU operand
assign id_ex_alu_input_b =(id_ex_alu_src) ? id_ex_immediate : id_ex_read_data2;

// select data to write back
assign write_back_data = (mem_wb_mem_to_reg) ? mem_wb_memory_data : mem_wb_alu_result;


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

if_id if_id_reg(

    .clk(clk),
    .reset(reset),

    .pc_in(pc_out),
    .instruction_in(instruction),

    .pc_out(if_id_pc),
    .instruction_out(if_id_instruction)

);

// Decode instruction fields
instruction_decoder decoder(
    .instruction(if_id_instruction),
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
    .reg_write(mem_wb_reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(mem_wb_rd),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Immediate generator
sign_extend se(
    .instruction(if_id_instruction),
    .immediate(immediate)
);

// ALU control
alu_control alu_ctrl(
    .alu_op(id_ex_alu_op),
    .funct3(id_ex_funct3),
    .funct7(id_ex_funct7),
    .alu_sel(alu_sel)
);

id_ex id_ex_reg(

    .clk(clk),
    .reset(reset),

    .pc_in(if_id_pc),

    .read_data1_in(read_data1),
    .read_data2_in(read_data2),

    .immediate_in(immediate),

    .rd_in(rd),
    .rs1_in(rs1),
    .rs2_in(rs2),

    .funct3_in(funct3),
    .funct7_in(funct7),

    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),
    .alu_src_in(alu_src),
    .branch_in(branch),
    .mem_to_reg_in(mem_to_reg),

    .alu_op_in(alu_op),

    .pc_out(id_ex_pc),

    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),

    .immediate_out(id_ex_immediate),

    .rd_out(id_ex_rd),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),

    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7),

    .reg_write_out(id_ex_reg_write),
    .mem_read_out(id_ex_mem_read),
    .mem_write_out(id_ex_mem_write),
    .alu_src_out(id_ex_alu_src),
    .branch_out(id_ex_branch),
    .mem_to_reg_out(id_ex_mem_to_reg),

    .alu_op_out(id_ex_alu_op)

);

// Execute stage
alu alu_inst(
    .A(id_ex_read_data1),
    .B(id_ex_alu_input_b),
    .sel(alu_sel),
    .Y(alu_result),
    .carry(carry),
    .zero(zero)
);

ex_mem ex_mem_reg(

    .clk(clk),
    .reset(reset),

    .alu_result_in(alu_result),
    .read_data2_in(id_ex_read_data2),

    .rd_in(id_ex_rd),

    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    .branch_in(id_ex_branch),

    .alu_result_out(ex_mem_alu_result),
    .read_data2_out(ex_mem_read_data2),

    .rd_out(ex_mem_rd),

    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .mem_to_reg_out(ex_mem_mem_to_reg),
    .branch_out(ex_mem_branch)

);

// Data memory
data_memory dmem(
    .clk(clk),
    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),
    .address(ex_mem_alu_result),
    .write_data(ex_mem_read_data2),
    .read_data(memory_data)
);

mem_wb mem_wb_reg(

    .clk(clk),
    .reset(reset),

    .memory_data_in(memory_data),
    .alu_result_in(ex_mem_alu_result),

    .rd_in(ex_mem_rd),

    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),

    .memory_data_out(mem_wb_memory_data),
    .alu_result_out(mem_wb_alu_result),

    .rd_out(mem_wb_rd),

    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)

);

endmodule