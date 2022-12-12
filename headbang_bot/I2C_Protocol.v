module i2c_protocol
(
	input clk, reset, ignition,
	input [15:0] MUX_input,	
	inout SDIN,
	output reg finish_flag,
	output reg [2:0] ACK,
	output reg SCLK
);

reg [13:0] counter;		//to generate 2.5kHz clock
reg [4:0] tick_counter; //to measure number of clock ticks 
reg serial_data, start_condition, out;

assign SDIN = (out) ? serial_data : 1'bz;

// Design structure:
// state:0 start condition
// state:1 send 0x34 address
// state:2 wait for ACK
// state:3 send register address
// state:4 wait for ACK
// state:5 send data to registers
//	state:6 wait for ACK
// state:7 stop conition

//	clock generation and number of clock ticks
always @(posedge clk) begin
	if (!reset) begin
		counter <= 0;
		SCLK <= 1;		//SCLK idle condition
	end 
	else if (start_condition && ignition) begin //if start bit is recieved initiate starting procedures 
		counter <= counter + 1;
		if (counter <= 9999) SCLK <= 1; 		   	//9999
		else if (counter == 19999) counter <= 0;	//19999
		else if (tick_counter == 29) SCLK <= 1;
		else SCLK <= 0;
	end
	else if (ignition == 0) counter <= 0;
	else SCLK <= 1; 
end

always @(negedge SCLK) begin // was SCLK 
	if(!reset) tick_counter <= 0;
	else begin
		tick_counter <= tick_counter + 1;
		if (tick_counter == 28) tick_counter <= 0; // 28 clock cycles needed to complete configuration cycle from I2C bus
	end
end

always @(posedge clk) begin
	if (tick_counter == 9 || tick_counter == 18 || tick_counter == 27) out <= 0; // ACK ticks
	else out <= 1;
end

always @(posedge clk) begin
		case(tick_counter)
			0: begin //SDIN will be high for 60us then low until SCLK goes high
				ACK <= 3'b000;
				finish_flag <= 0;
				start_condition <= 1;
				serial_data <= 1;	//SDIN idle condition
				if (counter > 3000) serial_data <= 0; // was 3000
			end
			1: begin //push 0x34 address through I2C data bus, 0x34 = 00110100
				serial_data <= 0;
			end
			2: begin
				serial_data <= 0;
			end
			3: begin
				serial_data <= 1;
			end
			4: begin
				serial_data <= 1;
			end
			5: begin
				serial_data <= 0;
			end
			6: begin
				serial_data <= 1;
			end
			7: begin
				serial_data <= 0;
			end
			8: begin
				serial_data <= 0;
			end
			9: begin
				ACK[0] <= !SDIN;
			end
			10: begin
				serial_data <= MUX_input[15];
			end
			11: begin
				serial_data <= MUX_input[14];
			end
			12: begin
				serial_data <= MUX_input[13];
			end
			13: begin
				serial_data <= MUX_input[12];
			end
			14: begin
				serial_data <= MUX_input[11];
			end
			15: begin
				serial_data <= MUX_input[10];
			end
			16: begin
				serial_data <= MUX_input[9];
			end
			17: begin
				serial_data <= MUX_input[8];
			end
			18: begin
				ACK[1] <= !SDIN;
			end
			19: begin
				serial_data <= MUX_input[7];
			end
			20: begin
				serial_data <= MUX_input[6];
			end
			21: begin
				serial_data <= MUX_input[5];
			end
			22: begin
				serial_data <= MUX_input[4];
			end
			23: begin
				serial_data <= MUX_input[3];
			end
			24: begin
				serial_data <= MUX_input[2];
			end
			25: begin
				serial_data <= MUX_input[1];
			end
			26: begin
				serial_data <= MUX_input[0];
			end	
			27: begin
				ACK[2] <= !SDIN;
			end
			28: begin
				serial_data <= 0;
				finish_flag <= 1;
				if (counter > 3000 && SCLK == 1 /*|| counter == 0*/) serial_data <= 1;
			end
		endcase
	end
	
endmodule