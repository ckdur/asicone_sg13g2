.PARAM N=128
.PARAM NBITS=5
.PARAM k=((N/2)-1)
.PARAM vid=0.3
.PARAM fclk=100000000
.PARAM fin=(fclk / 10 * k / N)
.PARAM supply=1.8
.PARAM trise=4e-10
.PARAM tfall=4e-10

.PARAM tclk=(1/fclk)
.PARAM vrefhval=(supply*0.9/1.2)
.PARAM vreflval=(supply*0.3/1.2)
.PARAM tcv=(tclk*(NBITS+1))
.PARAM startFFT=tcv
.PARAM stopFFT=(startFFT + (tcv*N))
.PARAM stopsim=(stopFFT+1e-7)

* The digital load in C and R
*.PARAM Rdigload 50 * NOTE: TOO LOW! Will be connected to an IO regardless
*.PARAM Cdigload=2e-12 * NOTE: TOO HIGH! Will be connected to an IO regardless
.PARAM Rdigload=1M
.PARAM Cdigload=2e-15

* Implementation of the dac R2R for back conversion
* NOTE: Is done up to 8 bits to cover all cases
.include dac_r2r_ideal.sp
*.SUBCKT sg13g2f_DFQD1 cp d q vdd vss
*.SUBCKT sg13g2f_MUX2D1 i0 i1 s vdd vss z
*.SUBCKT sg13g2f_INVD1 i z vss vdd
*.SUBCKT sg13g2f_BUFFD1 i vdd vss z

Xneg0 valid vdd gnd validn sg13g2f_BUFFD1 
Xclkn clk clkn gnd vdd sg13g2f_INVD1 
Xcap0 clkn resultd[0] resultq_0 vdd gnd sg13g2f_DFQD1
Xcape0 resultq_0 result_0 validn vdd gnd resultd[0] sg13g2f_MUX2D1
Xcap1 clkn resultd[1] resultq_1 vdd gnd sg13g2f_DFQD1
Xcape1 resultq_1 result_1 validn vdd gnd resultd[1] sg13g2f_MUX2D1
Xcap2 clkn resultd[2] resultq_2 vdd gnd sg13g2f_DFQD1
Xcape2 resultq_2 result_2 validn vdd gnd resultd[2] sg13g2f_MUX2D1
Xcap3 clkn resultd[3] resultq_3 vdd gnd sg13g2f_DFQD1
Xcape3 resultq_3 result_3 validn vdd gnd resultd[3] sg13g2f_MUX2D1
Xcap4 clkn resultd[4] resultq_4 vdd gnd sg13g2f_DFQD1
Xcape4 resultq_4 result_4 validn vdd gnd resultd[4] sg13g2f_MUX2D1
Xcap5 clkn resultd[5] resultq_5 vdd gnd sg13g2f_DFQD1
Xcape5 resultq_5 result_5 validn vdd gnd resultd[5] sg13g2f_MUX2D1
Xcap6 clkn resultd[6] resultq_6 vdd gnd sg13g2f_DFQD1
Xcape6 resultq_6 result_6 validn vdd gnd resultd[6] sg13g2f_MUX2D1
Xcap7 clkn resultd[7] resultq_7 vdd gnd sg13g2f_DFQD1
Xcape7 resultq_7 result_7 validn vdd gnd resultd[7] sg13g2f_MUX2D1

xi1 resultq_7 resultq_6 resultq_5 resultq_4 resultq_3 resultq_2 resultq_1 resultq_0 vout dac_ideal vth=600e-3

* Sources
vvddesd vddesd gnd DC 1.8
vvddio vddio gnd DC 1.8
vgndio gndio gnd DC 0
vvdd vdd gnd DC 1.8
vdvdd dvdd gnd DC 1.8
vgnd gnd 0 DC 0
.global gnd

* Digital
vgor gor gnd PULSE 0 1.8 {5*tclk} {trise} {tfall} 1e-3
vclkr clkr gnd PULSE 0 1.8 0 {trise} {tfall} {0.5*tclk} {tclk}
vrstr rstr gnd PULSE 1.8 0 25e-9 {trise} {tfall} 1e-3

*vvrefl vrefl gnd DC=vreflval
*vvrefh vrefh gnd DC=vrefhval
vvrefl vrefl gnd DC 0.45
vvrefh vrefh gnd DC 1.35

*vvinr vindc vinr     DC 0 SIN 0 {vid} {fin} 0 0
*vvipr vipr vindc     DC 0 SIN 0 {vid} {fin} 0 0
*vvinr vindc vinr     DC 0.15
*vvipr vipr vindc     DC 0.15
vvindc vindc gnd DC 600e-3

* Loads
ccmp_begin cmp_begin gnd {Cdigload}
csample sample gnd {Cdigload}
*cvalid valid gnd {Cdigload}
*cvalidn validn gnd {Cdigload}
cr7 resultq_7 gnd {Cdigload}
cr6 resultq_6 gnd {Cdigload}
cr5 resultq_5 gnd {Cdigload}
cr4 resultq_4 gnd {Cdigload}
cr3 resultq_3 gnd {Cdigload}
cr2 resultq_2 gnd {Cdigload}
cr1 resultq_1 gnd {Cdigload}
cr0 resultq_0 gnd {Cdigload}

.ic V(result_0)=0
.ic V(result_1)=0
.ic V(result_2)=0
.ic V(result_3)=0
.ic V(result_4)=0
.ic V(result_5)=0
.ic V(result_6)=0
.ic V(result_7)=0

.ic V(resultq_0)=0
.ic V(resultq_1)=0
.ic V(resultq_2)=0
.ic V(resultq_3)=0
.ic V(resultq_4)=0
.ic V(resultq_5)=0
.ic V(resultq_6)=0
.ic V(resultq_7)=0

.ic V(valid)=0
.ic V(validn)=0
.ic V(sample)=0

* NOTE: It worked without putting a resistor. Maybe 100M is better?
*rcmp_begin cmp_begin gnd {Rdigload}
*rsample sample gnd {Rdigload}
*rvalid valid gnd {Rdigload}
rclk clk clkr {Rdigload}
rgo go gor {Rdigload}
rrst rst rstr {Rdigload}
rvip vip vipr 50
rvin vin vinr 50

.TRAN 1u {stopsim} uic
