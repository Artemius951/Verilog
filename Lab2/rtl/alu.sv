module alu #(
    parameter int W = 8
) (
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    input  logic [2:0]   op,
    output logic [W-1:0] y,
    output logic         zero,
    output logic         negative,
    output logic         carry,
    output logic         overflow
);

    localparam int SHW = $clog2(W);
    logic [SHW-1:0] shamt_bits;
    assign shamt_bits = b[SHW-1:0];
    
    logic [W:0] sum, diff; 
    assign sum  = {1'b0, a} + {1'b0, b};
    assign diff = {1'b0, a} - {1'b0, b};

    always_comb begin
        int shamt;
        
        y        = '0;
        zero     = 1'b0;
        negative = 1'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        
        shamt = shamt_bits % W;
        
        case (op)
            3'b000: begin 
                y        = sum[W-1:0];
                carry    = sum[W];
                overflow = sum[W] ^ sum[W-1];
            end
            3'b001: begin
                y        = diff[W-1:0];
                carry    = ~diff[W]; 
                overflow = diff[W] ^ diff[W-1];
            end
            3'b010: y = a & b;       
            3'b011: y = a | b;       
            3'b100: y = a ^ b;       
            3'b101: y = a << shamt;  
            3'b110: y = a >> shamt;  
            3'b111: begin        
                y = { {W-1{1'b0}}, ($signed(a) < $signed(b)) };
            end
            default: begin
                y        = '0;
                carry    = 1'b0;
                overflow = 1'b0;
            end
        endcase
        
        zero     = (y == '0);
        negative = y[W-1];
    end

endmodule