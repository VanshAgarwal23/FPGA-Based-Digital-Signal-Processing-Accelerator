`timescale 1ns / 1ps

module fir_filter #(
    parameter DATA_WIDTH   = 16,
    parameter COEFF_WIDTH  = 16,
    parameter PRODUCT_WIDTH = 32,
    parameter ACC_WIDTH    = 40
)(
    input  wire signed [DATA_WIDTH-1:0] sample_0,
    input  wire signed [DATA_WIDTH-1:0] sample_1,
    input  wire signed [DATA_WIDTH-1:0] sample_2,
    input  wire signed [DATA_WIDTH-1:0] sample_3,
    input  wire signed [DATA_WIDTH-1:0] sample_4,
    input  wire signed [DATA_WIDTH-1:0] sample_5,
    input  wire signed [DATA_WIDTH-1:0] sample_6,
    input  wire signed [DATA_WIDTH-1:0] sample_7,
    input  wire signed [DATA_WIDTH-1:0] sample_8,
    input  wire signed [DATA_WIDTH-1:0] sample_9,
    input  wire signed [DATA_WIDTH-1:0] sample_10,
    input  wire signed [DATA_WIDTH-1:0] sample_11,
    input  wire signed [DATA_WIDTH-1:0] sample_12,
    input  wire signed [DATA_WIDTH-1:0] sample_13,
    input  wire signed [DATA_WIDTH-1:0] sample_14,
    input  wire signed [DATA_WIDTH-1:0] sample_15,

    input  wire signed [COEFF_WIDTH-1:0] coeff_0,
    input  wire signed [COEFF_WIDTH-1:0] coeff_1,
    input  wire signed [COEFF_WIDTH-1:0] coeff_2,
    input  wire signed [COEFF_WIDTH-1:0] coeff_3,
    input  wire signed [COEFF_WIDTH-1:0] coeff_4,
    input  wire signed [COEFF_WIDTH-1:0] coeff_5,
    input  wire signed [COEFF_WIDTH-1:0] coeff_6,
    input  wire signed [COEFF_WIDTH-1:0] coeff_7,
    input  wire signed [COEFF_WIDTH-1:0] coeff_8,
    input  wire signed [COEFF_WIDTH-1:0] coeff_9,
    input  wire signed [COEFF_WIDTH-1:0] coeff_10,
    input  wire signed [COEFF_WIDTH-1:0] coeff_11,
    input  wire signed [COEFF_WIDTH-1:0] coeff_12,
    input  wire signed [COEFF_WIDTH-1:0] coeff_13,
    input  wire signed [COEFF_WIDTH-1:0] coeff_14,
    input  wire signed [COEFF_WIDTH-1:0] coeff_15,

    output reg signed [DATA_WIDTH-1:0] filter_out
);

    /*
     * ---------------------------------------------------------
     * 16 Parallel Multipliers
     * ---------------------------------------------------------
     *
     * 16-bit sample × 16-bit coefficient = 32-bit product
     */

    wire signed [PRODUCT_WIDTH-1:0] product_0;
    wire signed [PRODUCT_WIDTH-1:0] product_1;
    wire signed [PRODUCT_WIDTH-1:0] product_2;
    wire signed [PRODUCT_WIDTH-1:0] product_3;
    wire signed [PRODUCT_WIDTH-1:0] product_4;
    wire signed [PRODUCT_WIDTH-1:0] product_5;
    wire signed [PRODUCT_WIDTH-1:0] product_6;
    wire signed [PRODUCT_WIDTH-1:0] product_7;
    wire signed [PRODUCT_WIDTH-1:0] product_8;
    wire signed [PRODUCT_WIDTH-1:0] product_9;
    wire signed [PRODUCT_WIDTH-1:0] product_10;
    wire signed [PRODUCT_WIDTH-1:0] product_11;
    wire signed [PRODUCT_WIDTH-1:0] product_12;
    wire signed [PRODUCT_WIDTH-1:0] product_13;
    wire signed [PRODUCT_WIDTH-1:0] product_14;
    wire signed [PRODUCT_WIDTH-1:0] product_15;

    assign product_0  = sample_0  * coeff_0;
    assign product_1  = sample_1  * coeff_1;
    assign product_2  = sample_2  * coeff_2;
    assign product_3  = sample_3  * coeff_3;
    assign product_4  = sample_4  * coeff_4;
    assign product_5  = sample_5  * coeff_5;
    assign product_6  = sample_6  * coeff_6;
    assign product_7  = sample_7  * coeff_7;
    assign product_8  = sample_8  * coeff_8;
    assign product_9  = sample_9  * coeff_9;
    assign product_10 = sample_10 * coeff_10;
    assign product_11 = sample_11 * coeff_11;
    assign product_12 = sample_12 * coeff_12;
    assign product_13 = sample_13 * coeff_13;
    assign product_14 = sample_14 * coeff_14;
    assign product_15 = sample_15 * coeff_15;


    /*
     * ---------------------------------------------------------
     * 40-bit Accumulator
     * ---------------------------------------------------------
     *
     * Products are sign-extended from 32 bits to 40 bits
     * before addition.
     */

    reg signed [ACC_WIDTH-1:0] accumulator;

    always @(*) begin

        accumulator =
              {{8{product_0[31]}},  product_0}
            + {{8{product_1[31]}},  product_1}
            + {{8{product_2[31]}},  product_2}
            + {{8{product_3[31]}},  product_3}
            + {{8{product_4[31]}},  product_4}
            + {{8{product_5[31]}},  product_5}
            + {{8{product_6[31]}},  product_6}
            + {{8{product_7[31]}},  product_7}
            + {{8{product_8[31]}},  product_8}
            + {{8{product_9[31]}},  product_9}
            + {{8{product_10[31]}}, product_10}
            + {{8{product_11[31]}}, product_11}
            + {{8{product_12[31]}}, product_12}
            + {{8{product_13[31]}}, product_13}
            + {{8{product_14[31]}}, product_14}
            + {{8{product_15[31]}}, product_15};

    end


    /*
     * ---------------------------------------------------------
     * Fixed-Point Scaling
     * ---------------------------------------------------------
     *
     * Q1.15 × Q1.15 produces a value with 30 fractional bits.
     *
     * The coefficient representation requires shifting the
     * accumulated result right by 15 bits to return to the
     * original Q1.15 scale.
     */

    reg signed [ACC_WIDTH-1:0] scaled_result;

    always @(*) begin

        scaled_result = accumulator >>> 15;

    end


    /*
     * ---------------------------------------------------------
     * Saturation
     * ---------------------------------------------------------
     *
     * Output is limited to the 16-bit signed range:
     *
     * Maximum = +32767
     * Minimum = -32768
     */

    always @(*) begin

        if (scaled_result > 40'sd32767) begin

            filter_out = 16'sd32767;

        end
        else if (scaled_result < -40'sd32768) begin

            filter_out = -16'sd32768;

        end
        else begin

            filter_out = scaled_result[15:0];

        end

    end

endmodule