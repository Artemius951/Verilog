module mux2 #(
    parameter int W = 4
) (
    input logic [W-1:0] d0,
    input logic [W-1:0] d1,
    input logic sel,
    output logic [W-1:0] y
);
    assign y = sel ? d1 : d0;
endmodule
