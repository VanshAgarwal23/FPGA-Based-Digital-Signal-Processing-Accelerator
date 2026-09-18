## =========================================================
## FPGA DSP ACCELERATOR - BASYS 3 CONSTRAINTS
## Device: xc7a35tcpg236-1
## =========================================================

## ---------------------------------------------------------
## 100 MHz CLOCK
## ---------------------------------------------------------

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -add -name sys_clk_pin \
    -period 10.000 \
    -waveform {0 5} \
    [get_ports clk]


## ---------------------------------------------------------
## INPUT DATA [15:0] -> BASYS 3 SWITCHES
## ---------------------------------------------------------

set_property PACKAGE_PIN V17 [get_ports {input_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[0]}]

set_property PACKAGE_PIN V16 [get_ports {input_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[1]}]

set_property PACKAGE_PIN W16 [get_ports {input_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[2]}]

set_property PACKAGE_PIN W17 [get_ports {input_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[3]}]

set_property PACKAGE_PIN W15 [get_ports {input_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[4]}]

set_property PACKAGE_PIN V15 [get_ports {input_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[5]}]

set_property PACKAGE_PIN W14 [get_ports {input_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[6]}]

set_property PACKAGE_PIN W13 [get_ports {input_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[7]}]

set_property PACKAGE_PIN V2 [get_ports {input_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[8]}]

set_property PACKAGE_PIN T3 [get_ports {input_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[9]}]

set_property PACKAGE_PIN T2 [get_ports {input_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[10]}]

set_property PACKAGE_PIN R3 [get_ports {input_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[11]}]

set_property PACKAGE_PIN W2 [get_ports {input_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[12]}]

set_property PACKAGE_PIN U1 [get_ports {input_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[13]}]

set_property PACKAGE_PIN T1 [get_ports {input_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[14]}]

set_property PACKAGE_PIN R2 [get_ports {input_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_data[15]}]


## ---------------------------------------------------------
## OUTPUT DATA [15:0] -> BASYS 3 LEDs
## ---------------------------------------------------------

set_property PACKAGE_PIN U16 [get_ports {output_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[0]}]

set_property PACKAGE_PIN E19 [get_ports {output_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[1]}]

set_property PACKAGE_PIN U19 [get_ports {output_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[2]}]

set_property PACKAGE_PIN V19 [get_ports {output_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[3]}]

set_property PACKAGE_PIN W18 [get_ports {output_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[4]}]

set_property PACKAGE_PIN U15 [get_ports {output_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[5]}]

set_property PACKAGE_PIN U14 [get_ports {output_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[6]}]

set_property PACKAGE_PIN V14 [get_ports {output_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[7]}]

set_property PACKAGE_PIN V13 [get_ports {output_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[8]}]

set_property PACKAGE_PIN V3 [get_ports {output_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[9]}]

set_property PACKAGE_PIN W3 [get_ports {output_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[10]}]

set_property PACKAGE_PIN U3 [get_ports {output_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[11]}]

set_property PACKAGE_PIN P3 [get_ports {output_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[12]}]

set_property PACKAGE_PIN N3 [get_ports {output_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[13]}]

set_property PACKAGE_PIN P1 [get_ports {output_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[14]}]

set_property PACKAGE_PIN L1 [get_ports {output_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_data[15]}]


## ---------------------------------------------------------
## RESET -> CENTER BUTTON
## ---------------------------------------------------------

set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]


## ---------------------------------------------------------
## INPUT VALID -> UP BUTTON
## ---------------------------------------------------------

set_property PACKAGE_PIN T18 [get_ports input_valid]
set_property IOSTANDARD LVCMOS33 [get_ports input_valid]


## ---------------------------------------------------------
## OUTPUT VALID -> RIGHT BUTTON PIN
## ---------------------------------------------------------

set_property PACKAGE_PIN T17 [get_ports output_valid]
set_property IOSTANDARD LVCMOS33 [get_ports output_valid]