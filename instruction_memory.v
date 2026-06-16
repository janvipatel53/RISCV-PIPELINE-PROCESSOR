module instruction_memory(

    input  [31:0] address,
    output reg [31:0] instruction

);

    reg [31:0] memory [0:255];

  initial begin

    // ADDI x1,x0,10
    memory[0] = 32'h00A00093;

    // SW x1,0(x0)
    memory[1] = 32'h00102023;

    // LW x4,0(x0)
    memory[2] = 32'h00002203;

end
    always @(*) begin
        instruction = memory[address[31:2]];
    end

endmodule