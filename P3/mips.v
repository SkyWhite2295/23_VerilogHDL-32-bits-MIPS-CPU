module mips(clk, rst, dev1_rd);
  input clk;
  input rst;
  input [31:0] dev1_rd;
  // output signal
  // module pc(clk, pcwr, pcin, pcout);
  wire [31:0] pcout;
  // module im_8k(addr, dout);
  wire [31:0] imout;
  // module ir(clk, irwr, imin, irout);
  wire [31:0] irout;
  // module gpr(clk, rst, gprwr, MemToReg, RegDst, rs, rt, rd, write_30, pc_p4, aluReg_out, dmReg_out, overflow, dataOut_1, dataOut_2, cp0in);
  wire [31:0] dataOut_1, dataOut_2;
  // module aReg(clk, alu_dataOut_1, aReg_out); module bReg(clk, alu_dataOut_2, bReg_out);
  wire [31:0] aReg_out,bReg_out;
  // module alu(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30);
  wire zero, overflow;
  wire [31:0] alu_res;
  // module aluReg(clk, alu_res, aluReg_out, overflow, overflowReg);
  wire [31:0] aluReg_out;
  wire overflowReg;
  // module dm_12k(addr, din, we, clk, dout);
  wire [31:0] dmout;
  // module dr(clk, dmout, drout, islb);
  wire [31:0] drout;
  // module npc(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout, ERET, EPC, intreq);
  wire [31:0] npc_out;
  // module ext(imm16, ExtOp, ext32);
  wire [31:0] ext32;
  // module controller(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb);
  // intreq, cp0_wen, bridge_wen, M, exlset, exlclr, intpc
  wire [1:0] RegDst, MemToReg, npc_sel, ALUOp, ExtOp;
  wire RegWrite, ALUSrc, MemWrite, write_30, pcwr, irwr;
  wire islb, issb;
  wire cp0_wen, bridge_wen, exlset, exlclr, intpc;
  // dmin
  wire [31:0] dm_datain;
  // module bridge(praddr, prwd, dev0_rd, dev1_rd, dev2_rd, wecpu, IRQ, prrd, dev_wd, dev_addr, wedev0, wedev2, HWInt);
  wire [31:0] prrd, dev_wd;
  wire [31:0] dev_addr;
  wire wedev0, wedev2;  // 0 timer   2 dataOut
  wire [5:0] HWInt;
  // module timer(CLK_I, RST_I, ADDR_I, WE_I, DATA_I, DATA_O, IRQ);
  wire [31:0] DATA_O;
  wire IRQ;
  // module cp0(clk, rst, wen, exlset, exlclr, sel, HWInt, din, pc_p4, pcout, dout, intreq);
  wire [31:0] epc, cp0dout;
  wire intreq;
  // module lw(addr, drData, bridgeData, muxlwOut);
  wire [31:0] lwOut;
  // module outDev(clk, en, addr, din, dout);
  wire [31:0] outputDev_dout;
  
  // module pc(clk, pcwr, pcin, pcout);
  pc pc(clk,pcwr,npc_out,pcout);
  // module im_1k(addr, dout);
  im_8k im(pcout[12:0],imout);
  // module ir(clk, irwr, imin, irout);
  ir ir(clk,irwr,imout, irout);
  // module gpr(clk, rst, gprwr, MemToReg, RegDst, rs, rt, rd, write_30, pc_p4, aluReg_out, dmReg_out, overflow, dataOut_1, dataOut_2, cp0in);
  gpr gpr(clk,rst,RegWrite,MemToReg,RegDst,irout[25:21],irout[20:16],irout[15:11],write_30,pcout,aluReg_out,lwOut,overflowReg,dataOut_1, dataOut_2, cp0dout);
  // module aReg(clk, alu_dataOut_1, aReg_out); module bReg(clk, alu_dataOut_2, bReg_out);
  aReg aReg(clk, dataOut_1, aReg_out);
  bReg bReg(clk, dataOut_2, bReg_out);
  // module alu(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30);
  alu alu(aReg_out, bReg_out, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30);
  // module aluReg(clk, alu_res, aluReg_out, overflow, overflowReg);
  aluReg aluReg(clk, alu_res, aluReg_out, overflow, overflowReg);
  // module dm_1k(addr, din, we, clk, dout);   din-->dm_datain
  dm_12k dm(aluReg_out[13:0], dm_datain, MemWrite, clk, dmout);
  // module dr(clk, dmout, drout);
  dr dr(clk, dmout, drout, islb);
  // module npc(rst, pcin, pc_ori, npc_sel, zero, imm32, pcout, ERET, EPC, intreq);
  npc npc(rst, dataOut_1, pcout, npc_sel, zero, irout, npc_out, exlclr, epc, intpc);
  // module ext(imm16, ExtOp, ext32);
  ext ext(irout[15:0], ExtOp, ext32);
  // module controller(clk, rst, opcode, funct, zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb);
  // intreq, cp0_wen, bridge_wen, M, exlset, exlclr, intpc
  controller controller(clk,rst,irout[31:26], irout[5:0], zero, RegDst, RegWrite, ALUSrc, MemToReg, MemWrite, npc_sel, ALUOp, ExtOp, write_30, pcwr, irwr, islb, issb, intreq, cp0_wen, bridge_wen, irout[25:21], exlset, exlclr, intpc);
  // module muxdmin(bReg_out, dmout_data, issb, dm_datain);
  dmin dmin(bReg_out, dmout, issb, dm_datain);
  // module bridge(praddr, prwd, dev0_rd, dev1_rd, dev2_rd, wecpu, IRQ, prrd, dev_wd, dev_addr, wedev0, wedev2, HWInt);
  bridge bridge(aluReg_out, bReg_out, DATA_O, dev1_rd, outputDev_dout, bridge_wen, IRQ, prrd, dev_wd, dev_addr, wedev0, wedev2, HWInt);
  // module timer(CLK_I, RST_I, ADDR_I, WE_I, DATA_I, DATA_O, IRQ);
  timer timer(clk, rst, dev_addr[3:2], wedev0, dev_wd, DATA_O, IRQ);
  // module cp0(clk, rst, wen, exlset, exlclr, sel, HWInt, din, pc_p4, pcout, dout, intreq);
  cp0 cp0(clk, rst, cp0_wen, exlset, exlclr, irout[15:11], HWInt, dataOut_2, pcout, epc, cp0dout, intreq);
  // module muxlw(addr, drData, bridgeData, muxlwOut);
  lw lw(aluReg_out, drout, prrd, lwOut);
  // module outputDev(clk, en, addr, din, dout);
  outDev outDev(clk, wedev2, dev_addr[3:2], dev_wd, outputDev_dout);
  
  
endmodule

