`timescale 1ns / 1ps

module TotalALU_tb;
    reg [7:0] A;
    reg [7:0] B;
    reg [4:0] OpCode;
    reg Cin;

    wire [7:0] Result;
    wire Cout, V, Z, N;

    TotalALU uut (
        .A(A), 
        .B(B), 
        .OpCode(OpCode), 
        .Cin(Cin),
        .Result(Result), 
        .Cout(Cout), 
        .V(V), 
        .Z(Z), 
        .N(N)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, TotalALU_tb);

        $display("Time\t Op\t A\t B\t Res\t C V Z N");
        $monitor("%0t\t %b\t %h\t %h\t %h\t %b %b %b %b", $time, OpCode, A, B, Result, Cout, V, Z, N);

        A = 8'h0A; B = 8'h05; OpCode = 5'b00000; Cin = 0; #10;
        A = 8'h7F; B = 8'h01; OpCode = 5'b00000; Cin = 0; #10;
        A = 8'hFF; B = 8'h0F; OpCode = 5'b00110; #10;
        A = 8'b10101010; B = 8'b11110000; OpCode = 5'b10000; #10;
        A = 8'hAA; B = 8'hAA; OpCode = 5'b10000; #10;
        A = 8'h80; Cin = 1; OpCode = 5'b01110; #10;

        $display("Simulation Finished");
        $finish;
    end
endmodule