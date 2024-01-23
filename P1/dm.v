module dm(clk, reset, we, din, addr, dout);
  input clk, reset, we;
  input [31:0] din;
  input [9:0] addr;
  output [31:0] dout;
  
  reg [7:0] dm[1023:0];
  
  //wire [9:0] real_addr;
  //assign real_addr = addr[9:0];
  assign dout = {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]}; 
  
  integer i;
  
  initial
    begin
      for(i = 0; i < 1024; i = i + 1) dm[i] <= 0;
    end
    
  always@(posedge clk, posedge reset)
    begin
      if(reset)
        begin
          for(i = 0; i < 1024; i = i + 1) dm[i] <= 0;  
        end
      else
        begin
          if(we)
            begin
              $display("Writing");
              {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]} <= {din[31:24], din[23:16], din[15:8], din[7:0]};
            end
          else
            begin
              $display("MemWrite disabled.") ; 
            end
        end
    end

endmodule

