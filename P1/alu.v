module alu( A, B, ALUOp, zero, alu_out, overflow, shamt);
  input [31:0] A;
  input [31:0] B;
  input [2:0] ALUOp;
  output reg zero;
  output reg [31:0] alu_out;
  output overflow;
  
  input [4:0] shamt;

  /*
  aluop
  000 addu
  001 subu
  010 ori
  011 slt
  100 addi
  101 sll
  */
  wire [32:0] tmp;  
  assign tmp = {A[31],A} + B;  
  assign overflow = (ALUOp == 3'b100) ? ((tmp[32] != tmp[31]) ? 1 : 0) : 0;
  
  always@(*)
    begin
      case(ALUOp)
        3'b000:
          begin
            alu_out = A + B;
          end          
        3'b001:
          begin
            alu_out = A - B;
          end
          
        3'b010:
          begin
            alu_out = A | B;
          end
        
        3'b011:
          begin
            alu_out = ($signed(A)<$signed(B))? 32'd1 : 32'd0;
          end        
        3'b100:
          begin
            alu_out = A + B;
          end
        3'b101:
          begin
            alu_out = B << shamt;
          end
          
        default:
          begin
            $display("invalid aluop");
          end
          
      endcase
      if(A == B)  zero =1;
      else  zero = 0;
      
    end
    
    
endmodule
