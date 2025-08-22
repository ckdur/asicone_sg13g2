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
  sg13g2_bpd70 bd_nfpgaio_00();
  sg13g2_IOPadOut16mA pad_miso(.pad(pad_miso_pad), .c2p(pad_miso_c2p));
  sg13g2_bpd70 bd_nfpgaio_01();
  sg13g2_IOPadIn pad_sclk(.pad(pad_sclk_pad), .p2c(pad_sclk_p2c));
  sg13g2_bpd70 bd_pad_sclk();

  sg13g2_IOPadAnalog pad_dum_15();
  sg13g2_bpd70 bd_pad_dum_15();
  sg13g2_IOPadAnalog pad_dum_14();
  sg13g2_bpd70 bd_pad_dum_14();
  sg13g2_IOPadAnalog pad_dum_13();
  sg13g2_bpd70 bd_pad_dum_13();
  sg13g2_IOPadAnalog pad_dum_12();
  sg13g2_bpd70 bd_pad_dum_12();
  sg13g2_IOPadAnalog pad_dum_11();
  sg13g2_bpd70 bd_pad_dum_11();
  sg13g2_IOPadAnalog pad_dum_10();
  sg13g2_bpd70 bd_pad_dum_10();
  sg13g2_IOPadAnalog pad_dum_9();
  sg13g2_bpd70 bd_pad_dum_9();
  sg13g2_IOPadAnalog pad_dum_8();
  sg13g2_bpd70 bd_pad_dum_8();
  sg13g2_IOPadAnalog pad_dum_7();
  sg13g2_bpd70 bd_pad_dum_7();
  sg13g2_IOPadAnalog pad_dum_6();
  sg13g2_bpd70 bd_pad_dum_6();
  sg13g2_IOPadAnalog pad_dum_5();
  sg13g2_bpd70 bd_pad_dum_5();
  sg13g2_IOPadAnalog pad_dum_4();
  sg13g2_bpd70 bd_pad_dum_4();
  sg13g2_IOPadAnalog pad_dum_3();
  sg13g2_bpd70 bd_pad_dum_3();
  sg13g2_IOPadAnalog pad_dum_2();
  sg13g2_bpd70 bd_pad_dum_2();
  sg13g2_IOPadAnalog pad_dum_1();
  sg13g2_bpd70 bd_pad_dum_1();
  sg13g2_IOPadAnalog pad_dum_0();
  sg13g2_bpd70 bd_pad_dum_0();
  sg13g2_Filler2000 FILLER_0();
  sg13g2_Filler1000 FILLER_1();
  sg13g2_Filler2000 FILLER_2();
  sg13g2_Filler1000 FILLER_3();
  sg13g2_Filler2000 FILLER_4();
  sg13g2_Filler1000 FILLER_5();
  sg13g2_Filler2000 FILLER_6();
  sg13g2_Filler1000 FILLER_7();
  sg13g2_Filler2000 FILLER_8();
  sg13g2_Filler1000 FILLER_9();
  sg13g2_Filler2000 FILLER_10();
  sg13g2_Filler1000 FILLER_11();
  sg13g2_Filler2000 FILLER_12();
  sg13g2_Filler1000 FILLER_13();
  sg13g2_Filler2000 FILLER_14();
  sg13g2_Filler1000 FILLER_15();

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
  BUFFD1 spi_adc_result_0(.i(RESULT[0]), .z(RD[0]));
  BUFFD1 spi_adc_result_1(.i(RESULT[1]), .z(RD[1]));
  BUFFD1 spi_adc_result_2(.i(RESULT[2]), .z(RD[2]));
  BUFFD1 spi_adc_result_3(.i(RESULT[3]), .z(RD[3]));
  BUFFD1 spi_adc_result_4(.i(RESULT[4]), .z(RD[4]));
  TIEL tie_spi_0(.zn(RD[5]));
  TIEL tie_spi_1(.zn(RD[6]));
  TIEL tie_spi_2(.zn(RD[7]));
  BUFFD1 spi_adc_valid(.i(pad_adc_valid_c2p), .z(RD[8]));
  BUFFD1 spi_adc_sample(.i(pad_adc_sample_c2p), .z(RD[9]));
  TIEL tie_spi_10(.zn(RD[10]));
  TIEL tie_spi_11(.zn(RD[11]));
  TIEL tie_spi_12(.zn(RD[12]));
  TIEL tie_spi_13(.zn(RD[13]));
  TIEL tie_spi_14(.zn(RD[14]));
  TIEL tie_spi_15(.zn(RD[15]));

  // 0x55AA
  TIEL tie_spi_16(.zn(RD[16]));
  TIEH tie_spi_17(.z (RD[17]));
  TIEL tie_spi_18(.zn(RD[18]));
  TIEH tie_spi_19(.z (RD[19]));
  TIEL tie_spi_20(.zn(RD[20]));
  TIEH tie_spi_21(.z (RD[21]));
  TIEL tie_spi_22(.zn(RD[22]));
  TIEH tie_spi_23(.z (RD[23]));
  TIEH tie_spi_24(.z (RD[24]));
  TIEL tie_spi_25(.zn(RD[25]));
  TIEH tie_spi_26(.z (RD[26]));
  TIEL tie_spi_27(.zn(RD[27]));
  TIEH tie_spi_28(.z (RD[28]));
  TIEL tie_spi_29(.zn(RD[29]));
  TIEH tie_spi_30(.z (RD[30]));
  TIEL tie_spi_31(.zn(RD[31]));

  // Bypass some outputs
  BUFFD1 buf_spi_32(.i(R[0]), .z(RD[32]));
  BUFFD1 buf_spi_33(.i(R[1]), .z(RD[33]));
  BUFFD1 buf_spi_34(.i(R[2]), .z(RD[34]));
  BUFFD1 buf_spi_35(.i(R[3]), .z(RD[35]));
  BUFFD1 buf_spi_36(.i(R[4]), .z(RD[36]));
  BUFFD1 buf_spi_37(.i(R[5]), .z(RD[37]));
  BUFFD1 buf_spi_38(.i(R[6]), .z(RD[38]));
  BUFFD1 buf_spi_39(.i(R[7]), .z(RD[39]));
  BUFFD1 buf_spi_40(.i(R[8]), .z(RD[40]));
  BUFFD1 buf_spi_41(.i(R[9]), .z(RD[41]));
  BUFFD1 buf_spi_42(.i(R[10]), .z(RD[42]));
  BUFFD1 buf_spi_43(.i(R[11]), .z(RD[43]));
  BUFFD1 buf_spi_44(.i(R[12]), .z(RD[44]));
  BUFFD1 buf_spi_45(.i(R[13]), .z(RD[45]));
  BUFFD1 buf_spi_46(.i(R[14]), .z(RD[46]));
  BUFFD1 buf_spi_47(.i(R[15]), .z(RD[47]));

  SPI spi(
    .CEB(pad_cs_p2c), 
    .CLK(pad_sclk_p2c), 
    .DATA(pad_mosi_p2c), 
    .DOUT_DAT(pad_miso_c2p), .DOUT_EN(),
    .RST(pad_adc_rst_p2c), .R(R), .RD(RD)
  );
endmodule
