`timescale 1ns/10ps

module cpustim;
	logic clk, reset;
	
	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);
	
    parameter CLOCK_PERIOD = 50000000;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk;
    end
	 
	 cpu dut (.clk, .reset);
	 
	 integer i;
	 
	 initial begin
		@(posedge clk) reset <= 0;
		@(posedge clk) reset <= 1;
		@(posedge clk);
		@(posedge clk) reset <= 0;
		for (i = 0; i < 2000; i++) begin
			@(posedge clk);
		end
		
		$stop;
	 end
	 
	
endmodule