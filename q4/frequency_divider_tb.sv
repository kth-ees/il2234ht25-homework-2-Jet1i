`timescale 1ns/1ps
module tb_frequency_divider;
  logic clk, rst_n;
  logic divider_out;

  frequency_divider dut (.clk(clk), .rst_n(rst_n), .divider_out(divider_out));


  initial clk = 0;
  always #5 clk = ~clk;

  int last_edge_cycle = 0;
  int cycle = 0;
  bit last_div;

  initial begin
    rst_n = 0; #20; rst_n = 1;

    last_div = divider_out;
    repeat (8) begin
      @(posedge clk);
      cycle++;
      if (divider_out != last_div) begin
        $display("[%0t] toggle after %0d cycles", $time, cycle - last_edge_cycle);
        last_edge_cycle = cycle;
        last_div = divider_out;
      end
    end

    #100 $finish;
  end
endmodule
