module TotalALU (
    input  [7:0] A,          // Input A
    input  [7:0] B,          // Input B
    input  [4:0] OpCode,     // Expanded to 5 bits (oc1-oc5)
    input        Cin,        // Carry In
    output reg [7:0] Result, // ALU Output
    output reg Cout,         // Carry Out
    output reg V,            // Overflow Flag
    output     Z,            // Zero Flag
    output     N             // Negative Flag
);

    assign Z = (Result == 8'b0);
    assign N = Result[7];

    always @(*) begin
        Cout = 0;
        V = 0;
        Result = 8'b0;

        case (OpCode)
            // Original 16 Operations
            5'b00000: {Cout, Result} = A + B;             // ADD
            5'b00001: {Cout, Result} = A + B + Cin;       // ADC
            5'b00010: {Cout, Result} = A - B;             // SUB
            5'b00011: {Cout, Result} = A - B - Cin;       // SBB
            5'b00100: Result = ~A;                        // ONC
            5'b00101: Result = -A;                        // TWC
            5'b00110: Result = A & B;                     // AND
            5'b00111: Result = A | B;                     // OR
            5'b01000: Result = A ^ B;                     // XOR
            5'b01001: {Cout, Result} = {A, 1'b0};         // LSL
            5'b01010: {Result, Cout} = {1'b0, A};         // LSR
            5'b01011: {Result, Cout} = {A[7], A};         // ASR
            5'b01100: Result = {A[6:0], A[7]};            // ROL
            5'b01101: Result = {A[0], A[7:1]};            // ROR
            5'b01110: {Cout, Result} = {A, Cin};          // RCL
            5'b01111: {Result, Cout} = {Cin, A};          // RCR
            5'b10000: Result = ~(A ^ B);                  // XNOR (Equivalence)

            default: Result = 8'b0;
        endcase

        // Overflow Logic (ADD/ADC/SUB/SBB)
        if (OpCode[4:2] == 3'b000) begin
            if (OpCode[1:0] < 2'b10) // Addition
                V = (A[7] == B[7]) && (Result[7] != A[7]);
            else // Subtraction
                V = (A[7] != B[7]) && (Result[7] != A[7]);
        end
    end
endmodule