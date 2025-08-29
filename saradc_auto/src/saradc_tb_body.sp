.PARAM N=128
.PARAM k=((N/2)-1)
.PARAM tcv=50n
.PARAM startFFT=78n
.PARAM stopFFT=(startFFT + (tcv*N))
.PARAM stopsim=(stopFFT+1e-7)
.PARAM vrefhval=0.9
.PARAM vreflval=0.3
.PARAM vid=0.3
.PARAM fin=((2000000 * k) / N)

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

Xneg0 valid validn gnd vdd sg13g2f_INVD1 
Xclkn clk clkn gnd vdd sg13g2f_INVD1 
Xcap0 clkn resultd[0] resultq[0] vdd gnd sg13g2f_DFQD1
Xcape0 resultq[0] result[0] valid vdd gnd resultd[0] sg13g2f_MUX2D1
Xcap1 clkn resultd[1] resultq[1] vdd gnd sg13g2f_DFQD1
Xcape1 resultq[1] result[1] valid vdd gnd resultd[1] sg13g2f_MUX2D1
Xcap2 clkn resultd[2] resultq[2] vdd gnd sg13g2f_DFQD1
Xcape2 resultq[2] result[2] valid vdd gnd resultd[2] sg13g2f_MUX2D1
Xcap3 clkn resultd[3] resultq[3] vdd gnd sg13g2f_DFQD1
Xcape3 resultq[3] result[3] valid vdd gnd resultd[3] sg13g2f_MUX2D1
Xcap4 clkn resultd[4] resultq[4] vdd gnd sg13g2f_DFQD1
Xcape4 resultq[4] result[4] valid vdd gnd resultd[4] sg13g2f_MUX2D1
Xcap5 clkn resultd[5] resultq[5] vdd gnd sg13g2f_DFQD1
Xcape5 resultq[5] result[5] valid vdd gnd resultd[5] sg13g2f_MUX2D1
Xcap6 clkn resultd[6] resultq[6] vdd gnd sg13g2f_DFQD1
Xcape6 resultq[6] result[6] valid vdd gnd resultd[6] sg13g2f_MUX2D1
Xcap7 clkn resultd[7] resultq[7] vdd gnd sg13g2f_DFQD1
Xcape7 resultq[7] result[7] valid vdd gnd resultd[7] sg13g2f_MUX2D1

xi1 resultq[7] resultq[6] resultq[5] resultq[4] resultq[3] resultq[2] resultq[1] resultq[0] vout dac_ideal vth=600e-3

* Sources
vvddesd vddesd gnd DC=1.8
vvddio vddio gnd DC=1.8
vgndio gndio gnd DC=0
vvdd vdd gnd DC=1.8
vdvdd dvdd gnd DC=1.8
*vgnd gnd 0 DC=0
.global gnd

* Digital
vgor gor gnd PULSE 0 1.8 25e-9 20e-12 20e-12 1e-3
vclkr clkr gnd PULSE 0 1.8 0 10e-12 10e-12 2.5e-9 5e-9
vrstr rstr gnd PULSE 1.8 0 25e-9 20e-12 20e-12 1e-3

vvrefl vrefl gnd DC=vreflval
vvrefh vrefh gnd DC=vrefhval

vvinr vindc vinr     DC=0 SIN 0 vid fin 0 0
vvipr vipr vindc     DC=0 SIN 0 vid fin 0 0
*vvinr vindc vinr     DC 0.15
*vvipr vipr vindc     DC 0.15
vvindc vindc gnd DC=600e-3

* Loads
ccmp_begin cmp_begin gnd {Cdigload}
csample sample gnd {Cdigload}
cvalid validn gnd {Cdigload}
cr7 resultq[7] gnd {Cdigload}
cr6 resultq[6] gnd {Cdigload}
cr5 resultq[5] gnd {Cdigload}
cr4 resultq[4] gnd {Cdigload}
cr3 resultq[3] gnd {Cdigload}
cr2 resultq[2] gnd {Cdigload}
cr1 resultq[1] gnd {Cdigload}
cr0 resultq[0] gnd {Cdigload}

.nodeset V(result[0])=0
.nodeset V(result[1])=0
.nodeset V(result[2])=0
.nodeset V(result[3])=0
.nodeset V(result[4])=0
.nodeset V(result[5])=0
.nodeset V(result[6])=0
.nodeset V(result[7])=0

.nodeset V(resultq[0])=0
.nodeset V(resultq[1])=0
.nodeset V(resultq[2])=0
.nodeset V(resultq[3])=0
.nodeset V(resultq[4])=0
.nodeset V(resultq[5])=0
.nodeset V(resultq[6])=0
.nodeset V(resultq[7])=0

* NOTE: It worked without putting a resistor. Maybe 100M is better?
*rcmp_begin cmp_begin gnd {Rdigload}
*rsample sample gnd {Rdigload}
*rvalid valid gnd {Rdigload}
rclk clk clkr {Rdigload}
rgo go gor {Rdigload}
rrst rst rstr {Rdigload}
rvip vip vipr 50
rvin vin vinr 50

.PROBE
+    V(result[0])
+    V(result[1])
+    V(result[2])
+    V(result[3])
+    V(result[4])
+    V(result[5])
+    V(result[6])
+    V(result[7])
+    V(resultq[0])
+    V(resultq[1])
+    V(resultq[2])
+    V(resultq[3])
+    V(resultq[4])
+    V(resultq[5])
+    V(resultq[6])
+    V(resultq[7])
+    V(clk)
+    V(clkn)
+    V(vin)
+    V(vip)
+    V(vrefh)
+    V(vrefl)
+    V(go)
+    V(sample)
+    V(valid)
+    V(validn)
+    V(cmp_begin)
+    V(vout)

.TRAN 1u {stopsim}
