`timescale 1ns / 1ps


module SineGen
# (parameter         div_factor_freq0 = 3,
                     div_factor_freq1 = 1,
                     depth_p  = 11,  // Total number samples in one period of the signal               
                     width_p  = 16   // Number of bits used to represent amplitude value
             
  ) 
(input clk,                       
 input reset,
 output reg[width_p-1:0] sine_out0, sine_out1
);  


reg [(width_p-1):0] memory [(2**depth_p-1):0];  
reg [depth_p-1:0]  freq_cnt0, freq_cnt1;   
                  
localparam integer SIZE = (2**depth_p); // Total samples in table = 2^11 = 2048 
                                        // Valid indices = 0 to 2047


initial
begin
    $readmemh("sine2048.mem", memory); //read memory
    freq_cnt0 = 0;
    freq_cnt1 = 0;   
    
end
// Defines a sequential process
// Fetches amplitude values and frequency -> generates sine
always @(posedge clk or negedge reset)
begin
 if (!reset)
   begin
       sine_out0 <=  0;
       sine_out1 <=  0;
       freq_cnt0 <=  0;  
       freq_cnt1 <=  0;   
       
   end
   else begin  

    //First frequency
    sine_out0 <= memory[freq_cnt0];
    freq_cnt0 <= freq_cnt0 + div_factor_freq0;        

     //Second frequency
    sine_out1 <= memory[freq_cnt1];
    freq_cnt1 <= freq_cnt1 + div_factor_freq1;       
         
end
end
endmodule