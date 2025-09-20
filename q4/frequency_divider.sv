module frequency_divider (
  input  logic clk,
  input  logic rst_n,
  output logic divider_out
);

  localparam logic [15:0] PI_18  = 16'hFFEE; // 65536-18
  localparam logic [15:0] PI_866 = 16'hFC9E; // 65536-866

  // ---------- state ----------
  logic        sel;         // 0: use 18, 1: use 866  
  logic        load;       
  logic [15:0] load_val;    
  logic [15:0] count;       ）
  logic        co0, co1, co2, co3; 
  logic        tff_q;

 
  assign load_val = sel ? PI_866 : PI_18;

  // LSB slice: en=1
  counter4 u0 (.clk, .rst_n, .en(1'b1),  .load(load), .load_val(load_val[3:0]),
               .q(count[3:0]), .carry(co0));
  // 其余切片的 en 为前一级 carry（ripple）
  counter4 u1 (.clk, .rst_n, .en(co0),   .load(load), .load_val(load_val[7:4]),
               .q(count[7:4]), .carry(co1));
  counter4 u2 (.clk, .rst_n, .en(co1),   .load(load), .load_val(load_val[11:8]),
               .q(count[11:8]), .carry(co2));
  counter4 u3 (.clk, .rst_n, .en(co2),   .load(load), .load_val(load_val[15:12]),
               .q(count[15:12]), .carry(co3));



  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sel   <= 1'b0;    
      tff_q <= 1'b0;
    end else if (Co) begin
      sel   <= ~sel;     
      tff_q <= ~tff_q;  
    end
  end

  assign load = co3;

  assign divider_out = tff_q;
endmodule
