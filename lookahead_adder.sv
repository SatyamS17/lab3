module lookahead_fa (
    input  logic a, b, c,
    
    output logic s, g, p
);
    assign s = a^b^c;
    assign g = a&b;
    assign p = a^b;
endmodule

module lookahead_cla4 (
    input  logic [3:0] g, p,
    input  logic cin,

    output logic [3:0] c,
    output logic       gg, pg, cout
);    
    assign c[0] = cin;
    assign c[1] = (cin & p[0]) | (g[0]);
    assign c[2] = (cin & p[0] & p[1]) | (g[0] & p[1]) | (g[1]);
    assign c[3] = (cin & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | (g[2]);
    
    assign gg = (g[3]) | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);
    assign pg = p[0] & p[1] & p[2] & p[3];
    
    assign cout = gg | (pg & c[3]);
endmodule

module lookahead_adder4 (
    input  logic [3:0] a, b,
    input  logic       cin,
    
    output logic [3:0] s,
    output logic       gg, pg
);
    logic [3:0] c, g, p;

    lookahead_fa fa0 (.a(a[0]), .b(b[0]), .c(c[0]), .s(s[0]), .g(g[0]), .p(p[0]));
    lookahead_fa fa1 (.a(a[1]), .b(b[1]), .c(c[1]), .s(s[1]), .g(g[1]), .p(p[1]));
    lookahead_fa fa2 (.a(a[2]), .b(b[2]), .c(c[2]), .s(s[2]), .g(g[2]), .p(p[2]));
    lookahead_fa fa3 (.a(a[3]), .b(b[3]), .c(c[3]), .s(s[3]), .g(g[3]), .p(p[3]));
    
    lookahead_cla4 cla (.cout(), .*);
endmodule

module lookahead_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);
    logic [3:0] c, g, p;
    logic       gg, pg;

    lookahead_adder4 adder4_0 (.a(a[3:0]),   .b(b[3:0]),   .cin(c[0]), .s(s[3:0]),   .gg(g[0]), .pg(p[0]));
    lookahead_adder4 adder4_1 (.a(a[7:4]),   .b(b[7:4]),   .cin(c[1]), .s(s[7:4]),   .gg(g[1]), .pg(p[1]));
    lookahead_adder4 adder4_2 (.a(a[11:8]),  .b(b[11:8]),  .cin(c[2]), .s(s[11:8]),  .gg(g[2]), .pg(p[2]));
    lookahead_adder4 adder4_3 (.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .s(s[15:12]), .gg(g[3]), .pg(p[3]));
    
    lookahead_cla4 cla (.*);
endmodule
