module tb;

    logic a, b;
    logic not_a, and_y, or_y, xor_y, nand_y, nor_y, xnor_y;

    basic_gates dut (
        .a      (a),
        .b      (b),
        .not_a  (not_a),
        .and_y  (and_y),
        .or_y   (or_y),
        .xor_y  (xor_y),
        .nand_y (nand_y),
        .nor_y  (nor_y),
        .xnor_y (xnor_y)
    );

    logic [6:0] actual_vec;
    logic [6:0] expected_vec;
    
    int error_count = 0;

    initial begin
        
        for (int i = 0; i < 4; i++) begin
            a = (i >> 1) & 1;
            b = i & 1;

            #1; 

            actual_vec = {not_a, and_y, or_y, xor_y, nand_y, nor_y, xnor_y};

            expected_vec = { ~a, (a & b), (a | b), (a ^ b), ~(a & b), ~(a | b), ~(a ^ b) };

            if ($isunknown(actual_vec)) begin
                $display("ERROR: Unknown value (X/Z) detected at inputs a=%b, b=%b", a, b);
                error_count++;
            end
            
            if (actual_vec !== expected_vec) begin
                $display("MISMATCH at inputs: a=%b, b=%b", a, b);
                $display("  Expected vector: %b", expected_vec);
                $display("  Actual vector  : %b", actual_vec);
                error_count++;
            end
        end

        $display("-------------------------------------------------");
        if (error_count == 0) begin
            $display("TEST PASSED: All 4 combinations verified successfully. Zero errors.");
        end else begin
            $display("TEST FAILED: %0d error(s) found.", error_count);
        end
        $display("-------------------------------------------------");
        
        $finish; 
    end

endmodule