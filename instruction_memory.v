module instruction_memory(

    input  [31:0] address,
    output reg [31:0] instruction

);

    reg [31:0] memory [0:255];
    
initial begin

    // LW x1,0(x0)
    memory[0] = 32'h00002083;

    // ADD x2,x1,x1
    memory[1] = 32'h00108133;

end
    always @(*) begin
        instruction = memory[address[31:2]];
    end

endmodule