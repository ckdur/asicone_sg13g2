`timescale 1ps/1ps
module asicone_202508 (
  pad_cs_pad,
  pad_adc_avdd_pad,
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
  pad_sclk_pad);

// Direction phase 
  inout pad_cs_pad;
  inout pad_adc_avdd_pad;
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

// Variable phase 
  wire pad_cs_pad;
  wire pad_cs_p2c;
  wire pad_adc_avdd_padres;
  wire pad_adc_avdd_pad;
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

// Instantiation phase 
  sg13g2_Corner CORNER_4();
  sg13g2_Corner CORNER_3();
  sg13g2_Corner CORNER_2();
  sg13g2_Corner CORNER_1();

  sg13g2_IOPadIn pad_cs(.pad(pad_cs_pad), .p2c(pad_cs_p2c));
  sg13g2_bpd70 bd_pad_cs();
  sg13g2_IOPadAnalog pad_adc_avdd(.padres(pad_adc_avdd_padres), .pad(pad_adc_avdd_pad));
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
  sg13g2_IOPadVss pad_adc_vss();
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
  sg13g2_IOPadVss pad_vss_north_0();
  sg13g2_bpd70 bd_vss_north_0();
  sg13g2_IOPadVdd pad_vdd_north_0();
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

  //SARADC adc();
  SPI spi();
endmodule
