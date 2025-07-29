// CDAC dummy definition
// A series of CDAC units acting as dummy
// For matching purposes

module SARADC_CDAC_UNIT_DUMMY # (
  parameter integer NPW = 3, // Number of caps in X for each CDAC unit
  parameter integer NPH = 2 // Number of caps in Y for each CDAC unit
) (
  inout VDD, VSS
);
  // This is a definition of the CDAC
  // NOTE: Why not instance directly in the actual dummy?
  //       is cumbersome to name every single net
  wire CRI, CRIB, CRH, CRHB, CRL, CRLB, VI, VOUTH, VOUTL, VSH, FL;
  SARADC_CDAC_UNIT #(
    .NSW_VI(1),
    .NSW_VOUTH(1),
    .NSW_VOUTL(1),
    .NSW_CAP(NPW*NPH)
  ) cdac_unit (
    .VDD(VDD), .VSS(VSS), 
    .CRI(CRI), .CRIB(CRIB),
    .CRH(CRH), .CRHB(CRHB),
    .CRL(CRL), .CRLB(CRLB),
    .VI(VREF), .VOUTH(VOUTH), .VOUTL(VOUTL),
    .VSH(VSH), .FL(FL)
  );
endmodule

module SARADC_CDAC_DUMMY # (
  parameter integer N = 68,
  parameter integer NPW = 3, // Number of caps in X for each CDAC unit
  parameter integer NPH = 2 // Number of caps in Y for each CDAC unit
) (
  inout VDD, VSS
);
  
  genvar i;
  generate
    for(i = 0; i < N; i = i + 1) begin : dummy
      SARADC_CDAC_UNIT_DUMMY #(.NPW(NPW), .NPH(NPH)) dummy (
        .VDD(VDD), .VSS(VSS)
      );
    end
  endgenerate

endmodule

