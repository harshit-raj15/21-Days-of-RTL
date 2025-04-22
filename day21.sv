module day21 #(
  parameter WIDTH = 12
)(
  input       wire [WIDTH-1:0]  vec_i,
  output      wire [WIDTH-1:0]  second_bit_o

);

  logic [WIDTH-1:0] first_bit;
  logic [WIDTH-1:0] masked_vec;

  // Find the first bit set
  day14 #(.NUM_PORTS(WIDTH)) find_first (
    .req_i          (vec_i),
    .gnt_o          (first_bit)
  );

  // Mask the first bit
  assign masked_vec = vec_i & ~first_bit;

  // Do a find first set on the masked vector to get second bit set
  day14 #(.NUM_PORTS(WIDTH)) find_second (
    .req_i          (masked_vec),
    .gnt_o          (second_bit_o)
  );

endmodule

module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
  end

endmodule
