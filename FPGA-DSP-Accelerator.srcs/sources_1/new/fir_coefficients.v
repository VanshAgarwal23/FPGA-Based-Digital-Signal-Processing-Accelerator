`timescale 1ns / 1ps

module fir_coefficients #(
    parameter COEFF_WIDTH = 16
)(
    output wire signed [COEFF_WIDTH-1:0] coeff_0,
    output wire signed [COEFF_WIDTH-1:0] coeff_1,
    output wire signed [COEFF_WIDTH-1:0] coeff_2,
    output wire signed [COEFF_WIDTH-1:0] coeff_3,
    output wire signed [COEFF_WIDTH-1:0] coeff_4,
    output wire signed [COEFF_WIDTH-1:0] coeff_5,
    output wire signed [COEFF_WIDTH-1:0] coeff_6,
    output wire signed [COEFF_WIDTH-1:0] coeff_7,
    output wire signed [COEFF_WIDTH-1:0] coeff_8,
    output wire signed [COEFF_WIDTH-1:0] coeff_9,
    output wire signed [COEFF_WIDTH-1:0] coeff_10,
    output wire signed [COEFF_WIDTH-1:0] coeff_11,
    output wire signed [COEFF_WIDTH-1:0] coeff_12,
    output wire signed [COEFF_WIDTH-1:0] coeff_13,
    output wire signed [COEFF_WIDTH-1:0] coeff_14,
    output wire signed [COEFF_WIDTH-1:0] coeff_15
);

    /*
     * 16-Tap Low-Pass FIR Filter
     *
     * Coefficients are represented in Q1.15 format.
     *
     * Floating-point approximation:
     *
     * [-0.010, -0.015, -0.020, 0.000,
     *   0.040,  0.110,  0.180, 0.215,
     *   0.215,  0.180,  0.110, 0.040,
     *   0.000, -0.020, -0.015, -0.010]
     *
     * Integer Q1.15 representation:
     *
     * [-328, -492, -655, 0,
     *   1311, 3604, 5898, 7045,
     *   7045, 5898, 3604, 1311,
     *   0, -655, -492, -328]
     */

    assign coeff_0  = -16'sd328;
    assign coeff_1  = -16'sd492;
    assign coeff_2  = -16'sd655;
    assign coeff_3  =  16'sd0;
    assign coeff_4  =  16'sd1311;
    assign coeff_5  =  16'sd3604;
    assign coeff_6  =  16'sd5898;
    assign coeff_7  =  16'sd7045;

    assign coeff_8  =  16'sd7045;
    assign coeff_9  =  16'sd5898;
    assign coeff_10 =  16'sd3604;
    assign coeff_11 =  16'sd1311;
    assign coeff_12 =  16'sd0;
    assign coeff_13 = -16'sd655;
    assign coeff_14 = -16'sd492;
    assign coeff_15 = -16'sd328;

endmodule