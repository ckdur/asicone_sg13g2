module mand # (
    parameter W=4
)
(
    input [W-1:0] a,
    input [W-1:0] b,
    output [W-1:0] c
);

    assign c = a & b;
endmodule
