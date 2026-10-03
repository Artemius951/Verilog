`timescale 1ns/1ps

module tb_lab1_2;

    localparam int W = 4;
    logic [W-1:0] mux_d0;
    logic [W-1:0] mux_d1;
    logic         mux_sel;
    logic [W-1:0] mux_y;

    logic [1:0] dec_code;
    logic       dec_enable;
    logic [3:0] dec_onehot;

    mux2 #(.W(W)) u_mux2 (
        .d0  (mux_d0),
        .d1  (mux_d1),
        .sel (mux_sel),
        .y   (mux_y)
    );

    decoder2to4 u_decoder2to4 (
        .code   (dec_code),
        .enable (dec_enable),
        .onehot (dec_onehot)
    );

    initial begin
        $display("--------------------------------------------");
        $display("               Mux2 testing                 ");
        $display("--------------------------------------------");

        for (int sel_val = 0; sel_val <= 1; sel_val++) begin
            for (int i = 0; i < (1 << W); i++) begin
                for (int j = 0; j < (1 << W); j++) begin
                    mux_sel = sel_val[0];
                    mux_d0  = i[W-1:0];
                    mux_d1  = j[W-1:0];
                    #5;

                    assert (!$isunknown(mux_y))
                        else $error("[MUX FAIL] Unknown state X/Z detected on output y!");

                    // Switch correctness check
                    if (mux_sel == 1'b0) begin
                        assert (mux_y === mux_d0)
                            else $error("[MUX FAIL] sel=0: expected %b, got %b", mux_d0, mux_y);
                    end else begin
                        assert (mux_y === mux_d1)
                            else $error("[MUX FAIL] sel=1: expected %b, got %b", mux_d1, mux_y);
                    end
                end
            end
        end
        $display("[MUX OK] Multiplexer passed all tests successfully.");

        $display("\n--------------------------------------------");
        $display("               Testing Decoder                ");
        $display("--------------------------------------------");
        for (int en = 0; en <= 1; en++) begin
            for (int c = 0; c < 4; c++) begin
                dec_enable = en[0];
                dec_code   = c[1:0];
                #5;

                assert (!$isunknown(dec_onehot))
                    else $error("[DEC FAIL] Unknown state X/Z detected on output onehot!");

                if (!dec_enable) begin
                    assert (dec_onehot === 4'b0000)
                        else $error("[DEC FAIL] enable=0, but onehot != 0000 (got %b)", dec_onehot);
                end else begin
                    assert ($onehot(dec_onehot))
                        else $error("[DEC FAIL] Output %b is not a valid one-hot code!", dec_onehot);

                    assert (dec_onehot[dec_code] === 1'b1)
                        else $error("[DEC FAIL] code=%b, but bit %0d is not 1", dec_code, dec_code);
                end
            end
        end
        $display("[DEC OK] Decoder passed all tests successfully.");

        $display("\n-------------------------------------------------");
        $display("                 TESTS PASSED                 ");
        $display("-------------------------------------------------");
        $finish;
    end

endmodule
