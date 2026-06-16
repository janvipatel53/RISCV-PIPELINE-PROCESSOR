module id_ex(

    input clk,
    input reset,

    input [31:0] pc_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] immediate_in,

    input [4:0] rd_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,

    input [2:0] funct3_in,
    input [6:0] funct7_in,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input alu_src_in,
    input branch_in,
    input mem_to_reg_in,

    input [2:0] alu_op_in,

    output reg [31:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rd_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,

    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg alu_src_out,
    output reg branch_out,
    output reg mem_to_reg_out,

    output reg [2:0] alu_op_out

);

always @(posedge clk) begin

    if(reset) begin

        pc_out <= 0;
        read_data1_out <= 0;
        read_data2_out <= 0;
        immediate_out <= 0;

        rd_out <= 0;
        rs1_out <= 0;
        rs2_out <= 0;

        funct3_out <= 0;
        funct7_out <= 0;

        reg_write_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
        alu_src_out <= 0;
        branch_out <= 0;
        mem_to_reg_out <= 0;

        alu_op_out <= 0;

    end

    else begin

        pc_out <= pc_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;

        rd_out <= rd_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;

        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        alu_src_out <= alu_src_in;
        branch_out <= branch_in;
        mem_to_reg_out <= mem_to_reg_in;

        alu_op_out <= alu_op_in;

    end

end

endmodule