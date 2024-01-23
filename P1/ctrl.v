module controller(opcode, funct, RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, ALUOp, ExtOp, J, overflow, WriteToGPR_30, jr_ctrl, write_31);
  input [5:0] opcode;
  input [5:0] funct;
  input overflow;
  //RegDst 1:rd, 0:rt; RegWrite 1:enable, 0:disable; ALUSrc 1:ext, 0:B; 
  //MemtoReg 1:dm, 0:alu; MemWrite 1:enable, 0:disable; Branch 1:beq, 0:not beq
  output reg RegDst, RegWrite, ALUSrc, MemtoReg, MemWrite, Branch, J;
  output reg [2:0] ALUOp;//ALUOp 000:+, 001:-, 010:||, 011:slt
  output reg [1:0] ExtOp;//ExtOp 00:0, 01:sign, 10:lui
  output  WriteToGPR_30;//1:addi overflow, write 1 to gpr_30
  output reg jr_ctrl;
  output write_31;//1:jal, save pc+4 to gpr_31

  assign WriteToGPR_30 = (opcode == 6'b001000) ? ((overflow == 1) ? 1 : 0) : 0;
  assign write_31 = (opcode == 6'b000011) ? 1 : 0;
  
  always@(opcode, funct)
  begin
    case(opcode)
      6'b000000:
        begin
          if(funct==6'b100001)//addu
            begin
              RegDst = 1'b1;
              RegWrite = 1'b1;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b000;
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b0;
            end
          else if(funct == 6'b100011)//subu
            begin
              RegDst = 1'b1;
              RegWrite = 1'b1;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b001;
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b0;
            end
            
          else if(funct == 6'b101010)//slt
            begin
              RegDst = 1'b1;
              RegWrite = 1'b1;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b011;
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b0;
            end
            
          else if(funct == 6'b001000)//jr
            begin
              RegDst = 1'b0;
              RegWrite = 1'b0;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b111;
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b1;
            end
          
          else if(funct == 6'b000000)//sll
            begin
              RegDst = 1'b1;
              RegWrite = 1'b1;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b101;
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b0;
            end
            
            
          else  //  prevent invalid operation
            begin
              RegDst = 1'b0;
              RegWrite = 1'b0;
              ALUSrc = 1'b0;
              MemtoReg = 1'b0;
              MemWrite = 1'b0;
              Branch = 1'b0;
              ALUOp = 3'b111;  //alu_op=0 -> alu_out = 0
              ExtOp = 2'b00;
              J = 1'b0;
              jr_ctrl = 1'b0;
            end
        end
      
      6'b001101:  //  ori
        begin
          RegDst = 1'b0;
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b010;
          ExtOp = 2'b00;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b100011:  //  lw
        begin
          RegDst = 1'b0;
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          MemtoReg = 1'b1;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b000;
          ExtOp = 2'b01;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b101011:  //  sw
        begin
          RegDst = 1'b0;
          RegWrite = 1'b0;
          ALUSrc = 1'b1;
          MemtoReg = 1'b0;
          MemWrite = 1'b1;
          Branch = 1'b0;
          ALUOp = 3'b000;
          ExtOp = 2'b01;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b000100:  //  beq
        begin
          RegDst = 1'b0;
          RegWrite = 1'b0;
          ALUSrc = 1'b0;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b1;
          ALUOp = 3'b001;
          ExtOp = 2'b00;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b001111:  //  lui
        begin
          RegDst = 1'b0;
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b000;
          ExtOp = 2'b10;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b000010:  //  j
        begin
          RegDst = 1'b0;
          RegWrite = 1'b0;
          ALUSrc = 1'b0;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b000;
          ExtOp = 2'b00;
          J = 1'b1;
          jr_ctrl = 1'b0;
        end
        
      6'b001000:  //  addi
        begin
          RegDst = 1'b0;  // rt
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b100;
          ExtOp = 2'b01;
          J = 1'b0;
          jr_ctrl = 1'b0;
            
        end
      
      6'b001001:  //  addiu
        begin
          RegDst = 1'b0;
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b000;
          ExtOp = 2'b01;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
      6'b000011:  //  jal
        begin
          RegDst = 1'b0;
          RegWrite = 1'b0;
          ALUSrc = 1'b0;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b111;
          ExtOp = 2'b00;
          J = 1'b1;
          jr_ctrl = 1'b0;
          
        end
      

        
      default:  //  prevent invalid operation
        begin
          RegDst = 1'b0;
          RegWrite = 1'b0;
          ALUSrc = 1'b0;
          MemtoReg = 1'b0;
          MemWrite = 1'b0;
          Branch = 1'b0;
          ALUOp = 3'b111;
          ExtOp = 2'b00;
          J = 1'b0;
          jr_ctrl = 1'b0;
        end
        
    endcase
  
  end
  
endmodule

