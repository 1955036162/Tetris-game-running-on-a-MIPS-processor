module clock_divider(clk, clk_out);

    input clk;
    output clk_out;

    reg  [1:0] r_reg;
    wire [1:0] r_next;
    reg clk_track;

    always @(negedge clk)
    begin
      if (r_next == 2'b10)
        begin
            r_reg <= 0;
            clk_track <= ~clk_track;
        end
      else
        r_reg <= r_next;
    end

    assign r_next = r_reg+2'b01;
    assign clk_out = clk_track;

endmodule
