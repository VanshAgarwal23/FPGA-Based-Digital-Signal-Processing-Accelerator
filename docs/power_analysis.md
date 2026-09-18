# Power Analysis

## 1. Overview

Power analysis was performed as part of the FPGA implementation flow using AMD/Xilinx Vivado 2026.1.

The purpose of power analysis is to estimate the power consumption of the implemented DSP Accelerator and to understand the contribution of static and dynamic power.

The analysis is based on the implemented FPGA design and Vivado's power estimation methodology.

---

## 2. Power Components

FPGA power consumption can be broadly divided into two major components:

### Static Power

Static power is the power consumed by the FPGA device when the design is not actively switching.

It is influenced by factors such as:

- FPGA device characteristics
- Device temperature
- Process characteristics
- Voltage conditions
- Leakage current

### Dynamic Power

Dynamic power is associated with switching activity within the implemented design.

It is influenced by:

- Clock activity
- Logic switching
- DSP activity
- Signal transitions
- Data activity
- Operating frequency

The total estimated power is composed of static and dynamic contributions.

---

## 3. Power Analysis Flow

The power analysis follows the implementation flow:

```text
RTL Design
    |
    v
Synthesis
    |
    v
Placement
    |
    v
Routing
    |
    v
Switching Activity
    |
    v
Vivado Power Analysis

The implemented design is used for the final power estimation.

## Target Device
Parameter	Value
FPGA Family	Artix-7
Device	xc7a35tcpg236-1
Tool	AMD/Xilinx Vivado 2026.1
Clock Frequency	100 MHz
Clock Period	10 ns
## Power Report

The detailed Vivado power analysis is stored in:

reports/updated_basys3/power_report.rpt

This report is the authoritative source for the final estimated power values.

The report should be used to obtain the exact:

Total power
Dynamic power
Static power
Clock power
Logic power
Signal power
DSP power

Other resource-related power contributions
## Clock Power

The DSP Accelerator operates with a 100 MHz system clock.

Clock networks consume dynamic power because clock signals switch continuously during operation.

The clock contribution depends on:

Clock frequency
Clock network resources
Number of sequential elements
Clock enable activity
Device characteristics

The exact clock power contribution is available in the Vivado power report.

## Logic Switching Power

LUTs and other logic resources consume dynamic power when their signals transition between logic states.

The switching activity depends on the input data and control signals applied to the accelerator.

The FIR processing architecture contains arithmetic and control logic that contributes to dynamic switching activity.

## DSP Power

The accelerator uses FPGA DSP resources for arithmetic-intensive operations.

DSP blocks consume dynamic power when their inputs and internal signals switch.

The power contribution of the DSP resources depends on:

DSP utilization
Input data activity
Clock frequency
Internal DSP configuration
Pipeline configuration

The exact DSP-related power contribution is reported by Vivado.

## Power Estimation and Simulation Activity

Power estimation can be influenced by the switching activity provided to Vivado.

For a more application-specific estimate, representative switching activity from functional simulation can be used where supported by the Vivado power-analysis flow.

The simulation testbench contains a broad range of input conditions, including random data and saturation-related cases.

Therefore, the switching activity of the design can vary depending on the stimulus applied during simulation.

## Power Optimization Opportunities

Potential future techniques for reducing dynamic power include:

Clock gating
Clock-enable based operation
Operand isolation
Reducing unnecessary switching
DSP pipeline optimization
Reducing unnecessary data movement
Optimizing arithmetic widths where mathematically appropriate

Any power optimization should be evaluated together with timing, area, latency, and functional requirements.

## Relationship Between Power and Performance

Power consumption and performance are related to several implementation parameters.

Increasing the clock frequency generally increases switching activity and can increase dynamic power.

Adding pipeline registers may improve timing performance but can also introduce additional clocked resources and switching activity.

Therefore, architectural optimization should consider the combined effects on:

Power
Performance
Area
Latency
Resource utilization
## Hardware Validation

The power values documented in the Vivado power report are implementation-based estimates.

A physical FPGA development board was not connected during the final workflow.

Therefore, no external power-meter measurement or board-level power measurement is claimed.

Actual hardware power can differ from the Vivado estimate because of:

Actual switching activity
Device temperature
Board power circuitry
I/O loading
Clock behavior
Environmental conditions
Workload characteristics
## Power Report Location

The final power report is maintained in the project at:

reports/updated_basys3/power_report.rpt

This report should be referenced when recording numerical power results for the final project documentation.

## Conclusion

Power analysis was included as part of the FPGA implementation evaluation.

Vivado provides an estimate of the static and dynamic power consumption of the implemented DSP Accelerator.

The detailed numerical results are maintained in power_report.rpt.

The current project documentation treats these values as implementation estimates rather than physical measurements because the design was not tested on a connected FPGA development board.
