`timescale 1ns/1ps

module tb_LFSR_6bit;


  logic clk, rst_n, sel;
  logic [5:0] parallel_in;
  logic [5:0] parallel_out;


  LFSR_6bit dut (
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel),
    .parallel_in(parallel_in),
    .parallel_out(parallel_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;


  initial begin

    rst_n = 0;
    sel   = 0;
    parallel_in = 6'b0;


    #12 rst_n = 1;


    @(posedge clk);
    parallel_in = 6'b101011;  
    sel = 0;                  
    @(posedge clk);
    $display("[%0t] Parallel load: q = %b", $time, parallel_out);


    sel = 1;
    repeat (20) begin
      @(posedge clk);
      $display("[%0t] Shift: q = %b", $time, parallel_out);
    end

    #20 $finish;
  end

endmodule
