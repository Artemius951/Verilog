module decoder2to4 (
    input logic [1:0] code,
    input logic enable,
    output logic [3:0] onehot
);
    always_comb begin
        onehot = 4'b0000;
        if (enable) begin
            case (code)
                2'b00: onehot = 4'b0001;
                2'b01: onehot = 4'b0010;    
                2'b10: onehot = 4'b0100;
                2'b11: onehot = 4'b1000; 
                default: onehot = 4'b0000;
            endcase
        end 
    end
endmodule