# Usage: gnuplot -c plot.vin_vout.gnu input.csv output.pdf "My Title"

# Get command-line arguments
csvfile = ARG1      # first argument: input CSV
pdffile = ARG2      # second argument: output PDF
plottitle = ARG3    # third argument: figure title

set terminal pdfcairo size 6,8 enhanced font 'Helvetica,10'
set output pdffile

set multiplot layout 2,1 title "Vin and Vout" font ",12"

# --- First subplot: Vin ---
set xlabel "time (s)"
set ylabel "Vin (V)"
plot csvfile using 1:2 with lines lw 2 title 'Vin'

# --- Second subplot: Vout ---
set xlabel "time (s)"
set ylabel "Vout (V)"
plot csvfile using 21:22 with lines lw 2 title 'Vout'

unset multiplot
