module register_file(

    input clk,
    input reg_write,

    input [4:0] rs1,
    input [4:0] rs2,

    input [4:0] rd,

    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2

);

    // 32 registers of 32 bits each
    reg [31:0] registers [0:31];

    // Read ports (Combinational)
    assign read_data1 = registers[rs1];
    assign read_data2 = registers[rs2];

    // Write port (Sequential)
    always @(posedge clk)
    begin

        if(reg_write && (rd != 5'd0))
            registers[rd] <= write_data;

        // Keep x0 permanently zero
        registers[0] <= 32'b0;

    end
integer i;

initial begin
    for(i = 0; i < 32; i = i + 1)
        registers[i] = 32'b0;
end
endmodule