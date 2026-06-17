`timescale 1ns/1ps

module testbench_pipeline_demo;

reg clk;
reg reset;

cpu_top dut(
    .clk(clk),
    .reset(reset)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset
initial begin
    reset = 1;
    #10;
    reset = 0;
end

// Waveform Dump
initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0,testbench_pipeline_demo);
end

// Simulation End
initial begin
    #250;
    $finish;
end

// Monitor Important Signals
initial begin

    $display("---------------------------------------------------------------");
    $display(" Time    PC      x1      x2      x3      x4");
    $display("---------------------------------------------------------------");

    $monitor(
        "%5d   %h   %3d     %3d     %3d     %3d",
        $time,
        dut.pc_out,
        dut.rf.registers[1],
        dut.rf.registers[2],
        dut.rf.registers[3],
        dut.rf.registers[4]
    );

end

endmodule