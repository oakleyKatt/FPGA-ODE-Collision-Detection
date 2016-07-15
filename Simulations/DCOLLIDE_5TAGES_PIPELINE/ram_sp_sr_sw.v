//-----------------------------------------------------
// Design Name : ram_sp_sr_sw
// File Name   : ram_sp_sr_sw.v
// Function    : Synchronous read write RAM 
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module ram_sp_sr_sw (
clk         , // Clock Input
addressin     , // Address Input
addressout     , // Address Input
datain      , // Data bi-directional
dataout0     , // Data bi-directional
dataout1     , // Data bi-directional
dataout2     , // Data bi-directional
dataout3     , // Data bi-directional
dataout4     , // Data bi-directional
dataout5     , // Data bi-directional
dataout6     , // Data bi-directional
dataout7     , // Data bi-directional
cs          , // Chip Select
we          , // Write Enable/Read Enable
oe          ,  // Output Enable
fm          ,  // Full memoy
write_done
); 

parameter DATA_WIDTH = 32 ;
parameter ADDR_WIDTH = 32 ;
parameter RAM_DEPTH = 96; //1 << ADDR_WIDTH;

//--------------Input Ports----------------------- 
input                  clk         ;
input [ADDR_WIDTH-1:0] addressin     ;
input [ADDR_WIDTH-1:0] addressout     ;
input                  cs          ;
input                  we          ;
input                  oe          ; 

//--------------Inout Ports----------------------- 
input [DATA_WIDTH-1:0]  datain       ;
output [DATA_WIDTH-1:0]  dataout0       ;
output [DATA_WIDTH-1:0]  dataout1       ;
output [DATA_WIDTH-1:0]  dataout2       ;
output [DATA_WIDTH-1:0]  dataout3       ;
output [DATA_WIDTH-1:0]  dataout4       ;
output [DATA_WIDTH-1:0]  dataout5       ;
output [DATA_WIDTH-1:0]  dataout6       ;
output [DATA_WIDTH-1:0]  dataout7       ;
output fm;
output reg write_done = 1'b0;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out0 ;
reg [DATA_WIDTH-1:0] data_out1 ;
reg [DATA_WIDTH-1:0] data_out2 ;
reg [DATA_WIDTH-1:0] data_out3 ;
reg [DATA_WIDTH-1:0] data_out4 ;
reg [DATA_WIDTH-1:0] data_out5 ;
reg [DATA_WIDTH-1:0] data_out6 ;
reg [DATA_WIDTH-1:0] data_out7 ;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg                  oe_r;

wire [31:0] addressshift;
assign addressshift = addressout*8;
//--------------Code Starts Here------------------ 

// Tri-State Buffer control 
// output : When we = 0, oe = 1, cs = 1
assign dataout0 = (cs && oe && !we) ? data_out0 : 8'bz; 
assign dataout1 = (cs && oe && !we) ? data_out1 : 8'bz; 
assign dataout2 = (cs && oe && !we) ? data_out2 : 8'bz; 
assign dataout3 = (cs && oe && !we) ? data_out3 : 8'bz; 
assign dataout4 = (cs && oe && !we) ? data_out4 : 8'bz; 
assign dataout5 = (cs && oe && !we) ? data_out5 : 8'bz; 
assign dataout6 = (cs && oe && !we) ? data_out6 : 8'bz; 
assign dataout7 = (cs && oe && !we) ? data_out7 : 8'bz; 
assign fm = 1'b1;


