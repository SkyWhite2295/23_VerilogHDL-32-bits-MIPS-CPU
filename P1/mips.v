module mips(clk, rst);
  input clk;
  input rst;
  
  // module ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr);
  wire [31:0] insout;
  wire [15:0] imm16;
  wire [5:0] opcode;
  wire [5:0] funct;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [31:0] jalAddr;
  
  wire [4:0] shamt;
  
  // module controller(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31);

  wire RegDst; 
  wire RegWrite;  
  wire ALUSrc;
  wire MemtoReg;
  wire MemWrite;
  wire Branch;  //nPC_sel
  wire [2:0] ALUOp;
  wire [1:0] ExtOp;
  wire J;
  wire WriteToGPR_30;
  wire write_31;
  wire jr_ctrl;

  
  // module gpr(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30, write_31, jalAddr);
  wire [31:0] gprOut_1;
  wire [31:0] gprOut_2;
  // module alu( A, B, ALUOp, zero, alu_out, overflow);
  wire zero;
  wire [31:0] alu_out;
  wire overflow;
  
  // module ext(imm16, ExtOp, ext32);
  wire [31:0] ext32;
  // module dm(clk, reset, we, din, addr, dout);
  wire [9:0] dm_addr;
  assign dm_addr = alu_out[9:0];
  wire [31:0] dm_out;
  // module mux_2c1_32bit(sel, din_0, din_1, dout);
  wire [31:0] DataToGPR;
  wire [31:0] muxResToALU;
  // module mux_2c1_5bit(sel, din_0, din_1, dout);
  wire [4:0] AddrToGPR;
  
  
  // module ifu(clk, reset, npc_sel, zero, insout, j, opcode, rs, rt, rd, funct, imm16, jr_ctrl, jrAddr, jalAddr);
  ifu ifu(clk, rst, Branch, zero, insout, J, opcode, rs, rt, rd, funct, imm16, jr_ctrl, gprOut_1, jalAddr, shamt);
  // module controller(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31);
  controller ctrl(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31);
  // module gpr(clk, reset, RegWrite, writeData, writeAddr, readAddr_1, readAddr_2, dataOut_1, dataOut_2, WriteToGPR_30, write_31, jalAddr);
  gpr gpr(clk, rst, RegWrite, DataToGPR, AddrToGPR, rs, rt, gprOut_1, gprOut_2, WriteToGPR_30, write_31, jalAddr);
  // mux_2c1_5bit(sel, din_0, din_1, dout);
  mux_2c1_5bit addrIn_for_gpr(RegDst, rt, rd, AddrToGPR);
  // module alu( A, B, ALUOp, zero, alu_out, overflow);
  alu alu( gprOut_1, muxResToALU, ALUOp, zero, alu_out, overflow, shamt);
  // mux_2c1_32bit(sel, din_0, din_1, dout);
  mux_2c1_32bit din_for_alu_b(ALUSrc, gprOut_2, ext32, muxResToALU);
  // ext(imm16, ExtOp, ext32);
  ext ext(imm16, ExtOp, ext32);
  // module dm(clk, reset, MemWrite, din, addr, dout);
  dm dm(clk, rst, MemWrite, gprOut_2, dm_addr, dm_out);
  // mux_2c1_32bit(sel, din_0, din_1, dout);
  mux_2c1_32bit din_for_gprData(MemtoReg, alu_out, dm_out, DataToGPR);


endmodule




