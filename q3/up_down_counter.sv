module up_down_counter #(parameter N = 4)
                       (input  logic clk,
                        input  logic rst_n,
                        input  logic up_down,
                        input  logic load,
                        input  logic [N-1:0] input_load,
                        output logic [N-1:0] count_out,
                        output logic carry_out);
  
logic [N-1:0] next_cnt;
logic         next_carry;

  always_comb begin
    next_cnt   = count_out;
    next_carry = 1'b0;

    if (load) begin
      next_cnt   = input_load;
      next_carry = 1'b0;                      
    end
    else if (up_down) begin                    
      next_carry = &count_out;                 
      next_cnt   = count_out + 1'b1;
    end
    else begin                                 
      next_carry = (count_out == '0);          
      next_cnt   = count_out - 1'b1;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count_out <= '0;
      carry_out <= 1'b0;
    end else begin
      count_out <= next_cnt;
      carry_out <= next_carry;                 
    end
  end

endmodule