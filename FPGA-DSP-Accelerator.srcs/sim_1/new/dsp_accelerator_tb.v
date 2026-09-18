`timescale 1ns / 1ps

module dsp_accelerator_tb;

    // =========================================================
    // PARAMETERS
    // =========================================================

    parameter DATA_WIDTH = 16;

    // =========================================================
    // DUT SIGNALS
    // =========================================================

    reg                         clk;
    reg                         reset;
    reg                         input_valid;
    reg signed [15:0]           input_data;

    wire                        output_valid;
    wire signed [15:0]          output_data;

    // =========================================================
    // REFERENCE MODEL
    // =========================================================

    reg signed [15:0] history [0:15];
    reg signed [15:0] coeffs  [0:15];

    reg signed [63:0] expected_acc;
    reg signed [63:0] expected_scaled;
    reg signed [15:0] expected_output;

    integer i;
    integer test_count;
    integer pass_count;
    integer fail_count;

    // =========================================================
    // DUT
    // =========================================================

    dsp_accelerator_top uut (
        .clk(clk),
        .reset(reset),
        .input_valid(input_valid),
        .input_data(input_data),
        .output_valid(output_valid),
        .output_data(output_data)
    );

    // =========================================================
    // 100 MHz CLOCK
    // =========================================================

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end

    // =========================================================
    // FIR COEFFICIENTS
    // =========================================================

    initial begin

        coeffs[0]  = -16'sd328;
        coeffs[1]  = -16'sd492;
        coeffs[2]  = -16'sd655;
        coeffs[3]  =  16'sd0;
        coeffs[4]  =  16'sd1311;
        coeffs[5]  =  16'sd3604;
        coeffs[6]  =  16'sd5898;
        coeffs[7]  =  16'sd7045;

        coeffs[8]  =  16'sd7045;
        coeffs[9]  =  16'sd5898;
        coeffs[10] =  16'sd3604;
        coeffs[11] =  16'sd1311;
        coeffs[12] =  16'sd0;
        coeffs[13] = -16'sd655;
        coeffs[14] = -16'sd492;
        coeffs[15] = -16'sd328;

    end

    // =========================================================
    // CLEAR REFERENCE HISTORY
    // =========================================================

    task clear_history;

        integer j;

        begin

            for (j = 0; j < 16; j = j + 1) begin
                history[j] = 16'sd0;
            end

        end

    endtask

    // =========================================================
    // RESET DUT AND REFERENCE MODEL
    // Use this before every independent test so that the DUT
    // delay line and the reference-model history start identically.
    // =========================================================

    task reset_dut;

        integer j;

        begin

            // Clear reference-model history
            for (j = 0; j < 16; j = j + 1) begin
                history[j] = 16'sd0;
            end

            // Assert synchronous DUT reset
            reset       = 1'b1;
            input_valid = 1'b0;
            input_data  = 16'sd0;

            // Hold reset for several rising clock edges
            repeat (3) @(posedge clk);

            // Release reset before the next test sample
            reset = 1'b0;

            // Move to a clean half-cycle before driving a sample
            @(negedge clk);

        end

    endtask

    // =========================================================
    // CALCULATE EXPECTED FIR OUTPUT
    // =========================================================

    task calculate_expected;

        integer k;

        reg signed [63:0] temp_acc;
        reg signed [63:0] temp_scaled;

        begin

            temp_acc = 64'sd0;

            for (k = 0; k < 16; k = k + 1) begin

                temp_acc = temp_acc +
                           ($signed(history[k]) *
                            $signed(coeffs[k]));

            end

            expected_acc = temp_acc;

            // Q1.15 scaling

            temp_scaled = temp_acc >>> 15;

            expected_scaled = temp_scaled;

            // Saturation

            if (temp_scaled > 64'sd32767) begin

                expected_output = 16'sd32767;

            end
            else if (temp_scaled < -64'sd32768) begin

                expected_output = -16'sd32768;

            end
            else begin

                expected_output = temp_scaled[15:0];

            end

        end

    endtask

    // =========================================================
    // UPDATE REFERENCE HISTORY
    // =========================================================

    task update_history;

        input signed [15:0] new_sample;

        integer j;

        begin

            for (j = 15; j > 0; j = j - 1) begin
                history[j] = history[j-1];
            end

            history[0] = new_sample;

        end

    endtask

    // =========================================================
    // CHECK CURRENT OUTPUT
    // =========================================================

    task check_output;

        input signed [15:0] sample_value;

        begin

            calculate_expected;

            test_count = test_count + 1;

            if (output_data === expected_output) begin

                pass_count = pass_count + 1;

                $display(
                    "PASS | Test %0d | Input=%0d | Expected=%0d | Actual=%0d",
                    test_count,
                    sample_value,
                    expected_output,
                    output_data
                );

            end
            else begin

                fail_count = fail_count + 1;

                $display(
                    "FAIL | Test %0d | Input=%0d | Expected=%0d | Actual=%0d",
                    test_count,
                    sample_value,
                    expected_output,
                    output_data
                );

            end

        end

    endtask

    // =========================================================
    // SEND VALID SAMPLE
    // =========================================================

    task send_sample;

        input signed [15:0] sample_value;

        begin

            @(negedge clk);

            input_data  = sample_value;
            input_valid = 1'b1;

            update_history(sample_value);

            @(posedge clk);

            #1;

            check_output(sample_value);

            @(negedge clk);

            input_valid = 1'b0;
            input_data  = 16'sd0;

        end

    endtask

    // =========================================================
    // SEND SAMPLE WITHOUT VALID
    // Used to verify that the buffer does NOT shift.
    // =========================================================

    task send_invalid_cycle;

        input signed [15:0] sample_value;

        begin

            @(negedge clk);

            input_data  = sample_value;
            input_valid = 1'b0;

            @(posedge clk);

            #1;

            // No reference history update should occur.

            @(negedge clk);

            input_data  = 16'sd0;
            input_valid = 1'b0;

        end

    endtask

    // =========================================================
    // MAIN TESTBENCH
    // =========================================================

    initial begin

        // -----------------------------------------------------
        // INITIALIZATION
        // -----------------------------------------------------

        reset       = 1'b1;
        input_valid = 1'b0;
        input_data  = 16'sd0;

        test_count = 0;
        pass_count = 0;
        fail_count = 0;

        clear_history;

        $display("");
        $display("==================================================");
        $display("       FPGA DSP ACCELERATOR VERIFICATION");
        $display("==================================================");
        $display("");

        // =====================================================
        // TEST 1 - RESET
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 1: RESET");
        $display("----------------------------------------------");

        repeat (3) @(posedge clk);

        reset = 1'b0;

        $display("Reset released.");
        $display("");

        // =====================================================
        // TEST 2 - ZERO INPUT
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 2: ZERO INPUT");
        $display("----------------------------------------------");

        reset_dut;

        repeat (10) begin
            send_sample(16'sd0);
        end

        // =====================================================
        // TEST 3 - POSITIVE IMPULSE
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 3: POSITIVE IMPULSE");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(16'sd32767);

        repeat (15) begin
            send_sample(16'sd0);
        end

        // =====================================================
        // TEST 4 - NEGATIVE IMPULSE
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 4: NEGATIVE IMPULSE");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(-16'sd32768);

        repeat (15) begin
            send_sample(16'sd0);
        end

        // =====================================================
        // TEST 5 - POSITIVE DC
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 5: POSITIVE DC INPUT");
        $display("----------------------------------------------");

        reset_dut;

        repeat (20) begin
            send_sample(16'sd1000);
        end

        // =====================================================
        // TEST 6 - NEGATIVE DC
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 6: NEGATIVE DC INPUT");
        $display("----------------------------------------------");

        reset_dut;

        repeat (20) begin
            send_sample(-16'sd1000);
        end

        // =====================================================
        // TEST 7 - ALTERNATING VALUES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 7: ALTERNATING POSITIVE/NEGATIVE");
        $display("----------------------------------------------");

        reset_dut;

        repeat (10) begin
            send_sample(16'sd1000);
            send_sample(-16'sd1000);
        end

        // =====================================================
        // TEST 8 - MAXIMUM POSITIVE
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 8: MAXIMUM POSITIVE INPUT");
        $display("----------------------------------------------");

        reset_dut;

        repeat (16) begin
            send_sample(16'sd32767);
        end

        // =====================================================
        // TEST 9 - MAXIMUM NEGATIVE
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 9: MAXIMUM NEGATIVE INPUT");
        $display("----------------------------------------------");

        reset_dut;

        repeat (16) begin
            send_sample(-16'sd32768);
        end

        // =====================================================
        // TEST 10 - MAXIMUM TO MINIMUM
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 10: MAXIMUM TO MINIMUM TRANSITION");
        $display("----------------------------------------------");

        reset_dut;

        repeat (8) begin
            send_sample(16'sd32767);
        end

        repeat (8) begin
            send_sample(-16'sd32768);
        end

        // =====================================================
        // TEST 11 - MINIMUM TO MAXIMUM
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 11: MINIMUM TO MAXIMUM TRANSITION");
        $display("----------------------------------------------");

        reset_dut;

        repeat (8) begin
            send_sample(-16'sd32768);
        end

        repeat (8) begin
            send_sample(16'sd32767);
        end

        // =====================================================
        // TEST 12 - SMALL POSITIVE VALUES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 12: SMALL POSITIVE VALUES");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(1);
        send_sample(2);
        send_sample(3);
        send_sample(4);
        send_sample(5);
        send_sample(6);
        send_sample(7);
        send_sample(8);
        send_sample(9);
        send_sample(10);

        // =====================================================
        // TEST 13 - SMALL NEGATIVE VALUES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 13: SMALL NEGATIVE VALUES");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(-1);
        send_sample(-2);
        send_sample(-3);
        send_sample(-4);
        send_sample(-5);
        send_sample(-6);
        send_sample(-7);
        send_sample(-8);
        send_sample(-9);
        send_sample(-10);

        // =====================================================
        // TEST 14 - INCREASING RAMP
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 14: INCREASING RAMP");
        $display("----------------------------------------------");

        reset_dut;

        for (i = 0; i < 32; i = i + 1) begin
            send_sample(i * 100);
        end

        // =====================================================
        // TEST 15 - DECREASING RAMP
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 15: DECREASING RAMP");
        $display("----------------------------------------------");

        reset_dut;

        for (i = 0; i < 32; i = i + 1) begin
            send_sample(16'sd3000 - i * 100);
        end

        // =====================================================
        // TEST 16 - MIXED SIGNED DATA
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 16: MIXED SIGNED DATA");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(1000);
        send_sample(-500);
        send_sample(2000);
        send_sample(-1000);
        send_sample(3000);
        send_sample(-1500);
        send_sample(4000);
        send_sample(-2000);
        send_sample(5000);
        send_sample(-2500);
        send_sample(6000);
        send_sample(-3000);
        send_sample(7000);
        send_sample(-3500);
        send_sample(8000);
        send_sample(-4000);

        // =====================================================
        // TEST 17 - INPUT VALID GAPS
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 17: INPUT VALID GAPS");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(1000);

        send_invalid_cycle(5000);
        send_invalid_cycle(-5000);
        send_invalid_cycle(12000);

        send_sample(2000);

        send_invalid_cycle(25000);

        send_sample(3000);

        send_invalid_cycle(-30000);

        send_sample(4000);

        // =====================================================
        // TEST 18 - REPEATED IMPULSES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 18: REPEATED IMPULSES");
        $display("----------------------------------------------");

        reset_dut;

        repeat (5) begin
            send_sample(16'sd20000);

            repeat (3) begin
                send_sample(16'sd0);
            end
        end

        // =====================================================
        // TEST 19 - SYMMETRIC INPUT
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 19: SYMMETRIC INPUT");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(100);
        send_sample(200);
        send_sample(300);
        send_sample(400);
        send_sample(500);
        send_sample(600);
        send_sample(700);
        send_sample(800);
        send_sample(800);
        send_sample(700);
        send_sample(600);
        send_sample(500);
        send_sample(400);
        send_sample(300);
        send_sample(200);
        send_sample(100);

        // =====================================================
        // TEST 20 - RANDOM DATA
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 20: RANDOM DATA");
        $display("----------------------------------------------");

        reset_dut;

        repeat (100) begin
            send_sample($random);
        end

        // =====================================================
        // TEST 21 - LONG RANDOM STREAM
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 21: LONG RANDOM STREAM");
        $display("----------------------------------------------");

        reset_dut;

        repeat (500) begin
            send_sample($random);
        end

        // =====================================================
        // TEST 22 - RANDOM SMALL VALUES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 22: RANDOM SMALL VALUES");
        $display("----------------------------------------------");

        reset_dut;

        repeat (100) begin
            send_sample(($random % 2000) - 1000);
        end

        // =====================================================
        // TEST 23 - SATURATION STRESS
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 23: SATURATION STRESS");
        $display("----------------------------------------------");

        reset_dut;

        repeat (50) begin
            send_sample(16'sd32767);
        end

        // =====================================================
        // TEST 24 - ZERO AFTER LARGE VALUES
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 24: ZERO AFTER LARGE VALUES");
        $display("----------------------------------------------");

        reset_dut;

        repeat (16) begin
            send_sample(16'sd32767);
        end

        repeat (20) begin
            send_sample(16'sd0);
        end

        // =====================================================
        // TEST 25 - SIGN TRANSITION STRESS
        // =====================================================

        $display("----------------------------------------------");
        $display("TEST 25: SIGN TRANSITION STRESS");
        $display("----------------------------------------------");

        reset_dut;

        send_sample(32767);
        send_sample(-32768);
        send_sample(32767);
        send_sample(-32768);
        send_sample(16384);
        send_sample(-16384);
        send_sample(8192);
        send_sample(-8192);
        send_sample(4096);
        send_sample(-4096);
        send_sample(2048);
        send_sample(-2048);
        send_sample(1024);
        send_sample(-1024);
        send_sample(512);
        send_sample(-512);

        // =====================================================
        // FINAL SUMMARY
        // =====================================================

        $display("");
        $display("==================================================");
        $display("              FINAL TEST SUMMARY");
        $display("==================================================");

        $display("Total Tests : %0d", test_count);
        $display("Passed      : %0d", pass_count);
        $display("Failed      : %0d", fail_count);

        if (fail_count == 0) begin

            $display("");
            $display("*** ALL TESTS PASSED ***");
            $display("");

        end
        else begin

            $display("");
            $display("*** TEST FAILURES DETECTED ***");
            $display("");

        end

        $display("==================================================");

        $finish;

    end

endmodule