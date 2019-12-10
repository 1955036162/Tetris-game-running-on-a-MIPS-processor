module dffe_ref(q, d, clk, reset);

    //Inputs
    input d, clk, reset;
    //Internal wires
    wire reset;
    //Output
    output q;
    //Register
    reg q;

    //Intialize q to 0
    initial
    begin
        q = 1'b0;
    end

    //Set value of q on positive edge of the clock or clear
    always @(posedge clk or posedge reset) begin
        //If reset is high, set q to 0
        if (reset) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    end

endmodule
