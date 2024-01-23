module ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr, shamt);
  
  
  input clk, reset, npc_sel, zero, j;
  input jr_ctrl;
  input [31:0] jrAddr;

  output [31:0] insout;
  
  output [5:0] opcode;
  output [4:0] rs;
  output [4:0] rt;
  output [4:0] rd;
  output [5:0] funct;
  output [15:0] imm16;
  output [31:0] jalAddr;
  
  
  reg [31:0] pc;
  wire [31:0] pc_n, t1, t0, extout, temp, pc_nn, j_addr, pc_nnn;
  
  wire [15:0] imm;
  
  im_1k im(pc[9:0],insout);
  
  assign imm = insout[15:0];
  assign temp = {{16{imm[15]}},imm};//sign_ext
  assign extout = temp << 2;
  
  assign opcode = insout[31:26];
  assign funct = insout[5:0];
  assign rs = insout[25:21];
  assign rt = insout[20:16];
  assign rd = insout[15:11];
  assign imm16 = insout[15:0];
  assign jalAddr = pc + 4;
  
  output [4:0] shamt;
  assign shamt = insout[10:6];  

  
  initial
    begin
      pc <= 32'h0000_3000;
    end
    
  always@(posedge clk, posedge reset)
  begin
    if(reset) pc <= 32'h0000_3000;
    else  pc <= pc_nnn;
  end
  
  assign pc_nnn = (jr_ctrl == 1) ? jrAddr : pc_nn;
  assign pc_nn = (j == 1) ? j_addr : pc_n;
  assign pc_n = (npc_sel && zero) ? t1 : t0;
  assign j_addr = {t0[31:28], insout[25:0], 2'b00};
  assign t0 = pc + 4;
  assign t1 = t0 + extout;
    
   
endmodule
  
