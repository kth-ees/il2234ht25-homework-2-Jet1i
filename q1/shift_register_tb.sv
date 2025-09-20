`timescale 1ns/1ps

module tb_shift_register;

  parameter N = 4;

  logic clk;
  logic rst_n;
  logic serial_parallel;
  logic load_enable;
  logic serial_in;
  logic [N-1:0] parallel_in;
  logic [N-1:0] parallel_out;
  logic serial_out;


  shift_register #(.N(N)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .serial_parallel(serial_parallel),
    .load_enable(load_enable),
    .serial_in(serial_in),
    .parallel_in(parallel_in),
    .parallel_out(parallel_out),
    .serial_out(serial_out)
  );

  initial clk = 0;
  always #5 clk = ~clk; 


  initial begin

    rst_n = 0;
    serial_parallel = 0;
    load_enable = 0;
    serial_in = 0;
    parallel_in = 0;


    #12 rst_n = 1;
    $display("Time=%0t Reset released, parallel_out=%b", $time, parallel_out);


    @(posedge clk);
    load_enable = 1;
    serial_parallel = 1;
    parallel_in = 4'b1010;
    @(posedge clk);
    load_enable = 0;  
    $display("Time=%0t Parallel load, parallel_out=%b", $time, parallel_out);


    serial_parallel = 0;
    repeat (4) begin
      serial_in = $urandom_range(0,1);  
      load_enable = 1;
      @(posedge clk);
      $display("Time=%0t Shifted in=%b, parallel_out=%b, serial_out=%b",
               $time, serial_in, parallel_out, serial_out);
    end
    load_enable = 0;

    #20;
    $stop;
  end

endmodule
