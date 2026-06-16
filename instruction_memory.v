module instruction_memory(

    input  [31:0] address,
    output reg [31:0] instruction

);

    reg [31:0] memory [0:255];
    
initial begin

    // ADDI x1,x0,10
    memory[0] = 32'h00A00093;

    // ADDI x2,x0,10
    memory[1] = 32'h00A00113;

    // BEQ x1,x2,+8
    memory[2] = 32'h00208463;

    // ADDI x3,x0,99
    memory[3] = 32'h06300193;

    // ADDI x4,x0,55
    memory[4] = 32'h03700213;

end
    always @(*) begin
        instruction = memory[address[31:2]];
    end

endmodule