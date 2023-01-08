module audio_codec
(
	input clk,reset,play,
	inout SDIN,
	output SCLK,USB_clk,BCLK,
	output reg DAC_LR_CLK, ADC_LR_CLK,
	output DAC_DATA,
	input ADC_DATA,
	output [2:0] ACK_LEDR,
	output reg [31:0] ADC_DATA_Combined
);

reg [3:0] counter; //selecting register address and its corresponding data
reg counting_state, ignition, read_enable; 	
reg [15:0] MUX_input;
reg [4:0] DAC_LR_CLK_counter;
reg [4:0] ADC_LR_CLK_counter;
reg [31:0] ADC_DATA_Combined_temp;

wire finish_flag;

assign DAC_DATA = play ? ADC_DATA : 0;

i2c_protocol i2c
(
	.clk(clk),
	.reset(reset),
	.ignition(ignition),
	.MUX_input(MUX_input),
	.ACK(ACK_LEDR),
	.SDIN(SDIN),
	.finish_flag(finish_flag),
	.SCLK(SCLK)
);

USB_Clock_PLL	USB_Clock_PLL_inst
(
	.inclk0(clk),
	.c0(USB_clk),
	.c1(BCLK)
);

always @(negedge BCLK) begin
	if(read_enable) begin
		if (DAC_LR_CLK_counter == 31) DAC_LR_CLK <= 1;
		else DAC_LR_CLK <= 0;
	end
end
	
always @(posedge BCLK) begin
	if(read_enable) begin
		DAC_LR_CLK_counter <= DAC_LR_CLK_counter + 1;
	end
end

always @(negedge BCLK) begin
	if(read_enable) begin
		if (ADC_LR_CLK_counter == 31) begin
			ADC_LR_CLK <= 1;
			ADC_DATA_Combined <= ADC_DATA_Combined_temp;
		end else begin
			ADC_LR_CLK <= 0;
		end
	end
end
	
always @(posedge BCLK) begin
	if(read_enable) begin
		ADC_LR_CLK_counter <= ADC_LR_CLK_counter + 1;
		ADC_DATA_Combined_temp[ADC_LR_CLK_counter] <= ADC_DATA;
	end
end


// generate 6 configuration pulses 
always @(posedge clk)
	begin
	if(!reset)
		begin
		counting_state <= 0;
		read_enable <= 0;
		end
	else
		begin
		case(counting_state)
		0:
			begin
			ignition <= 1;
			read_enable <= 0;
			if(counter == 10) counting_state <= 1; //was 8
			end
		1:
			begin
			read_enable <= 1;
			ignition <= 0;
			end
		endcase
		end
end

// this counter is used to switch between registers
always @(posedge SCLK) begin
	case(counter) //MUX_input[15:9] register address, MUX_input[8:0] register data
		0: MUX_input <= 16'h1201; // Activate control
		1: MUX_input <= 16'h0000; // Left line in
		2: MUX_input <= 16'h0200; // Right line in
		3: MUX_input <= 16'h047F; // Left headphone out
		4: MUX_input <= 16'h067F; // Right headphone out
		5: MUX_input <= 16'h0812; // Analogue audio path control
		6: MUX_input <= 16'h0A07; // Digital audio path control
		7: MUX_input <= 16'h0C02; // Power down control
		8: MUX_input <= 16'h0E23; // Digital audio interface format
		9: MUX_input <= 16'h1001; // Sampling control
	endcase
end

always @(posedge finish_flag)	begin
	counter <= counter + 1;
end

endmodule 