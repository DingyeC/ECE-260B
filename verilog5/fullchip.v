// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk1, clk2, mem_in1, out1, inst1, mem_in2, out2, inst2, reset);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 16;

input  clk1, clk2; 
input  [pr*bw-1:0] mem_in1, mem_in2; 
input  [18:0] inst1, inst2; 
input  reset;
output [bw_psum*col-1:0] out1, out2;

wire [bw_psum+3:0] sum_out1, sum_out2;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset), 
      .clk(clk1), 
      .mem_in(mem_in1), 
      .inst(inst1),
      .sum_out(sum_out1),
      .sum_in(sum_out2), 
      .fifo_ext_rd(inst2[18]),
      .out(out1)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance2 (
      .reset(reset), 
      .clk(clk2), 
      .mem_in(mem_in2), 
      .inst(inst2),
      .sum_out(sum_out2),
      .sum_in(sum_out1), 
      .fifo_ext_rd(inst1[18]),
      .out(out2)
);

endmodule
