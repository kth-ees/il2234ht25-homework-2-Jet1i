module LFSR_6bit (
  input  logic clk, rst_n,
  input  logic sel,
  input  logic [5:0] parallel_in,
  output logic [5:0] parallel_out
);
  logic [5:0] q, nxt;
  logic fb;

  assign fb = q[5];

  // Next-state (shift mode) — matches your "x0=out5; x1=out0^out5; x3=out2^out5"
  always_comb begin
    nxt[0] = fb;            // x0_next = out5
    nxt[1] = q[0] ^ fb;     // x1_next = out0 ^ out5
    nxt[2] = q[1];          // x2_next = out1
    nxt[3] = q[2] ^ fb;     // x3_next = out2 ^ out5
    nxt[4] = q[3];          // x4_next = out3
    nxt[5] = q[4];          // x5_next = out4
  end

  // State registers
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q <= '0;
    end else if (sel == 1'b0) begin
      q <= parallel_in;     // parallel load
    end else begin
      q <= nxt;             // shift (LFSR)
    end
  end

  assign parallel_out = q;
endmodule
