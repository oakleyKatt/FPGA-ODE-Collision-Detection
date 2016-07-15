//-----------------------------------------------------
// Design Name : ram_sp_sr_sw
// File Name   : ram_sp_sr_sw.v
// Function    : Synchronous read write RAM 
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module ram_sp_sr_sw_7_outputs (
clk         , // Clock Input
addressin     , // Address Input
addressout     , // Address Input
datain0     , // Data bi-directional
datain1     , // Data bi-directional
datain2     , // Data bi-directional
datain3     , // Data bi-directional
datain4     , // Data bi-directional
datain5     , // Data bi-directional
datain6     , // Data bi-directional
dataout      , // Data bi-directional
cs          , // Chip Select
we          , // Write Enable/Read Enable
oe          ,  // Output Enable
fm            // Full memory
); 

parameter DATA_WIDTH = 32 ;
parameter ADDR_WIDTH = 32 ;
parameter RAM_DEPTH = 84;

//--------------Input Ports----------------------- 
input                  clk         ;
input [ADDR_WIDTH-1:0] addressin   ;
input [ADDR_WIDTH-1:0] addressout  ;
input                  cs          ;
input                  we          ;
input                  oe          ; 

//--------------Inout Ports----------------------- 
input [DATA_WIDTH-1:0]  datain0       ;
input [DATA_WIDTH-1:0]  datain1       ;
input [DATA_WIDTH-1:0]  datain2       ;
input [DATA_WIDTH-1:0]  datain3       ;
input [DATA_WIDTH-1:0]  datain4       ;
input [DATA_WIDTH-1:0]  datain5       ;
input [DATA_WIDTH-1:0]  datain6       ;
output[DATA_WIDTH-1:0]  dataout       ;
output fm;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg                  oe_r;
reg [31:0] counter = 0;

wire [31:0] addressshift;
assign addressshift = addressout;
//--------------Code Starts Here------------------ 

/*
// Tri-State Buffer control 
// output : When we = 0, oe = 1, cs = 1
assign datain0 = (cs && oe && !we) ? data_in0 : 8'bz; 
assign datain1 = (cs && oe && !we) ? data_in1 : 8'bz; 
assign datain2 = (cs && oe && !we) ? data_in2 : 8'bz; 
assign datain3 = (cs && oe && !we) ? data_in3 : 8'bz; 
assign datain4 = (cs && oe && !we) ? data_in4 : 8'bz; 
assign datain5 = (cs && oe && !we) ? data_in5 : 8'bz; 
assign datain6 = (cs && oe && !we) ? data_in6 : 8'bz; 
assign fm = (addressin >= 32'd31) ? 1:0;
*/

assign dataout = (cs && oe && !we) ? data_out : 8'bz;

/*
// Memory Write Block 
// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && we) begin
       mem[addressin] = dataout;
   end
end
*/

//jtag_debug jtag2(.in_debug(mem[0]));
//jtag_debug jtag3(.in_debug(mem[1]));
//jtag_debug jtag4(.in_debug(mem[2]));
//jtag_debug jtag5(.in_debug(mem[3]));
//jtag_debug jtag6(.in_debug(mem[4]));
//jtag_debug jtag7(.in_debug(mem[5]));
//jtag_debug jtag8(.in_debug(mem[6]));
//jtag_debug jtag9(.in_debug(mem[7]));
//jtag_debug jtag22(.in_debug(mem[8]));
//jtag_debug jtag32(.in_debug(mem[9]));
//jtag_debug jtag42(.in_debug(mem[10]));
//jtag_debug jtag52(.in_debug(mem[11]));
//jtag_debug jtag62(.in_debug(mem[12]));
//jtag_debug jtag72(.in_debug(mem[13]));
//jtag_debug jtag82(.in_debug(mem[14]));
//jtag_debug jtag92(.in_debug(mem[15]));

always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && we) begin
       mem[addressin] 		 = datain0;
	   mem[addressin + 6'd1] = datain1;
	   mem[addressin + 6'd2] = datain2;
	   mem[addressin + 6'd3] = datain3;
	   mem[addressin + 6'd4] = datain4;
	   mem[addressin + 6'd5] = datain5;
	   mem[addressin + 6'd6] = datain6;
		counter = counter + 1;
   end
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
  if (cs && !we && oe) begin
    data_out = mem[addressshift];
    oe_r = 1;
  end else begin
    oe_r = 0;
  end
end

endmodule // End of Module ram_sp_sr_sw
