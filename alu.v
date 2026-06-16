module alu(

    input [31:0] A,
    input [31:0] B,

    input [2:0] sel,

    output reg [31:0] Y,

    output reg carry,
    output reg zero

);

    reg [32:0] temp;

    always @(*) begin

        Y = 32'b0;
        carry = 1'b0;
        temp = 33'b0;

        case(sel)

            3'b000: begin
                temp = A + B;
                Y = temp[31:0];
                carry = temp[32];
            end

            3'b001: begin
                temp = A - B;
                Y = temp[31:0];
                carry = temp[32];
            end

            3'b010: begin
                Y = A & B;
            end

            3'b011: begin
                Y = A | B;
            end

            3'b100: begin
                Y = A ^ B;
            end

            3'b101: begin
                Y = ~A;
            end

            3'b110: begin
                Y = A << 1;
            end

            3'b111: begin
                Y = A >> 1;
            end

        endcase

        zero = (Y == 32'b0);

    end

endmodule