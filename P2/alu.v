module alu(dataOut_1, dataOut_2, ext32, ALUSrc, ALUOp, zero, overflow, alu_res, write_30, shamt);
  input [31:0] dataOut_1, dataOut_2, ext32;
  input [2:0] ALUOp;
  input ALUSrc;
  input write_30;
  output zero, overflow;
  output reg [31:0] alu_res;
  
  wire [31:0] a,b;
  wire [32:0] tmp;
  wire overflow_0;
  assign a = dataOut_1;
  assign b = (ALUSrc == 1'b0) ? dataOut_2 : ext32;
  assign tmp = {a[31],a} + b;
  assign overflow_0 = (ALUOp == 2'b00) ? ((tmp[32] != tmp[31]) ? 1 : 0) : 0;
  assign zero = (alu_res == 32'b0) ? 1 : 0;
  
  assign overflow = (write_30 == 1) ? overflow_0 : 0;
  /*
  000 +
  001 -
  010 |
  011 slt
  100 sll
  */
  input [4:0] shamt;
  
  always@(*)
  begin
    case(ALUOp)
      3'b000:
        begin
          alu_res = a + b;
        end
      3'b001:
        begin
          alu_res = a - b;
        end
      3'b010:
        begin
          alu_res = a | b;
        end
      3'b011:
        begin
          alu_res = ($signed(a)<$signed(b))? 32'd1 : 32'd0;
        end
        
      3'b100:
        begin
          alu_res = b << shamt;
        end
        
      3'b101:
        begin
          alu_res = ($signed(a)>=0)? 32'd0 : 32'd1;
        end  
      
      default:
        begin
          $display("invalid ALUOp!");
        end
    endcase
  end

endmodule

