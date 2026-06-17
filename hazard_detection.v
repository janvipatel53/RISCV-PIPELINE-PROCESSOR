module hazard_detection(

    input id_ex_mem_read,

    input [4:0] id_ex_rd,

    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,

    output reg pc_write,
    output reg if_id_write,
    output reg control_mux

);

always @(*) begin

    pc_write = 1;
    if_id_write = 1;
    control_mux = 0;

    if(id_ex_mem_read &&
      ((id_ex_rd == if_id_rs1) ||
       (id_ex_rd == if_id_rs2)) &&
       (id_ex_rd != 0))
    begin

        pc_write = 0;
        if_id_write = 0;
        control_mux = 1;

    end

end

endmodule