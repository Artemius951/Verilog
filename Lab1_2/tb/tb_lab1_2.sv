
module tb_lab1_2;

    localparam int W = 4;
    logic [W-1:0] mux_d0;
    logic [W-1:0] mux_d1;
    logic         mux_sel;
    logic [W-1:0] mux_y;

    logic [1:0] dec_code;
    logic       dec_enable;
    logic [3:0] dec_onehot;

    int mux_errors = 0;
    int dec_errors = 0;
    int error_count = 0;

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
        $display("Mux2 testing");
        
        for (int sel_val = 0; sel_val <= 1; sel_val++) begin
            for (int i = 0; i < (1 << W); i++) begin
                for (int j = 0; j < (1 << W); j++) begin
                    mux_sel = sel_val[0];
                    mux_d0  = i[W-1:0];
                    mux_d1  = j[W-1:0];
                    #1;

                    assert (!$isunknown(mux_y))
                        else begin
                            $display("[MUX FAIL] Unknown state X/Z detected on output y!");
                            mux_errors++;
                        end

                    if (mux_sel == 1'b0) begin
                        assert (mux_y === mux_d0)
                            else begin
                                $display("[MUX FAIL] sel=0: expected %b, got %b", mux_d0, mux_y);
                                mux_errors++;
                            end
                    end else begin
                        assert (mux_y === mux_d1)
                            else begin
                                $display("[MUX FAIL] sel=1: expected %b, got %b", mux_d1, mux_y);
                                mux_errors++;
                            end
                    end
                end
            end
        end

        if (mux_errors == 0) begin
            $display("[MUX OK] Multiplexer passed all tests successfully.");
        end else begin
            $display("[MUX FAIL] Multiplexer failed with %0d error(s).", mux_errors);
        end

        $display("Testing Decoder");
        
        for (int en = 0; en <= 1; en++) begin
            for (int c = 0; c < 4; c++) begin
                dec_enable = en[0];
                dec_code   = c[1:0];
                #1;

                assert (!$isunknown(dec_onehot))
                    else begin
                        $display("[DEC FAIL] Unknown state X/Z detected on output onehot!");
                        dec_errors++;
                    end

                if (!dec_enable) begin
                    assert (dec_onehot === 4'b0000)
                        else begin
                            $display("[DEC FAIL] enable=0, but onehot != 0000 (got %b)", dec_onehot);
                            dec_errors++;
                        end
                end else begin
                    assert ($onehot(dec_onehot))
                        else begin
                            $display("[DEC FAIL] Output %b is not a valid one-hot code!", dec_onehot);
                            dec_errors++;
                        end

                    assert (dec_onehot[dec_code] === 1'b1)
                        else begin
                            $display("[DEC FAIL] code=%b, but bit %0d is not 1", dec_code, dec_code);
                            dec_errors++;
                        end
                end
            end
        end

        if (dec_errors == 0) begin
            $display("[DEC OK] Decoder passed all tests successfully.");
        end else begin
            $display("[DEC FAIL] Decoder failed with %0d error(s).", dec_errors);
        end

        error_count = mux_errors + dec_errors;

        if (error_count == 0) begin
            $display("TEST PASSED: All tests verified successfully. Zero errors.");
        end else begin
            $display("TEST FAILED: Total %0d error(s) found.", error_count);
        end

        $finish;
    end

endmodule