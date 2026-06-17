module pc(
    input clk,
    input reset,
    input [31:0]next_pc,
    input pc_write,
    output reg [31:0]pc_out
);

always @(posedge clk)
begin
    if(reset)
    pc_out <= 32'b0;
    else if(pc_write)
    pc_out <= next_pc;
end

endmodule