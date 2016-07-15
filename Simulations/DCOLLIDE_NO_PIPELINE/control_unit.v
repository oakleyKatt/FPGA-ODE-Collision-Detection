//This is complex but it does stuff.
module control_unit (
	in_out0,
	in_out1,
	in_out2,
	in_out3,
	in_out4,
	in_out5,
	in_out6,
	in_out7,
	rst,
	clk,
	done,
	rstmaster,
	rdyData,
	rst_out,
	oe,
	addressin_in,
	wein,
	addressout,
	weout,
	addressin_out,
	out0,
	out1,
	out2,
	out3,
	out4,
	out5,
	out6,
	out7
);

parameter memory_depth = 256 ;

input [31:0] in_out0;
input [31:0] in_out1;
input [31:0] in_out2;
input [31:0] in_out3;
input [31:0] in_out4;
input [31:0] in_out5;
input [31:0] in_out6;
input [31:0] in_out7;
input rstmaster;
input rdyData;
output reg [31:0] out0;
output reg [31:0] out1;
output reg [31:0] out2;
output reg [31:0] out3;
output reg [31:0] out4;
output reg [31:0] out5;
output reg [31:0] out6;
output reg [31:0] out7;
input rst;
input clk;
input done;

output reg rst_out = 1'b1;
output reg oe;
output reg [31:0] addressin_in = 32'd0;
output reg 	wein;
output reg signed [31:0] addressout = -32'd7;
output reg 	weout;
output reg [31:0] addressin_out = 32'd0;

reg [3:0] state = 4'd4;
reg [3:0] next_state = 4'd4;

reg flag_increase = 1'b0;
reg flag_increase2 = 1'b0;

reg [5:0] counter = 6'd0;
reg [5:0] counter2 = 6'd0;
reg flagRst = 1'b0;
reg flagRst2 = 1'b0;
//Goes from state to next_state
always @(posedge clk or negedge rstmaster)
begin
	if(rstmaster == 1'b0)
	begin
		state <= 0;
	end else
	begin
		state <= next_state;
	end
end

//Decides next state
always @(posedge clk)
begin
	case(state)
		0:
		begin
			if(rst == 0 & done == 1 & rdyData == 1)
			begin
				next_state = 4'd1;
			end else
			begin
				next_state = 4'd0;
			end
		end
		1:
		begin
			if(rst == 0 & done == 1 & rdyData == 0)
			begin
				next_state = 4'd2;
			end else
			begin
				next_state = 4'd1;
			end
		end
		2:
		begin
			if(rst == 0 & done == 1 & rdyData == 0)
			begin
				next_state = 4'd3;
			end else
			begin
				next_state = 4'd2;
			end
		end
		3:
		begin
			if(rst == 0 & done == 1 & rdyData == 0)
			begin
				//if(address < memory_depth)
				//begin
				//	next_state = 4'd4;
				//end
				next_state = 4'd4;
			end else
			begin
				next_state = 4'd3;
			end
		end
		4:
		begin
			if(rst == 1 & done == 1)
			begin
				next_state = 4'd5;
			end else
			begin
				if(rst == 0 & done == 1 & rdyData == 1)
				begin
					next_state = 4'd1;
				end else
				begin
					next_state = 4'd4;
				end
			end
		end
		5:
		begin
			if(rst == 1 & done == 0)
			begin
				next_state = 4'd6;
			end else
			begin
				next_state = 4'd5;
			end
		end
		6:
		begin
			if(rst == 1 & done == 1)
			begin
				next_state = 4'd7;
			end else
			begin
				next_state = 4'd6;
			end
		end
		7:
		begin
			if(rst == 1 & done == 1)
			begin
				if(addressin_out < memory_depth)
				begin
					next_state = 4'd8;
				end
			end else
			begin
				next_state = 4'd7;
			end
		end
		8:
		begin
			if(rst == 1 & done == 1)
			begin
				next_state = 4'd5;
			end else
			begin
				next_state = 4'd8;
			end
		end
	endcase
end

//Decides what happens during each state
always @(posedge clk or negedge rstmaster)
begin
	if(rstmaster == 1'b0)
	begin
		rst_out <= 1;
		oe <= 0;
		addressin_in <= addressin_in;
		wein <= 0;
		addressout <= addressout;
		weout <= 0;
		addressin_out <= addressin_out;
	end else
	begin
		case (state)
			0:
			begin
				rst_out <= 1;
				oe <= 0;
				addressin_in <= addressin_in;
				wein <= 0;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			1:
			begin
				rst_out <= 1;
				oe <= 0;
				addressin_in <= addressin_in;
				wein <= 1;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
				flag_increase <= 1'b0;
			end
			2:
			begin
				rst_out <= 1;
				oe <= 0;
				addressin_in <= addressin_in;
				wein <= 1;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			3:
			begin
				rst_out <= 1;
				oe <= 0;
				addressin_in <= addressin_in;
				wein <= 1;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			4:
			begin
				rst_out <= 1;
				oe <= 0;
				if(rst == 1'b0 && flag_increase == 1'b0)
				begin
					addressin_in <= addressin_in + 1;
					flag_increase <= 1'b1;
				end else
				begin
					addressin_in <= addressin_in;
				end
				wein <= 0;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			5:
			begin
				rst_out <= 0;
				oe <= 1;
				addressin_in <= addressin_in;
				wein <= 0;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			6:
			begin
				rst_out <= 1;
				oe <= 1;
				addressin_in <= addressin_in;
				wein <= 0;
				addressout <= addressout;
				weout <= 0;
				addressin_out <= addressin_out;
			end
			7:
			begin
				rst_out <= 1;
				if(flag_increase == 1'b0 && addressin_out < memory_depth)
				begin
					addressin_out <= addressin_out + 8;
					flag_increase <= 1'b1;
					addressout <= addressout + 7;
				end
				oe <= 1;
				addressin_in <= addressin_in;
				out0 <= in_out0;
				out1 <= in_out1;
				out2 <= in_out2;
				out3 <= in_out3;
				out4 <= in_out4;
				out5 <= in_out5;
				out6 <= in_out6;
				out7 <= in_out7;
				wein <= 0;
				weout <= 0;
			end
			8:
			begin
				flag_increase <= 1'b0;
				rst_out <= 1;
				oe <= 1;
				addressin_in <= addressin_in;
				wein <= 0;
				addressout <= addressout;
				weout <= 1;
				addressin_out <= addressin_out;
			end
		endcase
	end

end
endmodule
