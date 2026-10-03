module basic_gates (
  input  logic a,
  input  logic b,
  output logic not_a,
  output logic and_y,
  output logic or_y,
  output logic xor_y,
  output logic nand_y,
  output logic nor_y,
  output logic xnor_y
);
  assign not_a = ~a;
  assign and_y = a&b;
  assign or_y = a|b;
  assign xor_y = a^b;
  assign nand_y = ~(a&b);
  assign nor_y = ~(a|b);
  assign xnor_y = ~(a^b);
endmodule
