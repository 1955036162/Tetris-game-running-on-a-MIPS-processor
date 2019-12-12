module mux_1bit(a, b, s, o);

    input a, b, s;  //input a, b  selector s
    wire s1, o1, o2;
    output o;

    not not_gate(s1, s);
    and and_gate1(o1, a, s);   //o1 = as
    and and_gate2(o2, b, s1);  //o2 = bs'
    or  or_gate(o, o1, o2);    //o  = as + bs'

endmodule
