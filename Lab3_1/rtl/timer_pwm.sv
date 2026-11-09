module timer_pwm #(
    parameter int W = 16
) (
    input  logic         clk,
    input  logic         rst,
    input  logic         enable,
    input  logic [W-1:0] period,
    input  logic [W-1:0] duty,
    output logic         tick,
    output logic         pwm
);

    logic [W-1:0] counter;
    logic [W-1:0] period_eff;
    logic [W-1:0] duty_eff;

    assign period_eff = (period < 1) ? 1 : period;
    assign duty_eff   = (duty > period_eff) ? period_eff : duty;

    always_ff @(posedge clk) begin
        if (rst || !enable) begin
            counter <= 0;
            tick    <= 0;
            pwm     <= 0;
        end else begin
            tick <= 0;
            if (counter == period_eff - 1) begin
                counter <= 0;
                tick    <= 1;
            end else begin
                counter <= counter + 1;
            end
            
            if (counter < duty_eff)
                pwm <= 1;
            else
                pwm <= 0;
        end
    end

endmodule