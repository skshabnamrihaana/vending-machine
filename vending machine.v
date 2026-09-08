

module vending_machine (
    input clk,
    input reset,
    input coin_5,
    input coin_10,
    input vend,
    output reg dispense,
    output reg change
);

    parameter S0  = 2'b00; // 0 cents
    parameter S5  = 2'b01; // 5 cents
    parameter S10 = 2'b10; // 10 cents
    parameter S15 = 2'b11; // 15 cents (ready)

    reg [1:0] state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        dispense = 0;
        change = 0;

        case (state)
            S0: begin
                if (coin_5) next_state = S5;
                else if (coin_10) next_state = S10;
            end
            S5: begin
                if (coin_5) next_state = S10;
                else if (coin_10) next_state = S15;
            end
            S10: begin
                if (coin_5) next_state = S15;
                else if (coin_10) begin
                    next_state = S0;
                    change = 1; // 20 cents inserted, give 5c change
                end
            end
            S15: begin
                if (vend) begin
                    dispense = 1;
                    next_state = S0;
                end
            end
        endcase
    end
endmodule

   
