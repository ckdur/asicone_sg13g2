`timescale 1ps/1ps
module asicone_202508 (
  pad_cs_pad,
  pad_adc_vin_pad,
  pad_adc_vip_pad,
  pad_adc_rst_pad,
  pad_adc_clk_pad,
  pad_adc_result_0_pad,
  pad_adc_result_1_pad,
  pad_adc_result_2_pad,
  pad_adc_result_3_pad,
  pad_adc_result_4_pad,
  pad_adc_vrefp_pad,
  pad_adc_vrefn_pad,
  pad_adc_sample_pad,
  pad_adc_valid_pad,
  pad_adc_go_pad,
  pad_mosi_pad,
  pad_miso_pad,
  pad_sclk_pad,

  pad_RO_101_Drain_Force_pad,
  pad_RO_101_Drain_Sense_pad,
  pad_RO_101_extra_load_pad,
  pad_RO_101_Vout_pad,
  pad_RO_101_DUT_gate_pad,

  pad_RO_13_Drain_Force_pad,
  pad_RO_13_Drain_Sense_pad,
  pad_RO_13_extra_load_pad,
  pad_RO_13_Vout_pad,
  pad_RO_13_DUT_gate_pad,
  pad_RO_RST_B_pad,

  ROVDD,
  RO2VDD,
  AVDD,
  VDD,
  VSS,
  VDDIO,
  VSSIO);

// Direction phase 
  inout pad_cs_pad;
  inout pad_adc_vin_pad;
  inout pad_adc_vip_pad;
  inout pad_adc_rst_pad;
  inout pad_adc_clk_pad;
  inout pad_adc_result_0_pad;
  inout pad_adc_result_1_pad;
  inout pad_adc_result_2_pad;
  inout pad_adc_result_3_pad;
  inout pad_adc_result_4_pad;
  inout pad_adc_vrefp_pad;
  inout pad_adc_vrefn_pad;
  inout pad_adc_sample_pad;
  inout pad_adc_valid_pad;
  inout pad_adc_go_pad;
  inout pad_mosi_pad;
  inout pad_miso_pad;
  inout pad_sclk_pad;

  inout pad_RO_101_Drain_Force_pad;
  inout pad_RO_101_Drain_Sense_pad;
  inout pad_RO_101_extra_load_pad;
  inout pad_RO_101_Vout_pad;
  inout pad_RO_101_DUT_gate_pad;

  inout pad_RO_13_Drain_Force_pad;
  inout pad_RO_13_Drain_Sense_pad;
  inout pad_RO_13_extra_load_pad;
  inout pad_RO_13_Vout_pad;
  inout pad_RO_13_DUT_gate_pad;
  inout pad_RO_RST_B_pad;

  inout ROVDD;
  inout RO2VDD;
  inout AVDD;
  inout VSS;
  inout VDD;
  inout VDDD;
  inout VSSD;
  inout VDDIO;
  inout VSSIO;

// Variable phase 
  wire pad_cs_pad;
  wire pad_cs_p2c;
  wire pad_adc_avdd_padres;
  wire pad_adc_vin_padres;
  wire pad_adc_vin_pad;
  wire pad_adc_vip_padres;
  wire pad_adc_vip_pad;
  wire pad_adc_rst_pad;
  wire pad_adc_rst_p2c;
  wire pad_adc_clk_pad;
  wire pad_adc_clk_p2c;
  wire pad_adc_result_0_pad;
  wire pad_adc_result_0_c2p;
  wire pad_adc_result_1_pad;
  wire pad_adc_result_1_c2p;
  wire pad_adc_result_2_pad;
  wire pad_adc_result_2_c2p;
  wire pad_adc_result_3_pad;
  wire pad_adc_result_3_c2p;
  wire pad_adc_result_4_pad;
  wire pad_adc_result_4_c2p;
  wire pad_adc_vrefp_padres;
  wire pad_adc_vrefp_pad;
  wire pad_adc_vrefn_padres;
  wire pad_adc_vrefn_pad;
  wire pad_adc_sample_pad;
  wire pad_adc_sample_c2p;
  wire pad_adc_valid_pad;
  wire pad_adc_valid_c2p;
  wire pad_adc_go_pad;
  wire pad_adc_go_p2c;
  wire pad_mosi_pad;
  wire pad_mosi_p2c;
  wire pad_miso_pad;
  wire pad_miso_c2p;
  wire pad_sclk_pad;
  wire pad_sclk_p2c;

  wire pad_RO_101_Drain_Force_pad;
  wire pad_RO_101_Drain_Force_padres;
  wire pad_RO_101_Drain_Sense_pad;
  wire pad_RO_101_Drain_Sense_padres;
  wire pad_RO_101_extra_load_pad;
  wire pad_RO_101_extra_load_padres;
  wire pad_RO_13_Drain_Force_pad;
  wire pad_RO_13_Drain_Force_padres;
  wire pad_RO_13_Drain_Sense_pad;
  wire pad_RO_13_Drain_Sense_padres;
  wire pad_RO_13_extra_load_pad;
  wire pad_RO_13_extra_load_padres;
  wire pad_RO_101_Vout_pad;
  wire pad_RO_101_Vout_c2p;
  wire pad_RO_13_Vout_pad;
  wire pad_RO_13_Vout_c2p;
  wire pad_RO_101_DUT_gate_pad;
  wire pad_RO_101_DUT_gate_p2c;
  wire pad_RO_13_DUT_gate_pad;
  wire pad_RO_13_DUT_gate_p2c;
  wire pad_RO_RST_B_pad;
  wire pad_RO_RST_B_p2c;

  wire ROVDD;
  wire RO2VDD;
  wire AVDD;
  wire VSS;
  wire VDD;
  wire VDDD;
  wire VSSD;
  wire VDDIO;
  wire VSSIO;
  wire [47:0] RD;
  wire [63:0] R;

// Instantiation phase 
  sg13g2_Corner CORNER_4();
  sg13g2_Corner CORNER_3();
  sg13g2_Corner CORNER_2();
  sg13g2_Corner CORNER_1();

  sg13g2_IOPadIn pad_cs(.pad(pad_cs_pad), .p2c(pad_cs_p2c));
  sg13g2_bpd70 bd_pad_cs();
  sg13g2_IOPadAnalog pad_adc_avdd(.padres(pad_adc_avdd_padres), .pad(AVDD));
  sg13g2_bpd70 bd_pad_adc_avdd();
  sg13g2_IOPadAnalog pad_adc_vin(.padres(pad_adc_vin_padres), .pad(pad_adc_vin_pad));
  sg13g2_bpd70 bd_pad_adc_vin();
  sg13g2_IOPadAnalog pad_adc_vip(.padres(pad_adc_vip_padres), .pad(pad_adc_vip_pad));
  sg13g2_bpd70 bd_pad_adc_vip();
  sg13g2_IOPadIn pad_adc_rst(.pad(pad_adc_rst_pad), .p2c(pad_adc_rst_p2c));
  sg13g2_bpd70 bd_pad_adc_rst();
  sg13g2_IOPadIn pad_adc_clk(.pad(pad_adc_clk_pad), .p2c(pad_adc_clk_p2c));
  sg13g2_bpd70 bd_pad_adc_clk();
  sg13g2_IOPadOut16mA pad_adc_result_0(.pad(pad_adc_result_0_pad), .c2p(pad_adc_result_0_c2p));
  sg13g2_bpd70 bd_pad_adc_result_0();
  sg13g2_IOPadOut16mA pad_adc_result_1(.pad(pad_adc_result_1_pad), .c2p(pad_adc_result_1_c2p));
  sg13g2_bpd70 bd_pad_adc_result_1();
  sg13g2_IOPadOut16mA pad_adc_result_2(.pad(pad_adc_result_2_pad), .c2p(pad_adc_result_2_c2p));
  sg13g2_bpd70 bd_pad_adc_result_2();
  sg13g2_IOPadOut16mA pad_adc_result_3(.pad(pad_adc_result_3_pad), .c2p(pad_adc_result_3_c2p));
  sg13g2_bpd70 bd_pad_adc_result_3();
  sg13g2_IOPadOut16mA pad_adc_result_4(.pad(pad_adc_result_4_pad), .c2p(pad_adc_result_4_c2p));
  sg13g2_bpd70 bd_pad_adc_result_4();
  sg13g2_IOPadVssExt pad_adc_vss();
  sg13g2_bpd70 bd_pad_adc_vss();
  sg13g2_IOPadAnalog pad_adc_vrefp(.padres(pad_adc_vrefp_padres), .pad(pad_adc_vrefp_pad));
  sg13g2_bpd70 bd_pad_adc_vrefp();
  sg13g2_IOPadAnalog pad_adc_vrefn(.padres(pad_adc_vrefn_padres), .pad(pad_adc_vrefn_pad));
  sg13g2_bpd70 bd_pad_adc_vrefn();
  sg13g2_IOPadOut16mA pad_adc_sample(.pad(pad_adc_sample_pad), .c2p(pad_adc_sample_c2p));
  sg13g2_bpd70 bd_pad_adc_sample();
  sg13g2_IOPadOut16mA pad_adc_valid(.pad(pad_adc_valid_pad), .c2p(pad_adc_valid_c2p));
  sg13g2_bpd70 bd_pad_adc_valid();
  sg13g2_IOPadIn pad_adc_go(.pad(pad_adc_go_pad), .p2c(pad_adc_go_p2c));
  sg13g2_bpd70 bd_pad_adc_go();
  sg13g2_IOPadVssExt pad_vss_north_0();
  sg13g2_bpd70 bd_vss_north_0();
  sg13g2_IOPadVddExt pad_vdd_north_0();
  sg13g2_bpd70 bd_vdd_north_0();
  sg13g2_IOPadIOVss pad_vsspst_north_0();
  sg13g2_bpd70 bd_vsspst_north_0();
  sg13g2_IOPadIOVdd pad_vddpst_north_0();
  sg13g2_bpd70 bd_vddpst_north_0();
  sg13g2_IOPadIn pad_mosi(.pad(pad_mosi_pad), .p2c(pad_mosi_p2c));
  sg13g2_bpd70 bd_pad_mosi();
  sg13g2_IOPadOut16mA pad_miso(.pad(pad_miso_pad), .c2p(pad_miso_c2p));
  sg13g2_bpd70 bd_pad_miso();
  sg13g2_IOPadIn pad_sclk(.pad(pad_sclk_pad), .p2c(pad_sclk_p2c));
  sg13g2_bpd70 bd_pad_sclk();

  sg13g2_IOPadAnalog pad_RO_101_Drain_Force(.pad(pad_RO_101_Drain_Force_pad), .padres(pad_RO_101_Drain_Force_padres));
  sg13g2_bpd70 bd_pad_RO_101_Drain_Force();
  sg13g2_IOPadAnalog pad_RO_101_Drain_Sense(.pad(pad_RO_101_Drain_Sense_pad), .padres(pad_RO_101_Drain_Sense_padres));
  sg13g2_bpd70 bd_pad_RO_101_Drain_Sense();
  sg13g2_IOPadAnalog pad_RO_101_extra_load(.pad(pad_RO_101_extra_load_pad), .padres(pad_RO_101_extra_load_padres));
  sg13g2_bpd70 bd_pad_RO_101_extra_load();
  sg13g2_IOPadAnalog pad_RO_13_Drain_Force(.pad(pad_RO_13_Drain_Force_pad), .padres(pad_RO_13_Drain_Force_padres));
  sg13g2_bpd70 bd_pad_RO_13_Drain_Force();
  sg13g2_IOPadAnalog pad_RO_13_Drain_Sense(.pad(pad_RO_13_Drain_Sense_pad), .padres(pad_RO_13_Drain_Sense_padres));
  sg13g2_bpd70 bd_pad_RO_13_Drain_Sense();
  sg13g2_IOPadAnalog pad_RO_13_extra_load(.pad(pad_RO_13_extra_load_pad), .padres(pad_RO_13_extra_load_padres));
  sg13g2_bpd70 bd_pad_RO_13_extra_load();
  sg13g2_IOPadAnalog pad_RO_VDD(.pad(ROVDD), .padres(pad_RO_VDD_padres));
  sg13g2_IOPadAnalog pad_RO2_VDD(.pad(RO2VDD), .padres(pad_RO2_VDD_padres));
  sg13g2_bpd70 bd_pad_RO2_VDD();
  sg13g2_bpd70 bd_pad_RO_VDD();
  sg13g2_IOPadVssExt pad_RO_VSS();
  sg13g2_bpd70 bd_pad_RO_VSS();
  sg13g2_IOPadOut16mA pad_RO_101_Vout(.pad(pad_RO_101_Vout_pad), .c2p(pad_RO_101_Vout_c2p));
  sg13g2_bpd70 bd_pad_RO_101_Vout();
  sg13g2_IOPadOut16mA pad_RO_13_Vout(.pad(pad_RO_13_Vout_pad), .c2p(pad_RO_13_Vout_c2p));
  sg13g2_bpd70 bd_pad_RO_13_Vout();
  sg13g2_IOPadIn pad_RO_101_DUT_gate(.pad(pad_RO_101_DUT_gate_pad), .p2c(pad_RO_101_DUT_gate_p2c));
  sg13g2_bpd70 bd_pad_RO_101_DUT_gate();
  sg13g2_IOPadIn pad_RO_13_DUT_gate(.pad(pad_RO_13_DUT_gate_pad), .p2c(pad_RO_13_DUT_gate_p2c));
  sg13g2_bpd70 bd_pad_RO_13_DUT_gate();
  sg13g2_IOPadIn pad_RO_RST_B(.pad(pad_RO_RST_B_pad), .p2c(pad_RO_RST_B_p2c));
  sg13g2_bpd70 bd_pad_RO_RST_B();

  sg13g2_Filler4000 FILLER_0();
  sg13g2_Filler200 FILLER_1();
  sg13g2_Filler4000 FILLER_2();
  sg13g2_Filler200 FILLER_3();
  sg13g2_Filler4000 FILLER_4();
  sg13g2_Filler200 FILLER_5();
  sg13g2_Filler4000 FILLER_6();
  sg13g2_Filler200 FILLER_7();

  SARADC adc(
    .AVDD(AVDD), .VDD(VDD), .VSS(VSS),
    .VREFH(pad_adc_vrefp_padres), .VREFL(pad_adc_vrefn_padres), 
    .VIN(pad_adc_vin_padres), .VIP(pad_adc_vip_padres),
    .CLK(pad_adc_clk_p2c), .RST(pad_adc_rst_p2c),
    .GO(pad_adc_go_p2c), 
    .VALID(pad_adc_valid_c2p), .SAMPLE(pad_adc_sample_c2p),
    .RESULT({pad_adc_result_4_c2p, pad_adc_result_3_c2p, pad_adc_result_2_c2p, pad_adc_result_1_c2p, pad_adc_result_0_c2p})
  );

  // Just some info
  sg13g2_BUFFD1 spi_adc_result_0(.i(RESULT[0]), .z(RD[0]));
  sg13g2_BUFFD1 spi_adc_result_1(.i(RESULT[1]), .z(RD[1]));
  sg13g2_BUFFD1 spi_adc_result_2(.i(RESULT[2]), .z(RD[2]));
  sg13g2_BUFFD1 spi_adc_result_3(.i(RESULT[3]), .z(RD[3]));
  sg13g2_BUFFD1 spi_adc_result_4(.i(RESULT[4]), .z(RD[4]));
  sg13g2_TIEL tie_spi_0(.zn(RD[5]));
  sg13g2_TIEL tie_spi_1(.zn(RD[6]));
  sg13g2_TIEL tie_spi_2(.zn(RD[7]));
  sg13g2_BUFFD1 spi_adc_valid(.i(pad_adc_valid_c2p), .z(RD[8]));
  sg13g2_BUFFD1 spi_adc_sample(.i(pad_adc_sample_c2p), .z(RD[9]));
  sg13g2_TIEL tie_spi_10(.zn(RD[10]));
  sg13g2_TIEL tie_spi_11(.zn(RD[11]));
  sg13g2_TIEL tie_spi_12(.zn(RD[12]));
  sg13g2_TIEL tie_spi_13(.zn(RD[13]));
  sg13g2_TIEL tie_spi_14(.zn(RD[14]));
  sg13g2_TIEL tie_spi_15(.zn(RD[15]));

  // 0x55AA
  sg13g2_TIEL tie_spi_16(.zn(RD[16]));
  sg13g2_TIEH tie_spi_17(.z (RD[17]));
  sg13g2_TIEL tie_spi_18(.zn(RD[18]));
  sg13g2_TIEH tie_spi_19(.z (RD[19]));
  sg13g2_TIEL tie_spi_20(.zn(RD[20]));
  sg13g2_TIEH tie_spi_21(.z (RD[21]));
  sg13g2_TIEL tie_spi_22(.zn(RD[22]));
  sg13g2_TIEH tie_spi_23(.z (RD[23]));
  sg13g2_TIEH tie_spi_24(.z (RD[24]));
  sg13g2_TIEL tie_spi_25(.zn(RD[25]));
  sg13g2_TIEH tie_spi_26(.z (RD[26]));
  sg13g2_TIEL tie_spi_27(.zn(RD[27]));
  sg13g2_TIEH tie_spi_28(.z (RD[28]));
  sg13g2_TIEL tie_spi_29(.zn(RD[29]));
  sg13g2_TIEH tie_spi_30(.z (RD[30]));
  sg13g2_TIEL tie_spi_31(.zn(RD[31]));

  // Bypass some outputs
  sg13g2_BUFFD1 buf_spi_32(.i(R[0]), .z(RD[32]));
  sg13g2_BUFFD1 buf_spi_33(.i(R[1]), .z(RD[33]));
  sg13g2_BUFFD1 buf_spi_34(.i(R[2]), .z(RD[34]));
  sg13g2_BUFFD1 buf_spi_35(.i(R[3]), .z(RD[35]));
  sg13g2_BUFFD1 buf_spi_36(.i(R[4]), .z(RD[36]));
  sg13g2_BUFFD1 buf_spi_37(.i(R[5]), .z(RD[37]));
  sg13g2_BUFFD1 buf_spi_38(.i(R[6]), .z(RD[38]));
  sg13g2_BUFFD1 buf_spi_39(.i(R[7]), .z(RD[39]));
  sg13g2_BUFFD1 buf_spi_40(.i(R[8]), .z(RD[40]));
  sg13g2_BUFFD1 buf_spi_41(.i(R[9]), .z(RD[41]));
  sg13g2_BUFFD1 buf_spi_42(.i(R[10]), .z(RD[42]));
  sg13g2_BUFFD1 buf_spi_43(.i(R[11]), .z(RD[43]));
  sg13g2_BUFFD1 buf_spi_44(.i(R[12]), .z(RD[44]));
  sg13g2_BUFFD1 buf_spi_45(.i(R[13]), .z(RD[45]));
  sg13g2_BUFFD1 buf_spi_46(.i(R[14]), .z(RD[46]));
  sg13g2_BUFFD1 buf_spi_47(.i(R[15]), .z(RD[47]));

  SPI spi(
    .CEB(pad_cs_p2c), 
    .CLK(pad_sclk_p2c), 
    .DATA(pad_mosi_p2c), 
    .DOUT_DAT(pad_miso_c2p), .DOUT_EN(),
    .RST(pad_adc_rst_p2c), .R(R), .RD(RD)
  );

  top_101 ro_101(
    .n_RO_control(R[0]),
    .RO_control(R[1]),
    .DUT_gate(pad_RO_101_DUT_gate_p2c),
    .DUT_Footer(R[2]),
    .DUT_Header(R[3]),
    .Drain_Sense(pad_RO_101_Drain_Sense_padres),
    .Drain_Force(pad_RO_101_Drain_Force_padres),
    .VDD(ROVDD),
    .VSS(VSS),
    .RSTB(pad_RO_RST_B_p2c),
    .extra_load(pad_RO_101_extra_load_padres),
    .OUT(pad_RO_101_Vout_c2p)
  );

  top_13 ro_13(
    .n_RO_control(R[8]),
    .RO_control(R[9]),
    .DUT_gate(pad_RO_13_DUT_gate_p2c),
    .DUT_Footer(R[10]),
    .DUT_Header(R[11]),
    .Drain_Sense(pad_RO_13_Drain_Sense_padres),
    .Drain_Force(pad_RO_13_Drain_Force_padres),
    .VDD(RO2VDD),
    .VSS(VSS),
    .RSTB(pad_RO_RST_B_p2c),
    .extra_load(pad_RO_13_extra_load_padres),
    .OUT(pad_RO_13_Vout_c2p)
  );
endmodule
