module select_full_adder (
    input logic a, b, c,
    
    output logic s,cout
);
    assign s = a^b^c;
    assign cout = (a&b)|(b&c)|(a&c);
endmodule
 
module two_to_one_mux (
    input logic a,
    input logic b,
    input logic select,
    
    output logic out
);
    always_comb
    begin
        out = (select == 0) ? a : b;
    end
    
endmodule

module SELECT_ADDER4 (
    input logic [3:0] A, B,
    input logic c_in,
    
    output logic [3:0] S,
    output logic c_out
);
    logic [1:0] S0, S1, S2, S3;
    logic [1:0] c0, c1, c2, c3;
    logic zero = 1'b0;
    logic one = 1'b1;

    select_full_adder FA0(.a(A[0]), .b(B[0]), .c(zero), .s(S0[0]), .cout(c0[0]));
    select_full_adder FA1(.a(A[1]), .b(B[1]), .c(c0[0]), .s(S1[0]), .cout(c1[0]));
    select_full_adder FA2(.a(A[2]), .b(B[2]), .c(c1[0]), .s(S2[0]), .cout(c2[0]));
    select_full_adder FA3(.a(A[3]), .b(B[3]), .c(c2[0]), .s(S3[0]), .cout(c3[0]));
    
    select_full_adder FA4(.a(A[0]), .b(B[0]), .c(one), .s(S0[1]), .cout(c0[1]));
    select_full_adder FA5(.a(A[1]), .b(B[1]), .c(c0[1]), .s(S1[1]), .cout(c1[1]));
    select_full_adder FA6(.a(A[2]), .b(B[2]), .c(c1[1]), .s(S2[1]), .cout(c2[1]));
    select_full_adder FA7(.a(A[3]), .b(B[3]), .c(c2[1]), .s(S3[1]), .cout(c3[1]));
    
    two_to_one_mux M1(.a(S0[0]), .b(S0[1]), .select(c_in), .out(S[0]));
    two_to_one_mux M2(.a(S1[0]), .b(S1[1]), .select(c_in), .out(S[1]));
    two_to_one_mux M3(.a(S2[0]), .b(S2[1]), .select(c_in), .out(S[2]));
    two_to_one_mux M4(.a(S3[0]), .b(S3[1]), .select(c_in), .out(S[3]));
    
    two_to_one_mux M5(.a(c3[0]), .b(c3[1]), .select(c_in), .out(c_out));
    
endmodule
    
module select_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout  
);

    logic c4;
    logic c8;
    logic c12;
    
	SELECT_ADDER4 S_ADDER4_0 (.A(a[3:0]), .B(b[3:0]), .c_in(cin), .S(s[3:0]), .c_out(c4));
	SELECT_ADDER4 S_ADDER4_1 (.A(a[7:4]), .B(b[7:4]), .c_in(c4), .S(s[7:4]), .c_out(c8));
	SELECT_ADDER4 S_ADDER4_2 (.A(a[11:8]), .B(b[11:8]), .c_in(c8), .S(s[11:8]), .c_out(c12));
	SELECT_ADDER4 S_ADDER4_3 (.A(a[15:12]), .B(b[15:12]), .c_in(c12), .S(s[15:12]), .c_out(cout));

endmodule
