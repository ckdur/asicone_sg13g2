#!/bin/bash
# Reads back the chip SPI as taped out and with the one-line fix (RDA[addr] -> RDA[raddr]).
# Needs iverilog (e.g. /opt/ext/OpenLane/bin).
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
SPI=$HERE/../../digital/rtl/spix/spi.v
OUT=$(mktemp -d)
sed 's/assign bus_rd = RDA\[addr\];/assign bus_rd = RDA[raddr];/' "$SPI" > "$OUT/spi_fix.v"
echo "== as taped out";     iverilog -o "$OUT/a" "$HERE/spi_read_tb.v" "$SPI"          && vvp -n "$OUT/a"
echo "== with RDA[raddr]";  iverilog -o "$OUT/b" "$HERE/spi_read_tb.v" "$OUT/spi_fix.v" && vvp -n "$OUT/b"
rm -rf "$OUT"
