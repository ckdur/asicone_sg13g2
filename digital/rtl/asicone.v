// Global asicone netlist

module asicone (
  pad_sclk_pad,
  pad_sclk_p2c,
  pad_mosi_pad,
  pad_mosi_p2c,
  pad_miso_pad,
  pad_miso_c2p,
  pad_cs_pad,
  pad_cs_p2c,
  pad_gpio_0_pad,
  pad_gpio_0_p2c,
  pad_gpio_0_c2p_en,
  pad_gpio_0_c2p,
  pad_gpio_10_pad,
  pad_gpio_10_p2c,
  pad_gpio_10_c2p_en,
  pad_gpio_10_c2p,
  pad_gpio_9_pad,
  pad_gpio_9_p2c,
  pad_gpio_9_c2p_en,
  pad_gpio_9_c2p,
  pad_gpio_8_pad,
  pad_gpio_8_p2c,
  pad_gpio_8_c2p_en,
  pad_gpio_8_c2p,
  pad_gpio_7_pad,
  pad_gpio_7_p2c,
  pad_gpio_7_c2p_en,
  pad_gpio_7_c2p,
  pad_gpio_6_pad,
  pad_gpio_6_p2c,
  pad_gpio_6_c2p_en,
  pad_gpio_6_c2p,
  pad_gpio_11_pad,
  pad_gpio_11_p2c,
  pad_gpio_11_c2p_en,
  pad_gpio_11_c2p,
  pad_gpio_12_pad,
  pad_gpio_12_p2c,
  pad_gpio_12_c2p_en,
  pad_gpio_12_c2p,
  pad_gpio_13_pad,
  pad_gpio_13_p2c,
  pad_gpio_13_c2p_en,
  pad_gpio_13_c2p,
  pad_gpio_14_pad,
  pad_gpio_14_p2c,
  pad_gpio_14_c2p_en,
  pad_gpio_14_c2p,
  pad_gpio_15_pad,
  pad_gpio_15_p2c,
  pad_gpio_5_pad,
  pad_gpio_5_p2c,
  pad_gpio_5_c2p_en,
  pad_gpio_5_c2p,
  pad_gpio_4_pad,
  pad_gpio_4_p2c,
  pad_gpio_4_c2p_en,
  pad_gpio_4_c2p,
  pad_gpio_3_pad,
  pad_gpio_3_p2c,
  pad_gpio_3_c2p_en,
  pad_gpio_3_c2p,
  pad_gpio_2_pad,
  pad_gpio_2_p2c,
  pad_gpio_2_c2p_en,
  pad_gpio_2_c2p,
  pad_gpio_1_pad,
  pad_gpio_1_p2c,
  pad_gpio_1_c2p_en,
  pad_gpio_1_c2p);

// Direction phase 
  inout pad_sclk_pad;
  output pad_sclk_p2c;
  inout pad_mosi_pad;
  output pad_mosi_p2c;
  inout pad_miso_pad;
  input pad_miso_c2p;
  inout pad_cs_pad;
  output pad_cs_p2c;
  inout pad_gpio_0_pad;
  output pad_gpio_0_p2c;
  input pad_gpio_0_c2p_en;
  input pad_gpio_0_c2p;
  inout pad_gpio_10_pad;
  output pad_gpio_10_p2c;
  input pad_gpio_10_c2p_en;
  input pad_gpio_10_c2p;
  inout pad_gpio_9_pad;
  output pad_gpio_9_p2c;
  input pad_gpio_9_c2p_en;
  input pad_gpio_9_c2p;
  inout pad_gpio_8_pad;
  output pad_gpio_8_p2c;
  input pad_gpio_8_c2p_en;
  input pad_gpio_8_c2p;
  inout pad_gpio_7_pad;
  output pad_gpio_7_p2c;
  input pad_gpio_7_c2p_en;
  input pad_gpio_7_c2p;
  inout pad_gpio_6_pad;
  output pad_gpio_6_p2c;
  input pad_gpio_6_c2p_en;
  input pad_gpio_6_c2p;
  inout pad_gpio_11_pad;
  output pad_gpio_11_p2c;
  input pad_gpio_11_c2p_en;
  input pad_gpio_11_c2p;
  inout pad_gpio_12_pad;
  output pad_gpio_12_p2c;
  input pad_gpio_12_c2p_en;
  input pad_gpio_12_c2p;
  inout pad_gpio_13_pad;
  output pad_gpio_13_p2c;
  input pad_gpio_13_c2p_en;
  input pad_gpio_13_c2p;
  inout pad_gpio_14_pad;
  output pad_gpio_14_p2c;
  input pad_gpio_14_c2p_en;
  input pad_gpio_14_c2p;
  inout pad_gpio_15_pad;
  output pad_gpio_15_p2c;
  inout pad_gpio_5_pad;
  output pad_gpio_5_p2c;
  input pad_gpio_5_c2p_en;
  input pad_gpio_5_c2p;
  inout pad_gpio_4_pad;
  output pad_gpio_4_p2c;
  input pad_gpio_4_c2p_en;
  input pad_gpio_4_c2p;
  inout pad_gpio_3_pad;
  output pad_gpio_3_p2c;
  input pad_gpio_3_c2p_en;
  input pad_gpio_3_c2p;
  inout pad_gpio_2_pad;
  output pad_gpio_2_p2c;
  input pad_gpio_2_c2p_en;
  input pad_gpio_2_c2p;
  inout pad_gpio_1_pad;
  output pad_gpio_1_p2c;
  input pad_gpio_1_c2p_en;
  input pad_gpio_1_c2p;

