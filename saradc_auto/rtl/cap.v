// Capacitor definition
// Use the biggest inverter as a capacitor
// Maybe... is better to use a regular capacitor?

module SARADC_CAP (
  inout VNW, VPW,
  inout VSH, FL // TODO: Ask Li why those names
);

  SARADC_CELL_INVX16_ASCAP impl (
    .VNW(VNW), .VPW(VPW),
    .VDD(FL), .VSS(FL),
    .I(VSH), .ZN(FL)
  );

endmodule

