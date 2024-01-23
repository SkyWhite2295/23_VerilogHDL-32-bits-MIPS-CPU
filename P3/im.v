module im_8k(addr, dout);
  
  input [12:0] addr;
  output [31:0] dout;
  
  reg [7:0] im[8192:0];
  
  initial
  begin

    $readmemh("main.txt", im,'h1000);
    $readmemh("int.txt", im,'h0180);
  end
  
  assign dout = {im[addr], im[addr+1], im[addr+2], im[addr+3]};
  
endmodule

