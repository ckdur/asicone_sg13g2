// Definition of the SARADC
// Combining the analog and the digital

module SARADC #(
  parameter integer NBITS = 8,
  parameter integer NPW = 3, // Number of caps in X for each CDAC unit
  parameter integer NPH = 2 // Number of caps in Y for each CDAC unit
) (
  inout AVDD, VDD, VSS, // NOTE: VDD is the digital VDD
  // Analog signals
  inout VREFH, VREFL, VIN, VIP,
  // Digital signals
  input CLK, RST,
  input GO, 
  output VALID, SAMPLE,
  output [NBITS-1:0] RESULT
);

  // TODO: Is buffering the CLK through the analog the RIGHT WAY?
  wire [NBITS-1:0] RESULTN;
  wire CMPO, CLKBUF;

  SARADC_ANALOG #(
    .NBITS(NBITS),
    .NPW(NPW),
    .NPH(NPH)
  ) analog (
    .VDD(AVDD), .VSS(VSS), 
    .VREFH(VREFH), .VREFL(VREFL), .VIN(VIN), .VIP(VIP),
    .CLK(CLK),
    .VALID(VALID), .SAMPLE(SAMPLE),
    .RESULTP(RESULT), .RESULTN(RESULTN),
    .CMPO(CMPO), .CLKBUF(CLKBUF)
  );

`ifndef DIGTOP
`define DIGTOP sar_logic_wreset
`endif
  `DIGTOP #(
    .NBITS(NBITS)
  ) digital ( 
    .CLK(CLKBUF), .RST(RST),
    .GO(GO),
    .VALID(VALID), .SAMPLE(SAMPLE),
    .RESULTP(RESULT), .RESULTN(RESULTN),
    .CMP(CMPO)
  );
  
endmodule

