// Switch definition
// Uses the smallest inverter to create two pass-gates
// The passgates created between VDD-ZN of one INV, and the ZN-VSS of other INV

module SARADC_SW (
  inout VDD, VSS,
  input SB, S, // Negated and non-negated
  inout Z1, Z2 // Inouts of the switch
);
  
  // We use VDD and VSS in unintended ways
  // TODO: Crimes against the logic (lol)
  
  SARADC_CELL_INVX0_ASSW pgp_lz1 (
    .VNW(VDD), .VPW(VSS),
  // | passg in p |  load Z1 |
    .VDD(Z2), .ZN(Z1), .VSS(Z1), .I(SB)
  );
  SARADC_CELL_INVX0_ASSW pgn_lz1 (
    .VNW(VDD), .VPW(VSS),
  // | load Z1  | passg in n |
    .VDD(Z1), .ZN(Z1), .VSS(Z2), .I(S)
  );
  
  SARADC_CELL_INVX0_ASSW pgp_lz2 (
    .VNW(VDD), .VPW(VSS),
  // | passg in p |  load Z2 |
    .VDD(Z1), .ZN(Z2), .VSS(Z2), .I(SB)
  );
  SARADC_CELL_INVX0_ASSW pgn_lz2 (
    .VNW(VDD), .VPW(VSS),
  // | load Z2  | passg in n |
    .VDD(Z2), .ZN(Z2), .VSS(Z1), .I(S)
  );

endmodule

module SARADC_SW_MULT # (
  parameter N = 3
) (
  inout VDD, VSS,
  input SB, S, // Negated and non-negated
  inout Z1, Z2 // Inouts of the switch
);
  genvar i;
  
  generate
    for(i = 0; i < N; i = i + 1) begin : impl
      SARADC_SW impl (
        .VDD(VDD), .VSS(VSS), 
        .SB(SB), .S(S),
        .Z1(Z1), .Z2(Z2)
      );
    end
  endgenerate
endmodule
