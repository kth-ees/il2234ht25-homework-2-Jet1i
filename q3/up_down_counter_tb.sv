`timescale 1ns/1ps
module tb_up_down_counter;
  localparam int N = 4;

  logic clk, rst_n;
  logic up_down, load;
  logic [N-1:0] input_load;
  logic [N-1:0] count_out;
  logic carry_out;

  up_down_counter #(.N(N)) dut (
    .clk, .rst_n, .up_down, .load, .input_load, .count_out, .carry_out
  );


  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    rst_n = 0; up_down = 1; load = 0; input_load = '0;
    #12 rst_n = 1;


    @(posedge clk);
    input_load = 4'hE; load = 1;        // 1110
    @(posedge clk);
    load = 0;
    $display("[%0t] load E  -> count=%0h carry=%b", $time, count_out, carry_out);


    repeat (3) @(posedge clk)
      $display("[%0t] up     -> count=%0h carry=%b", $time, count_out, carry_out);


    up_down = 0;
    repeat (3) @(posedge clk)
      $display("[%0t] down   -> count=%0h carry=%b", $time, count_out, carry_out);


    @(posedge clk);
    input_load = 4'h3; load = 1;
    @(posedge clk);
    load = 0; up_down = 1;
    repeat (6) @(posedge clk)
      $display("[%0t] up     -> count=%0h carry=%b", $time, count_out, carry_out);

    #20 $finish;
  end
endmodule
