<!-- Generated from report.tex by make_md.py; edit the LaTeX and re-run. -->

[Contents](README.md) · Previous: [3 Block design](03-block-design.md) · Next: [5 Measurement environment](05-measurement-environment.md)

# 4 Design flow and tapeout sequence

## 4.1 Flow

The flow is custom (no OpenROAD-flow-scripts), organized per block as `syn` (Yosys) → `pnr` (OpenROAD) → `signoff` (KLayout GDS merge, fill, DRC, LVS), and at the top as `padring` (the `padring` tool, `.cfg` with corners, pads, bond pads and fillers) → `pnr` (macro placement, power grid, routing) → `signoff`. Versions used for the final sign-off:

<div class="center">

|  |  |
|:---|:---|
| IHP-Open-PDK | `6bda9f1cd9ae7108571041d9bd0f03a5a94f731f` |
| OpenROAD | `59ef9a94573c0a6799d32e2dfc9fc7a93feeb30f` |
| Yosys | `4581f75b03a25b615a9715516854c424b580f7ab` (0.49 for the SPI netlist) |
| KLayout | 0.30.2 (`d1dc885235bf571eac7270d6dccca820a019b4b1`) |
| ngspice | 44.2 |
| OpenVAF-Reloaded | `802bce21ac44833b52c010cb90d37e0d6fddd4ac` |

</div>

## 4.2 Timeline

Reconstructed from the commit history of `asicone_sg13g2`, of the submission fork `TO_Sep2025` and of the sign-off logs (all times JST).

