module timer(CLK_I, RST_I, ADDR_I, WE_I, DATA_I, DATA_O, IRQ);
  input CLK_I, RST_I;
  input [3:2] ADDR_I;
  input WE_I;
  input [31:0] DATA_I;
  output [31:0] DATA_O;
  output IRQ;
  
  reg [31:0] ctrl, preset, count;
  
  wire [31:4]reserved;
  wire im;
  wire [2:1] mode;
  wire enable;
  assign reserved = ctrl[31:4];
  assign im = ctrl[3];  // 0: int disable  1: int able
  assign mode = ctrl[2:1];
  assign enable = ctrl[0];  // 0:count disable 1: count able
  
  assign IRQ = (count==32'b0 && im && mode==2'b00) ? 1 : 0;
  
  assign DATA_O = (ADDR_I == 2'b00) ? ctrl : (ADDR_I == 2'b01) ? preset : (ADDR_I == 2'b10) ? count : count;
  
  initial
  begin
    ctrl = 32'h0000_0000;  //  low 4 bits: _1001
    preset = 32'd0;
    count = 32'd0;
  end
  
  always@(posedge CLK_I)
  begin
    if(RST_I)
      begin
        ctrl = 32'h0000;  //  _1001
        preset = 32'd0;
        count = 32'd0;
      end
    else if(WE_I)
      begin
        case(ADDR_I)
          2'b00:
            begin
              ctrl <= DATA_I;
            end
          2'b01:
            begin
              preset <= DATA_I;
              count <= DATA_I;
            end
          2'b10:
            begin
              count <= DATA_I;
            end
          default:
            begin
              $display(" ");
            end
        endcase
      end
    else if(enable)
      begin
        if(count > 0)
          begin
            count <= count - 1;
          end
        else if(count == 0)
          begin
            case(mode)
              2'b00:
                begin
                  $display("mode 00");
                end
              2'b01:
                begin
                  count <= preset;
                  $display("mode 01");
                end
              default:
                begin
                  $display("illegal mode");
                end
            endcase
          end
      end
  end
  
  
endmodule
