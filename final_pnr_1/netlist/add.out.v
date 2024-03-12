/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12-SP5-3
// Date      : Thu Feb  3 13:32:20 2022
/////////////////////////////////////////////////////////////


module add ( clk, out, x, y, z );
  output [5:0] out;
  input [3:0] x;
  input [3:0] y;
  input [3:0] z;
  input clk;
  wire   intadd_0_A_2_, intadd_0_A_1_, intadd_0_B_2_, intadd_0_B_1_,
         intadd_0_SUM_0_, intadd_0_n3, intadd_0_n2, intadd_0_n1, n11, n12;
  wire   [3:0] x_q;
  wire   [3:0] y_q;
  wire   [3:0] z_q;
  wire   [5:0] out_wire;

  DFQD1 z_q_reg_3_ ( .D(z[3]), .CP(clk), .Q(z_q[3]) );
  DFQD1 z_q_reg_2_ ( .D(z[2]), .CP(clk), .Q(z_q[2]) );
  DFQD1 z_q_reg_1_ ( .D(z[1]), .CP(clk), .Q(z_q[1]) );
  DFQD1 z_q_reg_0_ ( .D(z[0]), .CP(clk), .Q(z_q[0]) );
  DFQD1 x_q_reg_3_ ( .D(x[3]), .CP(clk), .Q(x_q[3]) );
  DFQD1 x_q_reg_2_ ( .D(x[2]), .CP(clk), .Q(x_q[2]) );
  DFQD1 x_q_reg_1_ ( .D(x[1]), .CP(clk), .Q(x_q[1]) );
  DFQD1 x_q_reg_0_ ( .D(x[0]), .CP(clk), .Q(x_q[0]) );
  DFQD1 y_q_reg_3_ ( .D(y[3]), .CP(clk), .Q(y_q[3]) );
  DFQD1 y_q_reg_2_ ( .D(y[2]), .CP(clk), .Q(y_q[2]) );
  DFQD1 y_q_reg_1_ ( .D(y[1]), .CP(clk), .Q(y_q[1]) );
  DFQD1 y_q_reg_0_ ( .D(y[0]), .CP(clk), .Q(y_q[0]) );
  DFQD1 out_reg_0_ ( .D(out_wire[0]), .CP(clk), .Q(out[0]) );
  DFQD1 out_reg_2_ ( .D(out_wire[2]), .CP(clk), .Q(out[2]) );
  DFQD1 out_reg_3_ ( .D(out_wire[3]), .CP(clk), .Q(out[3]) );
  DFQD1 out_reg_5_ ( .D(out_wire[5]), .CP(clk), .Q(out[5]) );
  DFQD1 out_reg_4_ ( .D(out_wire[4]), .CP(clk), .Q(out[4]) );
  DFQD1 out_reg_1_ ( .D(out_wire[1]), .CP(clk), .Q(out[1]) );
  FA1D0 intadd_0_U4 ( .A(x_q[1]), .B(y_q[1]), .CI(z_q[1]), .CO(intadd_0_n3), 
        .S(intadd_0_SUM_0_) );
  FA1D0 intadd_0_U3 ( .A(intadd_0_A_1_), .B(intadd_0_B_1_), .CI(intadd_0_n3), 
        .CO(intadd_0_n2), .S(out_wire[2]) );
  FA1D0 intadd_0_U2 ( .A(intadd_0_A_2_), .B(intadd_0_B_2_), .CI(intadd_0_n2), 
        .CO(intadd_0_n1), .S(out_wire[3]) );
  IAO21D1 U13 ( .A1(intadd_0_n1), .A2(n12), .B(out_wire[5]), .ZN(out_wire[4])
         );
  AN2XD1 U14 ( .A1(intadd_0_n1), .A2(n12), .Z(out_wire[5]) );
  AN2D0 U15 ( .A1(n11), .A2(intadd_0_SUM_0_), .Z(intadd_0_A_1_) );
  IAO21D0 U16 ( .A1(n11), .A2(intadd_0_SUM_0_), .B(intadd_0_A_1_), .ZN(
        out_wire[1]) );
  FA1D0 U17 ( .A(x_q[0]), .B(y_q[0]), .CI(z_q[0]), .CO(n11), .S(out_wire[0])
         );
  FA1D0 U18 ( .A(x_q[2]), .B(z_q[2]), .CI(y_q[2]), .CO(intadd_0_B_2_), .S(
        intadd_0_B_1_) );
  FA1D0 U19 ( .A(z_q[3]), .B(y_q[3]), .CI(x_q[3]), .CO(n12), .S(intadd_0_A_2_)
         );
endmodule

