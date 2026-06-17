module forwarding_unit(

    input [4:0] rs1,
    input [4:0] rs2,

    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,

    input ex_mem_reg_write,
    input mem_wb_reg_write,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b

);

always @(*) begin

    forward_a = 2'b00;
    forward_b = 2'b00;

    // EX hazard

    if(ex_mem_reg_write &&
       (ex_mem_rd != 0) &&
       (ex_mem_rd == rs1))
        forward_a = 2'b10;

    if(ex_mem_reg_write &&
       (ex_mem_rd != 0) &&
       (ex_mem_rd == rs2))
        forward_b = 2'b10;

    // MEM hazard

    if(mem_wb_reg_write &&
       (mem_wb_rd != 0) &&
       !(ex_mem_reg_write &&
         (ex_mem_rd != 0) &&
         (ex_mem_rd == rs1)) &&
       (mem_wb_rd == rs1))
        forward_a = 2'b01;

    if(mem_wb_reg_write &&
       (mem_wb_rd != 0) &&
       !(ex_mem_reg_write &&
         (ex_mem_rd != 0) &&
         (ex_mem_rd == rs2)) &&
       (mem_wb_rd == rs2))
        forward_b = 2'b01;

end

endmodule