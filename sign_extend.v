module sign_extend(

    input [31:0] instruction,
    output reg [31:0] immediate

);

wire [6:0] opcode;

assign opcode = instruction[6:0];

always @(*) begin

    case(opcode)

        // ADDI, LW
        7'b0010011,
        7'b0000011:
        begin
            immediate =
                {{20{instruction[31]}},
                  instruction[31:20]};
        end

        // SW
        7'b0100011:
        begin
            immediate =
                {{20{instruction[31]}},
                  instruction[31:25],
                  instruction[11:7]};
        end

        default:
            immediate = 32'b0;

    endcase

end

endmodule