<table style="width:94%;">
<colgroup>
<col style="width: 15%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Date</th>
<th style="text-align: left;">Step</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" style="text-align: left;"><em>Preparation (May–July 2025)</em></td>
</tr>
<tr>
<td style="text-align: left;">2025-05-12</td>
<td style="text-align: left;">First commit: digital flow for the custom cells.</td>
</tr>
<tr>
<td style="text-align: left;">05-16 – 05-19</td>
<td style="text-align: left;">First OpenROAD PnR of a digital block, up to CTS.</td>
</tr>
<tr>
<td style="text-align: left;">06-16 – 06-30</td>
<td style="text-align: left;">First full PnR and sign-off of the digital block; DRC working, LVS not yet.</td>
</tr>
<tr>
<td style="text-align: left;">07-21</td>
<td style="text-align: left;">Synthesis fixed, first LVS-clean digital block; fillers added and first pad ring generated; first top-level PnR draft.</td>
</tr>
<tr>
<td style="text-align: left;">07-23 – 07-29</td>
<td style="text-align: left;">Pad-ring configuration, first OpenROAD script for the chip; the ADC brought into the repository.</td>
</tr>
<tr>
<td colspan="2" style="text-align: left;"><em>ADC physical design (August 2025)</em></td>
</tr>
<tr>
<td style="text-align: left;">08-05 – 08-08</td>
<td style="text-align: left;">First synthesis of the ADC, placement, blockages; first ADC with all routes but no connections.</td>
</tr>
<tr>
<td style="text-align: left;">08-12</td>
<td style="text-align: left;">IHP opens the <code>TO_Sep2025</code> repository (rules: 2 mm<sup>2</sup> including seal ring, registration 1 September, DRC-clean GDS by 14 September, no changes afterwards).</td>
</tr>
<tr>
<td style="text-align: left;">08-14</td>
<td style="text-align: left;">Via generation for the custom routes.</td>
</tr>
<tr>
<td style="text-align: left;">08-17 – 08-19</td>
<td style="text-align: left;">Joining of the ADC routes, power stripes, first placement and CTS of the chip.</td>
</tr>
<tr>
<td style="text-align: left;">08-20</td>
<td style="text-align: left;">First complete PnR; final pad-ring and seal-ring size; bond pads. Placeholder submitted to <code>TO_Sep2025</code>.</td>
</tr>
<tr>
<td style="text-align: left;">08-21 – 08-22</td>
<td style="text-align: left;">Assets reorganized, LEF fixes, comparator routes; full chip flow complete (unverified), better detailed routing.</td>
</tr>
<tr>
<td colspan="2" style="text-align: left;"><em>DRC and LVS closure (23–28 August)</em></td>
</tr>
<tr>
<td style="text-align: left;">08-23</td>
<td style="text-align: left;">DRC fixes in the metal stack and in the standard cells.</td>
</tr>
<tr>
<td style="text-align: left;">08-24</td>
<td style="text-align: left;">ADC DRC reduced from about 5000 to 20 violations, then 38 left at the top.</td>
</tr>
<tr>
<td style="text-align: left;">08-25</td>
<td style="text-align: left;">ADC DRC clean; LVS debugging, cells rejected by LVS removed.</td>
</tr>
<tr>
<td style="text-align: left;">08-26</td>
<td style="text-align: left;">LVS clean on the SARADC; libraries renamed and separated (<code>sg13g2</code>/<code>sg13g2f</code>); full chip assembled.</td>
</tr>
<tr>
<td style="text-align: left;">08-27</td>
<td style="text-align: left;">Manufacturing-grid fixes, DRC fixes, custom LVS deck support; die size corrected for the seal-ring-to-passivation rule (<code>TO_Sep2025</code>).</td>
</tr>
<tr>
<td style="text-align: left;">08-28</td>
<td style="text-align: left;">I/O cells customized for LVS (missing <code>PolyRes</code> recognition layer added); <code>ptap1</code> ignored in a custom deck; <strong>full-chip LVS pass</strong>.</td>
</tr>
<tr>
<td colspan="2" style="text-align: left;"><em>Verification and submission (29 August – 14 September)</em></td>
</tr>
<tr>
<td style="text-align: left;">08-29 – 08-31</td>
<td style="text-align: left;">ADC testbenches; submission metadata; simulation folder of the submission.</td>
</tr>
<tr>
<td style="text-align: left;">09-01</td>
<td style="text-align: left;">Registration deadline. ADC simulations ported to Xyce; SAR logic changed to flops with reset for the result.</td>
</tr>
<tr>
<td style="text-align: left;">09-02 – 09-05</td>
<td style="text-align: left;">Multi-frequency, capacitor-linearity and switch-charge simulations of the ADC.</td>
</tr>
<tr>
<td style="text-align: left;">09-09</td>
<td style="text-align: left;">Correction of the <code>sg13g2</code> library.</td>
</tr>
<tr>
<td style="text-align: left;">09-12 01:13</td>
<td style="text-align: left;">First integration of the ring oscillators into the chip.</td>
</tr>
<tr>
<td style="text-align: left;">09-12 10:18</td>
<td style="text-align: left;">First sign-off of the chip with the ROs.</td>
</tr>
<tr>
<td style="text-align: left;">09-12 21:18</td>
<td style="text-align: left;">Final sign-off runs on <code>asicone_202508.fill.gds</code>: LVS (KLayout 0.30.2, flat, custom deck) “Netlists match” at 22:53 (95 min); full DRC with antenna and density at 23:15 (117 min).</td>
</tr>
<tr>
<td style="text-align: left;">09-12 23:40</td>
<td style="text-align: left;">Final upload to <code>TO_Sep2025</code> (<code>asicone_202509</code>): GDS, DRC, LVS, simulation and digital data, metadata.</td>
</tr>
<tr>
<td style="text-align: left;">09-12 23:49</td>
<td style="text-align: left;">“Everything ready” in <code>asicone_sg13g2</code>.</td>
</tr>
<tr>
<td style="text-align: left;">09-14</td>
<td style="text-align: left;">Shuttle deadline.</td>
</tr>
<tr>
<td colspan="2" style="text-align: left;"><em>After the tapeout</em></td>
</tr>
<tr>
<td style="text-align: left;">09-15 – 10-03</td>
<td style="text-align: left;">Submodule fixes, pad-ring tool included, license and README; the ADC moved to its own repository (<code>saradc_auto</code>).</td>
</tr>
<tr>
<td style="text-align: left;">2025-12 – 2026-01</td>
<td style="text-align: left;">Repositories moved to GitLab, <code>run.sh</code> demo, fixes for newer OpenROAD.</td>
</tr>
<tr>
<td style="text-align: left;">2026-05-08</td>
<td style="text-align: left;">QFN48 bonding diagram.</td>
</tr>
<tr>
<td style="text-align: left;">2026-08-17</td>
<td style="text-align: left;">Die photograph of the packaged chip.</td>
</tr>
<tr>
<td style="text-align: left;">2026-08-28 – 09-24</td>
<td style="text-align: left;">Adapter board designed (first commit; fabrication files on 09-24) (<code>IHP130_ASICONE_ADP_QFN48_0p5Q_Adapter</code>).</td>
</tr>
<tr>
<td style="text-align: left;">2026-09-12 – 09-25</td>
<td style="text-align: left;">RISCVConsole SoC ported to the ULX3S (SD boot, extra SPIs, external 10 MHz clock).</td>
</tr>
<tr>
<td style="text-align: left;">2026-10-01 – 10-19</td>
<td style="text-align: left;">First ADC conversions on the bench, fast sampling firmware.</td>
</tr>
<tr>
<td style="text-align: left;">2026-10-22</td>
<td style="text-align: left;">ADC sweep with the MSO20 (data set <code>sweep_20261022</code>).</td>
</tr>
<tr>
<td style="text-align: left;">2026-10-24 – 10-25</td>
<td style="text-align: left;">ADC compared with schematic and post-layout simulation.</td>
</tr>
<tr>
<td style="text-align: left;">2026-10-29 – 10-30</td>
<td style="text-align: left;">Ring-oscillator measurement (<code>ro_20261029</code>) and post-layout comparison.</td>
</tr>
</tbody>
</table>

