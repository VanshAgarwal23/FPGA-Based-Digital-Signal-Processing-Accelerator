`timescale 1ns / 1ps

module dsp_accelerator_top #(
    parameter DATA_WIDTH  = 16,
    parameter COEFF_WIDTH = 16
)(
    input  wire                         clk,
    input  wire                         reset,

    input  wire                         input_valid,
    input  wire signed [DATA_WIDTH-1:0] input_data,

    output wire                         output_valid,
    output wire signed [DATA_WIDTH-1:0] output_data
);

    /*
     * =========================================================
     * SAMPLE BUFFER SIGNALS
     * =========================================================
     */

    wire signed [DATA_WIDTH-1:0] sample_0;
    wire signed [DATA_WIDTH-1:0] sample_1;
    wire signed [DATA_WIDTH-1:0] sample_2;
    wire signed [DATA_WIDTH-1:0] sample_3;
    wire signed [DATA_WIDTH-1:0] sample_4;
    wire signed [DATA_WIDTH-1:0] sample_5;
    wire signed [DATA_WIDTH-1:0] sample_6;
    wire signed [DATA_WIDTH-1:0] sample_7;
    wire signed [DATA_WIDTH-1:0] sample_8;
    wire signed [DATA_WIDTH-1:0] sample_9;
    wire signed [DATA_WIDTH-1:0] sample_10;
    wire signed [DATA_WIDTH-1:0] sample_11;
    wire signed [DATA_WIDTH-1:0] sample_12;
    wire signed [DATA_WIDTH-1:0] sample_13;
    wire signed [DATA_WIDTH-1:0] sample_14;
    wire signed [DATA_WIDTH-1:0] sample_15;


    /*
     * =========================================================
     * COEFFICIENT SIGNALS
     * =========================================================
     */

    wire signed [COEFF_WIDTH-1:0] coeff_0;
    wire signed [COEFF_WIDTH-1:0] coeff_1;
    wire signed [COEFF_WIDTH-1:0] coeff_2;
    wire signed [COEFF_WIDTH-1:0] coeff_3;
    wire signed [COEFF_WIDTH-1:0] coeff_4;
    wire signed [COEFF_WIDTH-1:0] coeff_5;
    wire signed [COEFF_WIDTH-1:0] coeff_6;
    wire signed [COEFF_WIDTH-1:0] coeff_7;
    wire signed [COEFF_WIDTH-1:0] coeff_8;
    wire signed [COEFF_WIDTH-1:0] coeff_9;
    wire signed [COEFF_WIDTH-1:0] coeff_10;
    wire signed [COEFF_WIDTH-1:0] coeff_11;
    wire signed [COEFF_WIDTH-1:0] coeff_12;
    wire signed [COEFF_WIDTH-1:0] coeff_13;
    wire signed [COEFF_WIDTH-1:0] coeff_14;
    wire signed [COEFF_WIDTH-1:0] coeff_15;


    /*
     * =========================================================
     * FIR OUTPUT
     * =========================================================
     */

    wire signed [DATA_WIDTH-1:0] fir_output;


    /*
     * =========================================================
     * SAMPLE BUFFER INSTANCE
     * =========================================================
     */

    fir_sample_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_TAPS(16)
    )
    u_sample_buffer (
        .clk(clk),
        .reset(reset),
        .sample_valid(input_valid),
        .sample_in(input_data),

        .sample_0(sample_0),
        .sample_1(sample_1),
        .sample_2(sample_2),
        .sample_3(sample_3),
        .sample_4(sample_4),
        .sample_5(sample_5),
        .sample_6(sample_6),
        .sample_7(sample_7),
        .sample_8(sample_8),
        .sample_9(sample_9),
        .sample_10(sample_10),
        .sample_11(sample_11),
        .sample_12(sample_12),
        .sample_13(sample_13),
        .sample_14(sample_14),
        .sample_15(sample_15)
    );


    /*
     * =========================================================
     * COEFFICIENT INSTANCE
     * =========================================================
     */

    fir_coefficients #(
        .COEFF_WIDTH(COEFF_WIDTH)
    )
    u_coefficients (
        .coeff_0(coeff_0),
        .coeff_1(coeff_1),
        .coeff_2(coeff_2),
        .coeff_3(coeff_3),
        .coeff_4(coeff_4),
        .coeff_5(coeff_5),
        .coeff_6(coeff_6),
        .coeff_7(coeff_7),
        .coeff_8(coeff_8),
        .coeff_9(coeff_9),
        .coeff_10(coeff_10),
        .coeff_11(coeff_11),
        .coeff_12(coeff_12),
        .coeff_13(coeff_13),
        .coeff_14(coeff_14),
        .coeff_15(coeff_15)
    );


    /*
     * =========================================================
     * FIR FILTER INSTANCE
     * =========================================================
     */

    fir_filter #(
        .DATA_WIDTH(DATA_WIDTH),
        .COEFF_WIDTH(COEFF_WIDTH),
        .PRODUCT_WIDTH(32),
        .ACC_WIDTH(40)
    )
    u_fir_filter (
        .sample_0(sample_0),
        .sample_1(sample_1),
        .sample_2(sample_2),
        .sample_3(sample_3),
        .sample_4(sample_4),
        .sample_5(sample_5),
        .sample_6(sample_6),
        .sample_7(sample_7),
        .sample_8(sample_8),
        .sample_9(sample_9),
        .sample_10(sample_10),
        .sample_11(sample_11),
        .sample_12(sample_12),
        .sample_13(sample_13),
        .sample_14(sample_14),
        .sample_15(sample_15),

        .coeff_0(coeff_0),
        .coeff_1(coeff_1),
        .coeff_2(coeff_2),
        .coeff_3(coeff_3),
        .coeff_4(coeff_4),
        .coeff_5(coeff_5),
        .coeff_6(coeff_6),
        .coeff_7(coeff_7),
        .coeff_8(coeff_8),
        .coeff_9(coeff_9),
        .coeff_10(coeff_10),
        .coeff_11(coeff_11),
        .coeff_12(coeff_12),
        .coeff_13(coeff_13),
        .coeff_14(coeff_14),
        .coeff_15(coeff_15),

        .filter_out(fir_output)
    );


    /*
     * =========================================================
     * OUTPUT CONNECTION
     * =========================================================
     */

    assign output_data = fir_output;

    /*
     * The baseline FIR is combinational after the sample
     * buffer. Therefore output_valid is aligned with the
     * newly accepted sample after the sample-buffer clock.
     */

    assign output_valid = input_valid;

endmodule 