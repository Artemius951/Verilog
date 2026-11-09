`timescale 1ns/1ps

module tb_timer_pwm;
    logic clk, rst, enable, tick, pwm;
    logic [15:0] period, duty;

    timer_pwm #(.W(16)) dut (
        .clk(clk), .rst(rst), .enable(enable),
        .period(period), .duty(duty),
        .tick(tick), .pwm(pwm)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task wait_ticks(int n);
        repeat(n) @(posedge clk);
    endtask

    initial begin
        rst = 1; enable = 0; period = 5; duty = 2;
        wait_ticks(2);
        rst = 0;

        period = 1; duty = 0; enable = 1;
        wait_ticks(5);

        duty = 1;
        wait_ticks(5);

        period = 5; duty = 10;
        wait_ticks(10);


        period = 5; duty = 2;
        wait_ticks(25);


        period = 3; duty = 1;
        wait_ticks(15);

        $finish;
    end

    int cycles = 0;
    int pwm_high = 0;

   always @(posedge clk) begin
        if (rst || !enable) begin
            cycles = 0;
            pwm_high = 0;
        end else begin
            if (pwm) pwm_high++; 
            
            if (tick) begin
                $display("Time=%0t: Period=%0d тактов, PWM_high=%0d тактов", $time, cycles + 1, pwm_high);
                cycles = 0;
                pwm_high = 0;
            end else begin
                cycles++;
            end
        end
    end

endmodule