module gpr(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30, write_31, jalAddr);
  input clk, reset, RegWrite; 
  input WriteToGPR_30;
  input [31:0] writeData; 
  input [4:0] writeAddr;  
  input [4:0] readAddr_1; 
  input [4:0] readAddr_2; 
  input write_31;
  input [31:0] jalAddr;
  output  [31:0] dataOut_1;  
  output  [31:0] dataOut_2;  
  reg [31:0] regFile[31:0]; 
  
  assign dataOut_1 = regFile[readAddr_1];
  assign dataOut_2 = regFile[readAddr_2];
  
  integer i;
  
  initial
    begin
      for(i=0; i<32; i=i+1) regFile[i] <= 0;
    end  
  
  always@(posedge clk, posedge reset)
    begin
      if(WriteToGPR_30 == 0)
        regFile[30] <= 32'd0;
    end
  
  
  
  always@(posedge clk, posedge reset)
    begin
      if(reset)
        begin
          for(i=0;i<32;i=i+1) regFile[i] <= 0;
        end
      else if(WriteToGPR_30 == 1)
        regFile[30] <= 32'd1;

      else if(write_31 == 1)
        regFile[31] <= jalAddr;
      else
        $display(" ");
    end
  
  
  // if RegWrite==0, cannot write
  always@(posedge clk, posedge reset)
    begin
      if(reset)
        begin
          for(i=0;i<32;i=i+1) regFile[i] <= 0;
        end
      else if(RegWrite == 1 && writeAddr != 0)
        begin
          regFile[writeAddr] <= writeData;
        end
      else
        begin
          $display("GPR write error");
        end
    end
    
endmodule

