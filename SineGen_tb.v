`timescale 1ns / 1ps

module SineGen_tb( );

reg clk;                     
reg reset;                 

wire [15:0] sine_out0, sine_out1;

parameter div_factor_freq0 = 3;
parameter div_factor_freq1 = 1;

parameter depth_p  = 11;
parameter width_p  = 16;

localparam SIZE = 2**depth_p ;

reg [(width_p-1):0] sine_out_memory0 [(2**depth_p-1):0];
reg [(width_p-1):0] sine_out_memory1 [(2**depth_p-1):0];

integer i0 = 0;
integer i1 = 0;

SineGen #(.div_factor_freq0(div_factor_freq0), .div_factor_freq1(div_factor_freq1), .depth_p(depth_p), .width_p(width_p))
    dut (
        .clk(clk),
        .reset(reset),
        .sine_out0(sine_out0),
        .sine_out1(sine_out1)
    );

initial
begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial
begin
    reset = 0;
    #50;  
    reset = 1;
end

always @(posedge clk)
begin
    if (reset)
    begin
        
        sine_out_memory0[i0] <= sine_out0;
        sine_out_memory1[i1] <= sine_out1;
        
        
        i0 <= (i0 == SIZE-1) ? 0 : i0 + 1;
        i1 <= (i1 == SIZE-1) ? 0 : i1 + 1;
    end
end

initial
begin
    #100_000_000;
    $display("Simulation complete");
    $stop;
end

endmodule