`timescale 1ns/1ps

module tb_cpu;

reg clk;
reg reset;

cpu_top dut(
    .clk(clk),
    .reset(reset)
);

// generate clock
always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    #200;

    $finish;

end

// waveform dump
initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, tb_cpu);
end

initial begin

    $monitor(
        "Time=%0t PC=%h x1=%d x4=%d MEM0=%d",
        $time,
        dut.pc_out,
        dut.rf.registers[1],
        dut.rf.registers[4],
        dut.dmem.memory[0]
    );

end
endmodule