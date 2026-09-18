`timescale 1ns / 1ps

module fir_sample_buffer #(
    parameter DATA_WIDTH = 16,
    parameter NUM_TAPS   = 16
)(
    input  wire                         clk,
    input  wire                         reset,
    input  wire                         sample_valid,
    input  wire signed [DATA_WIDTH-1:0] sample_in,

    output wire signed [DATA_WIDTH-1:0] sample_0,
    output wire signed [DATA_WIDTH-1:0] sample_1,
    output wire signed [DATA_WIDTH-1:0] sample_2,
    output wire signed [DATA_WIDTH-1:0] sample_3,
    output wire signed [DATA_WIDTH-1:0] sample_4,
    output wire signed [DATA_WIDTH-1:0] sample_5,
    output wire signed [DATA_WIDTH-1:0] sample_6,
    output wire signed [DATA_WIDTH-1:0] sample_7,
    output wire signed [DATA_WIDTH-1:0] sample_8,
    output wire signed [DATA_WIDTH-1:0] sample_9,
    output wire signed [DATA_WIDTH-1:0] sample_10,
    output wire signed [DATA_WIDTH-1:0] sample_11,
    output wire signed [DATA_WIDTH-1:0] sample_12,
    output wire signed [DATA_WIDTH-1:0] sample_13,
    output wire signed [DATA_WIDTH-1:0] sample_14,
    output wire signed [DATA_WIDTH-1:0] sample_15
);

    reg signed [DATA_WIDTH-1:0] sample_reg [0:NUM_TAPS-1];

    integer i;

    always @(posedge clk) begin

        if (reset) begin

            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                sample_reg[i] <= {DATA_WIDTH{1'b0}};
            end

        end
        else if (sample_valid) begin

            for (i = NUM_TAPS-1; i > 0; i = i - 1) begin
                sample_reg[i] <= sample_reg[i-1];
            end

            sample_reg[0] <= sample_in;

        end

    end

    assign sample_0  = sample_reg[0];
    assign sample_1  = sample_reg[1];
    assign sample_2  = sample_reg[2];
    assign sample_3  = sample_reg[3];
    assign sample_4  = sample_reg[4];
    assign sample_5  = sample_reg[5];
    assign sample_6  = sample_reg[6];
    assign sample_7  = sample_reg[7];
    assign sample_8  = sample_reg[8];
    assign sample_9  = sample_reg[9];
    assign sample_10 = sample_reg[10];
    assign sample_11 = sample_reg[11];
    assign sample_12 = sample_reg[12];
    assign sample_13 = sample_reg[13];
    assign sample_14 = sample_reg[14];
    assign sample_15 = sample_reg[15];

endmodule