initial
begin
	 mem[0] <= 32'hbefc475e;
	 mem[1] <= 32'h00000000;
	 mem[2] <= 32'h3fc00000;
	 mem[3] <= 32'h3f000000;
	 mem[4] <= 32'h3efc475e;
	 mem[5] <= 32'h00000000;
	 mem[6] <= 32'h3fc00000;
	 mem[7] <= 32'h3f000000;
	 mem[8] <= 32'hbefc475e;
	 mem[9] <= 32'h00000000;
	mem[10] <= 32'h3fc00000;
	mem[11] <= 32'h3f000000;
	mem[12] <= 32'h3efc475e;
	mem[13] <= 32'h00000000;
	mem[14] <= 32'h3fc00000;
	mem[15] <= 32'h3f000000;
	mem[16] <= 32'hc0135b9a;
	mem[17] <= 32'hbe860d02;
	mem[18] <= 32'h40800000;
	mem[19] <= 32'h3f000000;
	mem[20] <= 32'hbfa9458d;
	mem[21] <= 32'h3c41a049;
	mem[22] <= 32'h40800000;
	mem[23] <= 32'h3f000000;
	mem[24] <= 32'h3f5fec9a;
	mem[25] <= 32'h3e800000;
	mem[26] <= 32'h40800000;
	mem[27] <= 32'h3f000000;
	mem[28] <= 32'hbde9a134;
	mem[29] <= 32'h3edfdfa0;
	mem[30] <= 32'h40800000;
	mem[31] <= 32'h3f000000;
	mem[32] <= 32'h3f562542;
	mem[33] <= 32'h3e800000;
	mem[34] <= 32'h40800000;
	mem[35] <= 32'h3f000000;
	mem[36] <= 32'hbda4e37a;
	mem[37] <= 32'h3ee5ec81;
	mem[38] <= 32'h40800000;
	mem[39] <= 32'h3f000000;
	mem[40] <= 32'h3f5d1f71;
	mem[41] <= 32'h3e76a876;
	mem[42] <= 32'h40800000;
	mem[43] <= 32'h3f000000;
	mem[44] <= 32'hbde630ec;
	mem[45] <= 32'h3ef0a548;
	mem[46] <= 32'h40800000;
	mem[47] <= 32'h3f000000;
	mem[48] <= 32'h00000000;
	mem[49] <= 32'h00000000;
	mem[50] <= 32'h00000000;
	mem[51] <= 32'h00000000;
	mem[52] <= 32'h00000000;
	mem[53] <= 32'h00000000;
	mem[54] <= 32'h00000000;
	mem[55] <= 32'h00000000;
	mem[56] <= 32'h00000000;
	mem[57] <= 32'h00000000;
	mem[58] <= 32'h00000000;
	mem[59] <= 32'h00000000;	
	mem[60] <= 32'h00000000;
	mem[61] <= 32'h00000000;
	mem[62] <= 32'h00000000;
	mem[63] <= 32'h00000000;
	mem[64] <= 32'h00000000;
	mem[65] <= 32'h00000000;
	mem[66] <= 32'h00000000;
	mem[67] <= 32'h00000000;
	mem[68] <= 32'h00000000;
	mem[69] <= 32'h00000000;
	mem[70] <= 32'h00000000;
	mem[71] <= 32'h00000000;
	mem[72] <= 32'h00000000;
	mem[73] <= 32'h00000000;
	mem[74] <= 32'h00000000;
	mem[75] <= 32'h00000000;
	mem[76] <= 32'h00000000;
	mem[77] <= 32'h00000000;
	mem[78] <= 32'h00000000;
	mem[79] <= 32'h00000000;
	mem[80] <= 32'h00000000;
	mem[81] <= 32'h00000000;
	mem[82] <= 32'h00000000;
	mem[83] <= 32'h00000000;
	mem[84] <= 32'h00000000;
	mem[85] <= 32'h00000000;
	mem[86] <= 32'h00000000;
	mem[87] <= 32'h00000000;
	mem[88] <= 32'h00000000;
	mem[89] <= 32'h00000000;
	mem[90] <= 32'h00000000;
	mem[91] <= 32'h00000000;
	mem[92] <= 32'h00000000;
	mem[93] <= 32'h00000000;
	mem[94] <= 32'h00000000;
	mem[95] <= 32'h00000000;
end

// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && we) begin
       mem[addressin] = datain;
		 write_done = 1'b1;
   end else
	begin
		 write_done = 1'b0;
	end
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
  if (cs && !we && oe) begin
   data_out0 = mem[addressout];
	data_out1 = mem[addressout+1];
	data_out2 = mem[addressout+2];
	data_out3 = mem[addressout+3];
	data_out4 = mem[addressout+4];
	data_out5 = mem[addressout+5];
	data_out6 = mem[addressout+6];
	data_out7 = mem[addressout+7];
    oe_r = 1;
  end else begin
    oe_r = 0;
  end
end

endmodule // End of Module ram_sp_sr_sw