// Variable phase 
  wire pad_sclk_pad;
  wire pad_sclk_p2c;
  wire pad_mosi_pad;
  wire pad_mosi_p2c;
  wire pad_miso_pad;
  wire pad_miso_c2p;
  wire pad_cs_pad;
  wire pad_cs_p2c;
  wire pad_gpio_0_pad;
  wire pad_gpio_0_p2c;
  wire pad_gpio_0_c2p_en;
  wire pad_gpio_0_c2p;
  wire pad_gpio_10_pad;
  wire pad_gpio_10_p2c;
  wire pad_gpio_10_c2p_en;
  wire pad_gpio_10_c2p;
  wire pad_gpio_9_pad;
  wire pad_gpio_9_p2c;
  wire pad_gpio_9_c2p_en;
  wire pad_gpio_9_c2p;
  wire pad_gpio_8_pad;
  wire pad_gpio_8_p2c;
  wire pad_gpio_8_c2p_en;
  wire pad_gpio_8_c2p;
  wire pad_gpio_7_pad;
  wire pad_gpio_7_p2c;
  wire pad_gpio_7_c2p_en;
  wire pad_gpio_7_c2p;
  wire pad_gpio_6_pad;
  wire pad_gpio_6_p2c;
  wire pad_gpio_6_c2p_en;
  wire pad_gpio_6_c2p;
  wire pad_gpio_11_pad;
  wire pad_gpio_11_p2c;
  wire pad_gpio_11_c2p_en;
  wire pad_gpio_11_c2p;
  wire pad_gpio_12_pad;
  wire pad_gpio_12_p2c;
  wire pad_gpio_12_c2p_en;
  wire pad_gpio_12_c2p;
  wire pad_gpio_13_pad;
  wire pad_gpio_13_p2c;
  wire pad_gpio_13_c2p_en;
  wire pad_gpio_13_c2p;
  wire pad_gpio_14_pad;
  wire pad_gpio_14_p2c;
  wire pad_gpio_14_c2p_en;
  wire pad_gpio_14_c2p;
  wire pad_gpio_15_pad;
  wire pad_gpio_15_p2c;
  wire pad_gpio_5_pad;
  wire pad_gpio_5_p2c;
  wire pad_gpio_5_c2p_en;
  wire pad_gpio_5_c2p;
  wire pad_gpio_4_pad;
  wire pad_gpio_4_p2c;
  wire pad_gpio_4_c2p_en;
  wire pad_gpio_4_c2p;
  wire pad_gpio_3_pad;
  wire pad_gpio_3_p2c;
  wire pad_gpio_3_c2p_en;
  wire pad_gpio_3_c2p;
  wire pad_gpio_2_pad;
  wire pad_gpio_2_p2c;
  wire pad_gpio_2_c2p_en;
  wire pad_gpio_2_c2p;
  wire pad_gpio_1_pad;
  wire pad_gpio_1_p2c;
  wire pad_gpio_1_c2p_en;
  wire pad_gpio_1_c2p;

