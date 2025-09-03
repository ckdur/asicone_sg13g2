* CAP linearity test

.options tnom=25 temp=25 gminsteps=0 warn=1 klu=1 acct=1 method=gear trtol=1

* Include the models
* TODO: make it depending on PDK_ROOT

.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/cornerMOSlv.lib mos_tt
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/cornerMOShv.lib mos_tt
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/cornerCAP.lib cap_typ
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/cornerRES.lib res_typ
.lib /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/cornerHBT.lib hbt_typ
.inc /opt/ext/OpenPDKs/IHP-Open-PDK/ihp-sg13g2/libs.tech/xyce/models/diodes.lib

.inc SARADC_CELL_INVX0_ASSW.ckt

.PARAM supply=1.8
.PARAM vi=1.2
.PARAM f=100M


* Supply
Vsupply vdd vss DC {supply}
Vgnd vss 0 DC 0

* DUT
*.SUBCKT SARADC_CELL_INVX16_ASCAP i vdd vss zn vnw vpw
xdut vplus vminus vminus vminus vdd vss SARADC_CELL_INVX16_ASCAP

* PORT definition
*Vport vplus vss DC 0 SIN 0 {vi} {f} 0 0
Vport vplus vplusp AC 1
Rport vplusp vss 50

.AC dec 100 1M 10G

.print ac format=csv file=cap_linearity.xyce.csv V(vplus) I(Vport)
