module instruction_memory(

    input  [31:0] address,
    output reg [31:0] instruction

);

    reg [31:0] memory [0:255];

   initial begin

    // x1 = 10
    memory[0] = 32'h00A00093;

    // x2 = 20
    memory[1] = 32'h01400113;

    // x3 = x1 + x2
    memory[2] = 32'h002081B3;

    end
    always @(*) begin
        instruction = memory[address[31:2]];
    end

endmodule