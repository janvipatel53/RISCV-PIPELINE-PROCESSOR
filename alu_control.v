module alu_control(

    input [2:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [2:0] alu_sel

);

always @(*) begin

    case(alu_op)

        // ADD
        3'b000:
            alu_sel = 3'b000;

        // SUB
        3'b001:
            alu_sel = 3'b001;

        // Decode R-Type
        3'b010:
        begin

            case({funct7,funct3})

                {7'b0000000,3'b000}:
                    alu_sel = 3'b000; // ADD

                {7'b0100000,3'b000}:
                    alu_sel = 3'b001; // SUB

                {7'b0000000,3'b111}:
                    alu_sel = 3'b010; // AND

                {7'b0000000,3'b110}:
                    alu_sel = 3'b011; // OR

                {7'b0000000,3'b100}:
                    alu_sel = 3'b100; // XOR

                default:
                    alu_sel = 3'b000;

            endcase

        end

        default:
            alu_sel = 3'b000;

    endcase

end

endmodule