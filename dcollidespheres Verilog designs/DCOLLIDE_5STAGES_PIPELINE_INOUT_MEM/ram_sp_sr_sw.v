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
parameter RAM_DEPTH = 32; //1 << ADDR_WIDTH;

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
assign fm = (addressin >= (RAM_DEPTH-1) & ~(addressin == 32'd4294967295)) ? 1:0;

jtag_debug jtag2(.in_debug(mem[0]));
jtag_debug jtag3(.in_debug(mem[1]));
jtag_debug jtag4(.in_debug(mem[2]));
jtag_debug jtag5(.in_debug(mem[3]));
jtag_debug jtag6(.in_debug(mem[4]));
jtag_debug jtag7(.in_debug(mem[5]));
jtag_debug jtag8(.in_debug(mem[6]));
jtag_debug jtag9(.in_debug(mem[7]));
jtag_debug jtag22(.in_debug(mem[8]));
jtag_debug jtag32(.in_debug(mem[9]));
jtag_debug jtag42(.in_debug(mem[10]));
jtag_debug jtag52(.in_debug(mem[11]));
jtag_debug jtag62(.in_debug(mem[12]));
jtag_debug jtag72(.in_debug(mem[13]));
jtag_debug jtag82(.in_debug(mem[14]));
jtag_debug jtag92(.in_debug(mem[15]));

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
