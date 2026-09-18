# DSP Accelerator Architecture

## 1. Overview

The FPGA DSP Accelerator is a hardware implementation of a finite impulse response (FIR) digital signal-processing operation. The design accepts signed 16-bit input samples and produces signed 16-bit filtered output samples.

The accelerator is designed for FPGA implementation using Xilinx Vivado and targets the AMD/Xilinx Artix-7 `xc7a35tcpg236-1` device.

The design supports:

- Signed 16-bit input and output data
- FIR-based multiply-accumulate processing
- 16 coefficient/sample positions
- Fixed-point Q1.15 arithmetic
- Output saturation to the signed 16-bit range
- Input-valid control
- Output-valid indication
- Synchronous reset
- DSP-oriented FPGA implementation

---

## 2. Top-Level Module

The top-level design module is:

`dsp_accelerator_top`

The major functional blocks are:

```text
                 +----------------------+
 input_data ---->|                      |
 input_valid --->|  Input / Control     |
 reset --------->|                      |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Sample History       |
                 | / Delay Elements     |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Parallel Multiply    |
                 | Operations           |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Accumulation         |
                 | / FIR Processing     |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Fixed-Point Scaling  |
                 | and Saturation       |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Output Register /    |
                 | Valid Control        |
                 +----------+-----------+
                            |
                            v
                       output_data

                       output_valid


| Signal         | Direction | Width | Description                     |
| -------------- | --------- | ----: | ------------------------------- |
| `clk`          | Input     |     1 | System clock                    |
| `reset`        | Input     |     1 | Synchronous reset               |
| `input_valid`  | Input     |     1 | Indicates a valid input sample  |
| `input_data`   | Input     |    16 | Signed input sample             |
| `output_valid` | Output    |     1 | Indicates a valid output sample |
| `output_data`  | Output    |    16 | Signed filtered output          |

FIR Processing

The core operation follows the FIR equation:

y[n] = Σ x[n-k]h[k]

where:

x[n] is the current input sample
x[n-k] represents previous input samples
h[k] represents the filter coefficients
y[n] is the calculated output

The design maintains a history of input samples and combines the samples with the corresponding filter coefficients.

The implementation contains 16 coefficient/sample positions.



Fixed-Point Arithmetic

The design uses fixed-point arithmetic with Q1.15 scaling.

The multiplication of two fixed-point values produces a wider intermediate result. The accumulated result is subsequently scaled back to the required output representation.

The reference verification model applies an arithmetic right shift of 15 bits:

scaled_result = accumulated_result >>> 15

This preserves the intended Q1.15 fixed-point representation.



Output Saturation

After fixed-point scaling, the calculated result is limited to the signed 16-bit range.

The signed 16-bit output range is:

-32768 to +32767

If the calculated result exceeds the positive limit, it is limited to 32767.

If the calculated result falls below the negative limit, it is limited to -32768.

This prevents arithmetic overflow from wrapping the result around to an incorrect signed value.



Input Valid Control

input_valid controls when an input sample is accepted by the processing pipeline.

When input_valid is asserted:

The input sample is accepted.
The sample history is updated.
FIR processing is performed.
The corresponding output becomes valid according to the design's processing latency.

When input_valid is not asserted, the design does not treat the input as a valid new sample.

The verification environment includes tests for invalid input-valid gaps.







Reset Operation

The design includes a reset input used to initialize the processing state.

Reset clears the internal sample history and establishes a known starting state.

This is particularly important for FIR processing because previous samples affect subsequent outputs.

The verification environment applies reset before independent test groups to ensure that each test begins with a known filter state.




FPGA Implementation
Target Device
Device: xc7a35tcpg236-1
Family: Artix-7
Clock
Clock frequency: 100 MHz
Clock period:    10 ns

The supplied constraints define the clock using:

create_clock -period 10.000 -waveform {0 5}
Board Interface

A Basys 3-style XDC constraint file is used for the external interface signals.

The constraints define FPGA package pins and LVCMOS33 I/O standards for the design interface.




DSP Hardware Utilization

The design is mapped to FPGA DSP resources for the arithmetic-intensive multiplication operations.

Vivado implementation identifies DSP-based multiplication structures in the design. LUT-based logic is also used for supporting control and arithmetic operations.

The exact final utilization figures are documented separately in:

reports/updated_basys3/implementation_utilization.rpt





Processing Flow

The overall processing sequence is:

Input Sample
     |
     v
input_valid
     |
     v
Sample History Update
     |
     v
Multiply Samples by Coefficients
     |
     v
Accumulate Products
     |
     v
Q1.15 Scaling
     |
     v
16-bit Saturation
     |
     v
Output Register
     |
     v
output_valid




Verification Status

The final functional simulation contains:

Total Tests : 1108
Passed      : 1108
Failed      : 0

The verification suite covers:

Normal operation
Signed input values
Invalid input_valid gaps
Long random input streams
Random small values
Saturation conditions
Zero after large values
Sign-transition conditions

The final simulation result was:

*** ALL TESTS PASSED ***



Implementation Status

The design successfully completed:

RTL design
Functional simulation
Synthesis
Implementation
Routing
Design Rule Check
Bitstream generation

The generated bitstream is located at:

bitstream/dsp_accelerator_top.bit

The final DRC reports the design state as:

Fully Routed


 Hardware Validation

Physical FPGA-board validation has not been performed because a physical FPGA development board was not connected to the Vivado Hardware Manager during the final project workflow.

Therefore, the documented functional results are based on RTL simulation and Vivado implementation results.

No hardware performance measurements are claimed.



 Summary

The DSP Accelerator implements a 16-position FIR-style fixed-point processing architecture targeting an Artix-7 FPGA.

The design combines:

Sample-history storage
DSP-oriented multiplication
Accumulation
Q1.15 fixed-point scaling
Signed output saturation
Valid-data control
Reset initialization

The final RTL verification achieved 1108/1108 passing tests, and the design successfully completed FPGA synthesis, implementation, routing, DRC, and bitstream generation.