The critical path was clear: the ADC went from its first routed layout (8 August) to DRC clean (25 August) and LVS clean (26 August) in under three weeks, leaving two weeks for the full-chip verification, the simulations and the RO integration, and no time for any post-layout iteration.

## 4.3 Sign-off results and deviations

- **DRC**: the full KLayout deck (flat, antenna, density) reports 52 violations, all in the IHP I/O cells: 26 `Sdiod.d` and 26 `Sdiod.e`. They were accepted; the I/O works on silicon. All the designed blocks are DRC clean.

- **LVS**: “Netlists match” with a custom deck: `ptap1` is ignored entirely (the extractor turned substrate taps into diodes, which only match if each tap is a separate diode, and merged taps in the layout create a single diode), and a `PolyRes` layer missing in some I/O sub-cells was added so that the `rppd` resistors are recognized.

- Capacitors were attached to some transistors of the netlist for simulator convergence.

- No parasitic extraction (Section [4.4](#44-parasitic-extraction-not-available-at-tapeout)) and no timing characterization in SG13G2.

- No gate-level or RTL regression of the SPI read path: its testbench (`spi_tb.v`) still used an old port name (`DOUT`) and no longer elaborated against the taped-out `spi.v`. DRC and LVS only check that the layout implements the netlist; they cannot catch a logic error in the RTL (Section [8](08-spi-the-read-back-failure.md#8-spi-the-read-back-failure)).

## 4.4 Parasitic extraction: not available at tapeout

At tapeout the SG13G2 PDK had no parasitic-extraction rules, so neither the ADC nor the ROs could be simulated with their layout. After the measurements several routes were tried: Magic 8.3.623 (capacitances about 100× too large, and Netgen cannot compare the netlist), and KLayout-PEX [[6]](README.md#references) on the whole flat layout (single-threaded 2.5D engine; runs of 4, 12, 10 and 16 h never finished). What finally worked is a *split* extraction: the layout is cut into small windows along fillers and taps (81 for the ADC), each window is extracted with KLayout-PEX 0.3.12 (2.5D, coupling capacitances, *no resistance*) after the PDK LVS deck with its unconditional `purge` disabled, and the windows are stitched by net name. The stitched ADC netlist has the 24 198 transistors and 68 519 capacitors and matches the schematic on all 572 named nets. The RO cells were extracted the same way from the fabricated GDS. These are the post-layout results quoted in this report; they were not available when the chip was designed.

---

[Contents](README.md) · Previous: [3 Block design](03-block-design.md) · Next: [5 Measurement environment](05-measurement-environment.md)
