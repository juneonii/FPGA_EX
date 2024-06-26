//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module watch #
(
	// Users to add parameters here

	// User parameters ends
	// Do not modify the parameters beyond this line


	// Parameters of Axi Slave Bus Interface S00_AXI
	parameter integer C_S00_AXI_DATA_WIDTH	= 32,
	parameter integer C_S00_AXI_ADDR_WIDTH	= 4
)
(
	// (lab3) Users to add ports here
    input [1:0] sw,  // enable
    output [3:0] led, // blink each sec, min, hour 

	// User ports ends
	// Do not modify the ports beyond this line


	// Ports of Axi Slave Bus Interface S00_AXI
	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready
);

	wire [31:0] w_freq;
	wire [31:0] w_time;
	wire [31:0] w_day;
// Instantiation of Axi Bus Interface S00_AXI
	myip_v1_0 # ( 
		.C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myip_v1_0_inst (

		// (lab3) Users to add ports here
		.o_freq(w_freq),
		.i_time(w_time),
		.i_day(w_day),

		.s00_axi_aclk	(s00_axi_aclk	),
		.s00_axi_aresetn(s00_axi_aresetn),
		.s00_axi_awaddr	(s00_axi_awaddr	),
		.s00_axi_awprot	(s00_axi_awprot	),
		.s00_axi_awvalid(s00_axi_awvalid),
		.s00_axi_awready(s00_axi_awready),
		.s00_axi_wdata	(s00_axi_wdata	),
		.s00_axi_wstrb	(s00_axi_wstrb	),
		.s00_axi_wvalid	(s00_axi_wvalid	),
		.s00_axi_wready	(s00_axi_wready	),
		.s00_axi_bresp	(s00_axi_bresp	),
		.s00_axi_bvalid	(s00_axi_bvalid	),
		.s00_axi_bready	(s00_axi_bready	),
		.s00_axi_araddr	(s00_axi_araddr	),
		.s00_axi_arprot	(s00_axi_arprot	),
		.s00_axi_arvalid(s00_axi_arvalid),
		.s00_axi_arready(s00_axi_arready),
		.s00_axi_rdata	(s00_axi_rdata	),
		.s00_axi_rresp	(s00_axi_rresp	),
		.s00_axi_rvalid	(s00_axi_rvalid	),
		.s00_axi_rready	(s00_axi_rready	)
	);

localparam P_COUNT_BIT = 30; // (default) 30b, under 1GHz. 2^30 = 1073741824
localparam P_SEC_BIT	 = 6; // 2^6 = 64
localparam P_MIN_BIT	 = 6; // 2^6 = 64 
localparam P_HOUR_BIT = 5; // 2^5 = 32 
localparam P_DAY_BIT = 9; // 2^9 = 512 > 365
localparam P_YEAR_BIT =  12; //2^12 = 4096 > 2024 I guess I'll die before 4096


wire clk = s00_axi_aclk;
wire i_run_en = sw[0];
wire [P_COUNT_BIT-1:0] 	i_freq = w_freq[P_COUNT_BIT-1:0];
wire [P_SEC_BIT-1:0]	o_sec;
wire [P_MIN_BIT-1:0]	o_min;
wire [P_HOUR_BIT-1:0]	o_hour;
wire [P_DAY_BIT-1:0]	o_day;
wire [P_YEAR_BIT-1:0]	o_year;

assign w_time = {15'b0, o_hour, o_min, o_sec};
assign w_day = {11'b0, o_year, o_day};

assign led[0] = o_hour[0];
assign led[1] = o_day[0];
assign led[2] = o_year[0];

reg reset;
always @(posedge clk) begin
	reset <= !s00_axi_aresetn;
end

watch_top 
# (
	.P_COUNT_BIT	(P_COUNT_BIT),
	.P_SEC_BIT	 	(P_SEC_BIT	),
	.P_MIN_BIT	 	(P_MIN_BIT	),
	.P_HOUR_BIT		(P_HOUR_BIT	),
	.P_DAY_BIT		(P_DAY_BIT),
	.P_YEAR_BIT		(P_YEAR_BIT)
) u_watch_top(
	.clk 				(clk),
	.reset 				(reset),
	.i_run_en			(i_run_en),
	.i_freq				(i_freq),
    .o_sec				(o_sec ),
    .o_min				(o_min ),
    .o_hour				(o_hour),
    .o_day				(o_day),
    .o_year				(o_year)
);

endmodule
