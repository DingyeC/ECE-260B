// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_col (clk, reset, out, q_in, q_out, i_inst, fifo_wr, o_inst);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 8;
parameter col_id = 0;

output reg signed [bw_psum-1:0] out;
input  signed [pr*bw-1:0] q_in;
output signed [pr*bw-1:0] q_out;
input  clk, reset;
input  [1:0] i_inst; // [1]: execute, [0]: load 
output [1:0] o_inst; // [1]: execute, [0]: load 
output fifo_wr;
reg    load_ready_q;
reg    [3:0] cnt_q;
reg    [5:0] cnt1_q;
reg    [1:0] inst_q;
reg    fifo_wr_q;
reg   signed [pr*bw-1:0] query_q;
reg   signed [pr*bw-1:0] key_q;
wire  signed [bw_psum-1:0] psum;

reg   add;

assign o_inst = inst_q;
assign fifo_wr = fifo_wr_q;
assign q_out  = query_q;
//assign out = psum;


mac_16in  mac_16in_instance (
	.clk(clk),
	.reset(reset),
        .a(query_q), 
        .b(key_q),
	.out(psum)
); 



always @ (posedge clk) begin
  if (reset) begin
    cnt_q <= 0;
    cnt1_q <= 0;
    load_ready_q <= 1;
    inst_q <= 0;
    fifo_wr_q <= 0;
    add <= 0;
  end
  else begin
    out <= psum;
    inst_q <= i_inst;
    if (inst_q[0]) begin
       query_q <= q_in;
       if (cnt_q == 9-col_id)begin
         cnt_q <= 0;
         key_q <= q_in;
         load_ready_q <= 0;
       end
       else if (load_ready_q)
         cnt_q <= cnt_q + 1;
    end
    else if(inst_q[1]) begin
      cnt1_q <= cnt1_q + 1;
      if (add) begin
	if(cnt1_q > 4) fifo_wr_q <= 1;
        query_q <= q_in;
        add <= 0;
      end
      else begin
	fifo_wr_q <= 0;
        add <= 1;
      end 
    end
  end
end

endmodule
