* SARADC testbench

.TEMP 25
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2
+    PROBE

* Include the models
* TODO: make it depending on PDK_ROOT
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib mos_tt
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerMOShv.lib mos_tt
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerCAP.lib cap_typ
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerRES.lib res_typ
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerHBT.lib hbt_typ
.include /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/diodes.lib

* SARADC cells
.inc ../cells/sg13g2f.ckt
.inc ../cells/SARADC_CELL_INVX0_ASSW.ckt
.inc ../cells/SARADC_CELL_INVX16_ASCAP.ckt
.inc ../cells/SARADC_FILL1_NOPOWER.cdl
.inc ../cells/SARADC_FILL1.cdl
.inc ../cells/SARADC_FILLTIE2.cdl

* Include the actual netlist
* NOTE: Relative to this file
.inc ../pnr/outputs/SARADC.cdl

.inc saradc_tb_body.sp

* The actual implementation
xtest vdd clk go result[0] result[1] result[2] result[3]
+ result[4] rst sample valid dvdd vin vip vrefh vrefl gnd SARADC

.PROBE
+    V(xtest.analog/VOUTL)
+    V(xtest.analog/VOUTH)
+    V(xtest.analog/CCMP)
+    V(xtest.analog/CCMPB)
+    V(xtest.analog/UNCONNECTED)
+    V(xtest.CMPO)

.control
  run
  save all
  wrdata saradc_tb.csv V(vin) V(vip) V(result[0]) V(result[1]) V(result[2]) V(result[3]) V(result[4]) V(go) V(sample) V(valid) V(vout)
  quit
.endc

.end
