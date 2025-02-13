module full_adder (
    input logic a, b, c,
    
    output logic s,cout
);
    assign s = a^b^c;
    assign cout = (a&b)|(b&c)|(a&c);
endmodule

module ADDER4 (
    input logic [3:0] A, B,
    input logic c_in,
    
    output logic [3:0] S,
    output logic c_out
);

    logic c1, c2, c3;
    full_adder FA0(.a(A[0]), .b(B[0]), .c(c_in), .s(S[0]), .cout(c1));
    full_adder FA1(.a(A[1]), .b(B[1]), .c(c1), .s(S[1]), .cout(c2));
    full_adder FA2(.a(A[2]), .b(B[2]), .c(c2), .s(S[2]), .cout(c3));
    full_adder FA3(.a(A[3]), .b(B[3]), .c(c3), .s(S[3]), .cout(c_out));
endmodule



module ripple_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);
    logic c4;
    logic c8;
    logic c12;
    
	ADDER4 ADDER4_0 (.A(a[3:0]), .B(b[3:0]), .c_in(cin), .S(s[3:0]), .c_out(c4));
	ADDER4 ADDER4_1 (.A(a[7:4]), .B(b[7:4]), .c_in(c4), .S(s[7:4]), .c_out(c8));
	ADDER4 ADDER4_2 (.A(a[11:8]), .B(b[11:8]), .c_in(c8), .S(s[11:8]), .c_out(c12));
	ADDER4 ADDER4_3 (.A(a[15:12]), .B(b[15:12]), .c_in(c12), .S(s[15:12]), .c_out(cout));
endmodule