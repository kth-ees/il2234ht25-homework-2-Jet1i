`timescale 1ns/1ps

module tb_registerfile;

  logic clk, rst_n;
  logic write_en;
  logic [3:0] write_addr, read_addr1, read_addr2;
  logic [7:0] data_in;
  logic [7:0] data_out1, data_out2;

  // DUT 实例
  registerfile dut (
    .clk, .rst_n, .write_en,
    .write_addr, .data_in,
    .read_addr1, .read_addr2,
    .data_out1, .data_out2
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 0; write_en = 0; data_in = 0;
    write_addr = 0; read_addr1 = 0; read_addr2 = 0;

    #12 rst_n = 1;

    @(posedge clk);
    write_en   = 1;
    write_addr = 4'd3;
    data_in    = 8'hA5;

    @(posedge clk);
    write_en = 0;

    @(posedge clk);
    read_addr1 = 4'd3;
    read_addr2 = 4'd0;  

    repeat (3) @(posedge clk);

    $finish;
  end

endmodule