// Instantiation phase 
  sg13g2_Corner CORNER_4();
  sg13g2_Corner CORNER_3();
  sg13g2_Corner CORNER_2();
  sg13g2_Corner CORNER_1();
  sg13g2_IOPadIn pad_sclk(.pad(pad_sclk_pad), .p2c(pad_sclk_p2c));
  sg13g2_IOPadIn pad_mosi(.pad(pad_mosi_pad), .p2c(pad_mosi_p2c));
  sg13g2_IOPadOut16mA pad_miso(.pad(pad_miso_pad), .c2p(pad_miso_c2p));
  sg13g2_IOPadVss pad_vss_north_0();
  sg13g2_IOPadVdd pad_vdd_north_0();
  sg13g2_IOPadIOVdd pad_vddpst_north_0();
  sg13g2_IOPadIn pad_cs(.pad(pad_cs_pad), .p2c(pad_cs_p2c));
  sg13g2_IOPadInOut16mA pad_gpio_0(.pad(pad_gpio_0_pad), .p2c(pad_gpio_0_p2c), .c2p_en(pad_gpio_0_c2p_en), .c2p(pad_gpio_0_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_10(.pad(pad_gpio_10_pad), .p2c(pad_gpio_10_p2c), .c2p_en(pad_gpio_10_c2p_en), .c2p(pad_gpio_10_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_9(.pad(pad_gpio_9_pad), .p2c(pad_gpio_9_p2c), .c2p_en(pad_gpio_9_c2p_en), .c2p(pad_gpio_9_c2p));
  sg13g2_IOPadVss pad_vss_south_0();
  sg13g2_IOPadVdd pad_vdd_south_0();
  sg13g2_IOPadIOVdd pad_vddpst_south_0();
  sg13g2_IOPadInOut16mA pad_gpio_8(.pad(pad_gpio_8_pad), .p2c(pad_gpio_8_p2c), .c2p_en(pad_gpio_8_c2p_en), .c2p(pad_gpio_8_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_7(.pad(pad_gpio_7_pad), .p2c(pad_gpio_7_p2c), .c2p_en(pad_gpio_7_c2p_en), .c2p(pad_gpio_7_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_6(.pad(pad_gpio_6_pad), .p2c(pad_gpio_6_p2c), .c2p_en(pad_gpio_6_c2p_en), .c2p(pad_gpio_6_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_11(.pad(pad_gpio_11_pad), .p2c(pad_gpio_11_p2c), .c2p_en(pad_gpio_11_c2p_en), .c2p(pad_gpio_11_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_12(.pad(pad_gpio_12_pad), .p2c(pad_gpio_12_p2c), .c2p_en(pad_gpio_12_c2p_en), .c2p(pad_gpio_12_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_13(.pad(pad_gpio_13_pad), .p2c(pad_gpio_13_p2c), .c2p_en(pad_gpio_13_c2p_en), .c2p(pad_gpio_13_c2p));
  sg13g2_IOPadVss pad_vss_west_0();
  sg13g2_IOPadVdd pad_vdd_west_0();
  sg13g2_IOPadIOVdd pad_vddpst_west_0();
  sg13g2_IOPadInOut16mA pad_gpio_14(.pad(pad_gpio_14_pad), .p2c(pad_gpio_14_p2c), .c2p_en(pad_gpio_14_c2p_en), .c2p(pad_gpio_14_c2p));
  sg13g2_IOPadIn pad_gpio_15(.pad(pad_gpio_15_pad), .p2c(pad_gpio_15_p2c));
  sg13g2_IOPadInOut16mA pad_gpio_5(.pad(pad_gpio_5_pad), .p2c(pad_gpio_5_p2c), .c2p_en(pad_gpio_5_c2p_en), .c2p(pad_gpio_5_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_4(.pad(pad_gpio_4_pad), .p2c(pad_gpio_4_p2c), .c2p_en(pad_gpio_4_c2p_en), .c2p(pad_gpio_4_c2p));
  sg13g2_IOPadVss pad_vss_east_0();
  sg13g2_IOPadVdd pad_vdd_east_0();
  sg13g2_IOPadIOVdd pad_vddpst_east_0();
  sg13g2_IOPadInOut16mA pad_gpio_3(.pad(pad_gpio_3_pad), .p2c(pad_gpio_3_p2c), .c2p_en(pad_gpio_3_c2p_en), .c2p(pad_gpio_3_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_2(.pad(pad_gpio_2_pad), .p2c(pad_gpio_2_p2c), .c2p_en(pad_gpio_2_c2p_en), .c2p(pad_gpio_2_c2p));
  sg13g2_IOPadInOut16mA pad_gpio_1(.pad(pad_gpio_1_pad), .p2c(pad_gpio_1_p2c), .c2p_en(pad_gpio_1_c2p_en), .c2p(pad_gpio_1_c2p));
  SPI spiimpl();
endmodule
