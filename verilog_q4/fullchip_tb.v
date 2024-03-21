// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns/1ps

module fullchip_tb;

parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 8;            // Q & K vector bit precision
parameter bw_psum = 2*bw+4;  // partial sum bit precision
parameter pr = 16;           // how many products added in each dot product 
parameter col = 8;           // how many dot product units are equipped

integer qk_file1 ; // file handler
integer qk_scan_file1 ; // file handler


integer  captured_data1;
integer  weight1 [col*pr-1:0];

integer qk_file2 ; // file handler
integer qk_scan_file2 ; // file handler


integer  captured_data2;
integer  weight2 [col*pr-1:0];
`define NULL 0




integer  K1[col-1:0][pr-1:0];
integer  Q1[total_cycle-1:0][pr-1:0];
integer  result1[total_cycle-1:0][col-1:0];
integer  sum1[total_cycle-1:0];

integer  K2[col-1:0][pr-1:0];
integer  Q2[total_cycle-1:0][pr-1:0];
integer  result2[total_cycle-1:0][col-1:0];
integer  sum2[total_cycle-1:0];

integer i,j,k,t,p,q,s,u, m;





reg reset = 1;
reg clk = 0;
reg [pr*bw-1:0] mem_in1, mem_in2; 
reg ofifo_rd = 0;
wire [18:0] inst; 
reg qmem_rd = 0;
reg qmem_wr = 0; 
reg kmem_rd = 0; 
reg kmem_wr = 0;
reg pmem_rd = 0; 
reg pmem_wr = 0; 
reg execute = 0;
reg load = 0;
reg add = 0;
reg div = 0;
reg [3:0] qkmem_add = 0;
reg [3:0] pmem_add = 0;


assign inst[16] = ofifo_rd;
assign inst[15:12] = qkmem_add;
assign inst[11:8]  = pmem_add;
assign inst[7] = execute;
assign inst[6] = load;
assign inst[5] = qmem_rd;
assign inst[4] = qmem_wr;
assign inst[3] = kmem_rd;
assign inst[2] = kmem_wr;
assign inst[1] = pmem_rd;
assign inst[0] = pmem_wr;
assign inst[17] = add;
assign inst[18] = div;


reg [bw_psum-1:0] temp5b1;
reg [bw_psum+3:0] temp_sum1;
reg [bw_psum*col-1:0] temp16b1;

reg [bw_psum-1:0] temp5b2;
reg [bw_psum+3:0] temp_sum2;
reg [bw_psum*col-1:0] temp16b2;



fullchip #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
      .reset(reset),
      .clk1(clk), 
      .clk2(clk), 
      .mem_in1(mem_in1), 
      .mem_in2(mem_in2), 
      .inst1(inst),
      .inst2(inst)
);


initial begin 

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);



///// Q data txt reading /////

$display("##### Q data txt reading #####");


  qk_file1 = $fopen("qdata.txt", "r");

  //// To get rid of first 3 lines in data file ////
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);


  for (q=0; q<total_cycle; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file1 = $fscanf(qk_file1, "%d\n", captured_data1);
          Q1[q][j] = captured_data1;
          Q2[q][j] = captured_data1;
          //$display("%d\n", K[q][j]);
    end
  end
/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end




///// K data txt reading /////

$display("##### K data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
  end
  reset = 0;

  qk_file1 = $fopen("kdata_core0.txt", "r");
  qk_file2 = $fopen("kdata_core1.txt", "r");

  //// To get rid of first 4 lines in data file ////
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  qk_scan_file1 = $fscanf(qk_file1, "%s\n", captured_data1);
  //// To get rid of first 4 lines in data file ////
  qk_scan_file2 = $fscanf(qk_file2, "%s\n", captured_data2);
  qk_scan_file2 = $fscanf(qk_file2, "%s\n", captured_data2);
  qk_scan_file2 = $fscanf(qk_file2, "%s\n", captured_data2);
  qk_scan_file2 = $fscanf(qk_file2, "%s\n", captured_data2);



  for (q=0; q<col; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          qk_scan_file1 = $fscanf(qk_file1, "%d\n", captured_data1);
          K1[q][j] = captured_data1;
          qk_scan_file2 = $fscanf(qk_file2, "%d\n", captured_data2);
          K2[q][j] = captured_data2;
          //$display("##### %d\n", K[q][j]);
    end
  end
/////////////////////////////////








/////////////// Estimated result printing /////////////////


$display("##### Estimated multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result1[t][q] = 0;
       result2[t][q] = 0;
     end
     sum1[t] = 0;
     sum2[t] = 0;
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result1[t][q] = result1[t][q] + Q1[t][k] * K1[q][k];
            result2[t][q] = result2[t][q] + Q2[t][k] * K2[q][k];
         end
         result1[t][q] = (result1[t][q] > 0) ? result1[t][q]: -result1[t][q];
         result2[t][q] = (result2[t][q] > 0) ? result2[t][q]: -result2[t][q];
         sum1[t] = sum1[t] + result1[t][q];
         sum2[t] = sum2[t] + result2[t][q];
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     sum1[t] = sum1[t]/128;
     sum2[t] = sum2[t]/128;
     for (q=0; q<col; q=q+1) begin 
         temp5b1 = result1[t][q]/(sum1[t]+sum2[t]);
         temp16b1 = {temp16b1[139:0], temp5b1};
         temp5b2 = result2[t][q]/(sum1[t]+sum2[t]);
         temp16b2 = {temp16b2[139:0], temp5b2};
     end

     $display("prd @cycle%2d: %40h", t, temp16b1);
     $display("prd @cycle%2d: %40h", t, temp16b2);
  end

//////////////////////////////////////////////






///// Qmem writing  /////

$display("##### Qmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk = 1'b0;  
    qmem_wr = 1;  if (q>0) qkmem_add = qkmem_add + 1; 
    
    mem_in1[1*bw-1:0*bw] = Q1[q][0];
    mem_in1[2*bw-1:1*bw] = Q1[q][1];
    mem_in1[3*bw-1:2*bw] = Q1[q][2];
    mem_in1[4*bw-1:3*bw] = Q1[q][3];
    mem_in1[5*bw-1:4*bw] = Q1[q][4];
    mem_in1[6*bw-1:5*bw] = Q1[q][5];
    mem_in1[7*bw-1:6*bw] = Q1[q][6];
    mem_in1[8*bw-1:7*bw] = Q1[q][7];
    mem_in1[9*bw-1:8*bw] = Q1[q][8];
    mem_in1[10*bw-1:9*bw] = Q1[q][9];
    mem_in1[11*bw-1:10*bw] = Q1[q][10];
    mem_in1[12*bw-1:11*bw] = Q1[q][11];
    mem_in1[13*bw-1:12*bw] = Q1[q][12];
    mem_in1[14*bw-1:13*bw] = Q1[q][13];
    mem_in1[15*bw-1:14*bw] = Q1[q][14];
    mem_in1[16*bw-1:15*bw] = Q1[q][15];

    mem_in2[1*bw-1:0*bw] = Q2[q][0];
    mem_in2[2*bw-1:1*bw] = Q2[q][1];
    mem_in2[3*bw-1:2*bw] = Q2[q][2];
    mem_in2[4*bw-1:3*bw] = Q2[q][3];
    mem_in2[5*bw-1:4*bw] = Q2[q][4];
    mem_in2[6*bw-1:5*bw] = Q2[q][5];
    mem_in2[7*bw-1:6*bw] = Q2[q][6];
    mem_in2[8*bw-1:7*bw] = Q2[q][7];
    mem_in2[9*bw-1:8*bw] = Q2[q][8];
    mem_in2[10*bw-1:9*bw] = Q2[q][9];
    mem_in2[11*bw-1:10*bw] = Q2[q][10];
    mem_in2[12*bw-1:11*bw] = Q2[q][11];
    mem_in2[13*bw-1:12*bw] = Q2[q][12];
    mem_in2[14*bw-1:13*bw] = Q2[q][13];
    mem_in2[15*bw-1:14*bw] = Q2[q][14];
    mem_in2[16*bw-1:15*bw] = Q2[q][15];

    #0.5 clk = 1'b1;  

  end


  #0.5 clk = 1'b0;  
  qmem_wr = 0; 
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////





///// Kmem writing  /////

$display("##### Kmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk = 1'b0;  
    kmem_wr = 1; if (q>0) qkmem_add = qkmem_add + 1; 
    
    mem_in1[1*bw-1:0*bw] = K1[q][0];
    mem_in1[2*bw-1:1*bw] = K1[q][1];
    mem_in1[3*bw-1:2*bw] = K1[q][2];
    mem_in1[4*bw-1:3*bw] = K1[q][3];
    mem_in1[5*bw-1:4*bw] = K1[q][4];
    mem_in1[6*bw-1:5*bw] = K1[q][5];
    mem_in1[7*bw-1:6*bw] = K1[q][6];
    mem_in1[8*bw-1:7*bw] = K1[q][7];
    mem_in1[9*bw-1:8*bw] = K1[q][8];
    mem_in1[10*bw-1:9*bw] = K1[q][9];
    mem_in1[11*bw-1:10*bw] = K1[q][10];
    mem_in1[12*bw-1:11*bw] = K1[q][11];
    mem_in1[13*bw-1:12*bw] = K1[q][12];
    mem_in1[14*bw-1:13*bw] = K1[q][13];
    mem_in1[15*bw-1:14*bw] = K1[q][14];
    mem_in1[16*bw-1:15*bw] = K1[q][15];

    mem_in2[1*bw-1:0*bw] = K2[q][0];
    mem_in2[2*bw-1:1*bw] = K2[q][1];
    mem_in2[3*bw-1:2*bw] = K2[q][2];
    mem_in2[4*bw-1:3*bw] = K2[q][3];
    mem_in2[5*bw-1:4*bw] = K2[q][4];
    mem_in2[6*bw-1:5*bw] = K2[q][5];
    mem_in2[7*bw-1:6*bw] = K2[q][6];
    mem_in2[8*bw-1:7*bw] = K2[q][7];
    mem_in2[9*bw-1:8*bw] = K2[q][8];
    mem_in2[10*bw-1:9*bw] = K2[q][9];
    mem_in2[11*bw-1:10*bw] = K2[q][10];
    mem_in2[12*bw-1:11*bw] = K2[q][11];
    mem_in2[13*bw-1:12*bw] = K2[q][12];
    mem_in2[14*bw-1:13*bw] = K2[q][13];
    mem_in2[15*bw-1:14*bw] = K2[q][14];
    mem_in2[16*bw-1:15*bw] = K2[q][15];

    #0.5 clk = 1'b1;  

  end

  #0.5 clk = 1'b0;  
  kmem_wr = 0;  
  qkmem_add = 0;
  #0.5 clk = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  
    #0.5 clk = 1'b1;   
  end




/////  K data loading  /////
$display("##### K data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk = 1'b0;  
    load = 1; 
    if (q==1) kmem_rd = 1;
    if (q>1) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  kmem_rd = 0; qkmem_add = 0;
  #0.5 clk = 1'b1;  

  #0.5 clk = 1'b0;  
  load = 0; 
  #0.5 clk = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    execute = 1; 
    qmem_rd = 1;

    if (q>0) begin
       qkmem_add = qkmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  qmem_rd = 0; qkmem_add = 0; execute = 0;
  #0.5 clk = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   
    #0.5 clk = 1'b1;   
 end


////////////// output fifo rd and wb to sfp and psum ///////////////////

$display("##### move ofifo to sfp & psum #####");
  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    ofifo_rd = 1; 
    add = 1; 
    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0;  
  add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  
  #0.5 clk = 1'b0; 
  #0.5 clk = 1'b1;

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  
    div = 1; 

    if (q>0) begin
       pmem_wr = 1; 
    end
    if (q>1) begin
       pmem_add = pmem_add + 1;
    end

    #0.5 clk = 1'b1;  
  end

  #0.5 clk = 1'b0; 
  div = 0;
  pmem_wr = 1; 
  pmem_add = pmem_add + 1;
  #0.5 clk = 1'b1;  
  #0.5 clk = 1'b0;  
  pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  

///////////////////////////////////////////


  #10 $finish;


end

endmodule




