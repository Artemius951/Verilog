module tb_lab2;
    // W=8
    logic [7:0]  dut_a8, dut_b8;
    logic [2:0]  dut_op8;
    logic [7:0]  dut_y8;
    logic        dut_zero8, dut_negative8, dut_carry8, dut_overflow8;

    alu #(.W(8)) dut8 (
        .a(dut_a8), .b(dut_b8), .op(dut_op8),
        .y(dut_y8), .zero(dut_zero8), .negative(dut_negative8),
        .carry(dut_carry8), .overflow(dut_overflow8)
    );

    // W=32
    logic [31:0] dut_a32, dut_b32;
    logic [2:0]  dut_op32;
    logic [31:0] dut_y32;
    logic        dut_zero32, dut_negative32, dut_carry32, dut_overflow32;

    alu #(.W(32)) dut32 (
        .a(dut_a32), .b(dut_b32), .op(dut_op32),
        .y(dut_y32), .zero(dut_zero32), .negative(dut_negative32),
        .carry(dut_carry32), .overflow(dut_overflow32)
    );

    int seed_val;
    int pass_count8, fail_count8;
    int pass_count32, fail_count32;

    // Тесты для W=8
    task check_case8(input logic [2:0] op, input logic [7:0] a, b);
        logic [7:0] y_exp;
        logic zero_exp, neg_exp, carry_exp, ovf_exp;
        logic [8:0] sum_ext, diff_ext;
        int shamt;

        sum_ext  = {1'b0, a} + {1'b0, b};
        diff_ext = {1'b0, a} - {1'b0, b};
        shamt = int'(b[2:0]) % 8;

        case (op)
            3'b000: y_exp = sum_ext[7:0];
            3'b001: y_exp = diff_ext[7:0];
            3'b010: y_exp = a & b;
            3'b011: y_exp = a | b;
            3'b100: y_exp = a ^ b;
            3'b101: y_exp = a << shamt;
            3'b110: y_exp = a >> shamt;
            3'b111: y_exp = ($signed(a) < $signed(b)) ? 1 : 0;
            default: y_exp = '0;
        endcase

        zero_exp = (y_exp == '0);
        neg_exp  = y_exp[7];

        case (op)
            3'b000: begin
                carry_exp = sum_ext[8];
                ovf_exp   = (a[7] == b[7]) && (y_exp[7] != a[7]);
            end
            3'b001: begin
                carry_exp = ~diff_ext[8];
                ovf_exp   = (a[7] != b[7]) && (y_exp[7] != a[7]);
            end
            default: begin
                carry_exp = 1'b0;
                ovf_exp   = 1'b0;
            end
        endcase

        dut_op8 = op; dut_a8 = a; dut_b8 = b;
        #10;

        if (dut_y8 !== y_exp || dut_zero8 !== zero_exp || dut_negative8 !== neg_exp ||
            dut_carry8 !== carry_exp || dut_overflow8 !== ovf_exp) begin
            $display("[FAIL W=8] op=%b a=%h b=%h | exp_y=%h exp_z=%b exp_n=%b exp_c=%b exp_o=%b | got_y=%h got_z=%b got_n=%b got_c=%b got_o=%b",
                     op, a, b,
                     y_exp, zero_exp, neg_exp, carry_exp, ovf_exp,
                     dut_y8, dut_zero8, dut_negative8, dut_carry8, dut_overflow8);
            fail_count8++;
            $stop;
        end else begin
            pass_count8++;
        end
    endtask

    task run_tests8();
        $display("--- Running Tests for W=8 ---");
        check_case8(3'b000, 8'h00, 8'h00);
        check_case8(3'b000, 8'hFF, 8'h01);
        check_case8(3'b000, 8'h7F, 8'h01);
        check_case8(3'b000, 8'h80, 8'h80);
        check_case8(3'b001, 8'h0A, 8'h0A);
        check_case8(3'b001, 8'h00, 8'h01);
        check_case8(3'b001, 8'h80, 8'h01);
        check_case8(3'b001, 8'h7F, 8'hFF);
        check_case8(3'b101, 8'hAA, 8'h00);
        check_case8(3'b101, 8'hAA, 8'h01);
        check_case8(3'b101, 8'hAA, 8'h07);
        check_case8(3'b101, 8'hAA, 8'h09);
        check_case8(3'b110, 8'hAA, 8'h00);
        check_case8(3'b110, 8'hAA, 8'h01);
        check_case8(3'b111, 8'h05, 8'h0A);
        check_case8(3'b111, 8'hFB, 8'hF6);
        check_case8(3'b111, 8'hFF, 8'h01);

        for (int i = 0; i < 1000; i++) begin
            logic [2:0] rnd_op;
            logic [7:0] rnd_a, rnd_b;
            rnd_op = $urandom_range(0, 7);
            rnd_a  = $urandom;
            rnd_b  = $urandom;
            check_case8(rnd_op, rnd_a, rnd_b);
        end
        $display("--- W=8 Tests Passed ---");
    endtask

    // Тесты для W=32
    task check_case32(input logic [2:0] op, input logic [31:0] a, b);
        logic [31:0] y_exp;
        logic zero_exp, neg_exp, carry_exp, ovf_exp;
        logic [32:0] sum_ext, diff_ext;
        int shamt;

        sum_ext  = {1'b0, a} + {1'b0, b};
        diff_ext = {1'b0, a} - {1'b0, b};
        shamt = int'(b[4:0]) % 32;

        case (op)
            3'b000: y_exp = sum_ext[31:0];
            3'b001: y_exp = diff_ext[31:0];
            3'b010: y_exp = a & b;
            3'b011: y_exp = a | b;
            3'b100: y_exp = a ^ b;
            3'b101: y_exp = a << shamt;
            3'b110: y_exp = a >> shamt;
            3'b111: y_exp = ($signed(a) < $signed(b)) ? 1 : 0;
            default: y_exp = '0;
        endcase

        zero_exp = (y_exp == '0);
        neg_exp  = y_exp[31];

        case (op)
            3'b000: begin
                carry_exp = sum_ext[32];
                ovf_exp   = (a[31] == b[31]) && (y_exp[31] != a[31]);
            end
            3'b001: begin
                carry_exp = ~diff_ext[32];
                ovf_exp   = (a[31] != b[31]) && (y_exp[31] != a[31]);
            end
            default: begin
                carry_exp = 1'b0;
                ovf_exp   = 1'b0;
            end
        endcase

        dut_op32 = op; dut_a32 = a; dut_b32 = b;
        #10;

        if (dut_y32 !== y_exp || dut_zero32 !== zero_exp || dut_negative32 !== neg_exp ||
            dut_carry32 !== carry_exp || dut_overflow32 !== ovf_exp) begin
            $display("[FAIL W=32] op=%b a=%h b=%h | exp_y=%h exp_z=%b exp_n=%b exp_c=%b exp_o=%b | got_y=%h got_z=%b got_n=%b got_c=%b got_o=%b",
                     op, a, b,
                     y_exp, zero_exp, neg_exp, carry_exp, ovf_exp,
                     dut_y32, dut_zero32, dut_negative32, dut_carry32, dut_overflow32);
            fail_count32++;
            $stop;
        end else begin
            pass_count32++;
        end
    endtask

    task run_tests32();
        $display("--- Running Tests for W=32 ---");
        check_case32(3'b000, 32'h00000000, 32'h00000000);
        check_case32(3'b000, 32'hFFFFFFFF, 32'h00000001);
        check_case32(3'b000, 32'h7FFFFFFF, 32'h00000001);
        check_case32(3'b000, 32'h80000000, 32'h80000000);
        check_case32(3'b001, 32'h0000000A, 32'h0000000A);
        check_case32(3'b001, 32'h00000000, 32'h00000001);
        check_case32(3'b001, 32'h80000000, 32'h00000001);
        check_case32(3'b001, 32'h7FFFFFFF, 32'hFFFFFFFF);
        check_case32(3'b101, 32'hAAAAAAAA, 32'h00000000);
        check_case32(3'b101, 32'hAAAAAAAA, 32'h00000001);
        check_case32(3'b101, 32'hAAAAAAAA, 32'h0000001F);
        check_case32(3'b101, 32'hAAAAAAAA, 32'h00000021);
        check_case32(3'b110, 32'hAAAAAAAA, 32'h00000000);
        check_case32(3'b110, 32'hAAAAAAAA, 32'h00000001);
        check_case32(3'b111, 32'h00000005, 32'h0000000A);
        check_case32(3'b111, 32'hFFFFFFFB, 32'hFFFFFFF6);
        check_case32(3'b111, 32'hFFFFFFFF, 32'h00000001);

        for (int i = 0; i < 300; i++) begin
            logic [2:0]  rnd_op;
            logic [31:0] rnd_a, rnd_b;
            rnd_op = $urandom_range(0, 7);
            rnd_a  = $urandom;
            rnd_b  = $urandom;
            check_case32(rnd_op, rnd_a, rnd_b);
        end
        $display("--- W=32 Tests Passed ---");
    endtask

    initial begin
        pass_count8  = 0;
        fail_count8  = 0;
        pass_count32 = 0;
        fail_count32 = 0;
        seed_val = 12345;
        $urandom(seed_val);
        $display("Random Seed: %0d", seed_val);

        run_tests8();
        run_tests32();

        $display("\n=================================");
        $display("SIMULATION FINISHED");
        $display("W=8:  Passed=%0d Failed=%0d", pass_count8,  fail_count8);
        $display("W=32: Passed=%0d Failed=%0d", pass_count32, fail_count32);
        $display("=================================\n");
        $finish;
    end
endmodule
