// Read-back test of the chip SPI (digital/rtl/spix/spi.v) with the RD map of asicone_202508:
// RD[23:16] = 0xAA, RD[31:24] = 0x55 (tie cells), RD[47:32] = R[15:0]. 21-clock read frames:
// write=0, read=1, addr[2:0], 8 dummy bits, 8 bits shifted out on DOUT_DAT.
`timescale 1ns/1ns
module tb;
  reg CEB=1, CLK=0, DATA=0, RST=0;
  wire [63:0] R; wire DO, DOEN;
  // RD as on the chip: [7:0] ADC result (undriven -> 0 here), [15:8] valid/sample, [23:16]=0xAA, [31:24]=0x55, [47:32]=R[15:0]
  wire [47:0] RD = {R[15:0], 8'h55, 8'hAA, 8'h00, 8'h00};
  SPI dut(.CEB(CEB), .CLK(CLK), .DATA(DATA), .DOUT_DAT(DO), .DOUT_EN(DOEN), .RST(RST), .R(R), .RD(RD));
  reg [7:0] rx;
  task xfer(input [20:0] f, output [7:0] got);
    integer k; begin
      got = 0; CEB = 0; #10;
      for (k = 20; k >= 0; k = k - 1) begin
        DATA = f[k]; #10 CLK = 1; #2 got = {got[6:0], DO}; #8 CLK = 0;
      end
      #10 CEB = 1; #10;
      for (k = 0; k < 8; k = k + 1) begin #10 CLK = 1; #10 CLK = 0; end
      #20;
    end endtask
  task wr(input [2:0] a, input [7:0] v); reg [7:0] g; begin xfer({1'b1,1'b0,a,v,8'h00}, g); end endtask
  task rd(input [2:0] a); reg [7:0] g; begin xfer({1'b0,1'b1,a,8'h00,8'h00}, g); $display("read addr %0d -> %h", a, g); end endtask
  initial begin
    #15 RST = 1; #20;
    wr(0, 8'h06); wr(1, 8'h3c);
    rd(2); rd(3); rd(4); rd(5); rd(3); rd(2);
    $finish;
  end
endmodule
