// *******************
// Control Unit Module
// *******************
module inputdata (clk, rst, loaddata, inputdata_ready, boton, data, seg1, seg2, seg3, seg4);
	input logic  clk, rst, boton;
	input logic [7:0] data;
	output logic  loaddata;
	output logic [6:0]seg1, seg2, seg3, seg4;
	input logic inputdata_ready;
	logic senal, reset;
	logic [7:0]led, A;
	logic [31:0]TotalDataA;
	logic [31:0]TotalDataB;
	logic [31:0]resultado;
	alu_mult multi(TotalDataA, TotalDataB, resultado);
	pulse Pulso(clk, rst, boton, senal);
	typedef enum logic [3:0] {A1, A2, A3, A4, B1, B2, B3, B4, R1, R2, R3, R4} State;
	peripheral_deco7seg segm1(led[3:0], 1'b0, seg1);
	peripheral_deco7seg segm2(led[7:4], 1'b0, seg2);
	peripheral_deco7seg segm3(A[3:0], 1'b0, seg3);
	peripheral_deco7seg segm4(A[7:4], 1'b1, seg4);
	State momento;
	always_comb begin
	reset=~rst;
	end
	always_ff @(posedge reset, posedge senal)begin
	if(reset)begin
	loaddata<=1'b1;
	momento<=A1;
	TotalDataA<=0;
	TotalDataB<=0;
	end else if(momento==A1)begin
	momento<=A2;
	TotalDataA[7:0]<=data;
	end else if(momento==A2)begin
	momento<=A3;
	TotalDataA[15:8]<=data;
	end else if(momento==A3)begin
	momento<=A4;
	TotalDataA[23:16]<=data;
	end else if(momento==A4)begin
	momento<=B1;
	TotalDataA[31:24]<=data;
	end else if(momento==B1)begin
	momento<=B2;
	TotalDataB[7:0]<=data;
	end else if(momento==B2)begin
	momento<=B3;
	TotalDataB[15:8]<=data;
	end else if(momento==B3)begin
	momento<=B4;
	TotalDataB[23:16]<=data;
	end else if(momento==B4)begin
	momento<=R1;
	TotalDataB[31:24]<=data;
	end else if(momento==R1)begin
	momento<=R2;
	end else if(momento==R2)begin
	momento<=R3;
	end else if(momento==R3)begin
	momento<=R4;
	end else if(momento==R4)begin
	momento<=R1;
	end
	end
	
 always_comb begin
 case(momento)
	 A1:begin 
	 led=data;
	 A[3:0]=4'b0001;
	 A[7:4]=4'b1010;
	 end
	 A2:begin 
	 led=data;
	 A[3:0]=4'b0010;
	 A[7:4]=4'b1010;
	 end
	 A3:begin 
	 led=data;
	 A[3:0]=4'b0011;
	 A[7:4]=4'b1010;
	 end
	 A4:begin 
	 led=data;
	 A[3:0]=4'b0100;
	 A[7:4]=4'b1010;
	 end
	 B1:begin 
	 led=data;
	 A[3:0]=4'b0001;
	 A[7:4]=4'b1011;
	 end
	 B2:begin 
	 led=data;
	 A[3:0]=4'b0010;
	 A[7:4]=4'b1011;
	 end
	 B3:begin 
	 led=data;
	 A[3:0]=4'b0011;
	 A[7:4]=4'b1011;
	 end
	 B4:begin 
	 led=data;
	 A[3:0]=4'b0100;
	 A[7:4]=4'b1011;
	 end
	 R1:begin
	 led=resultado[7:0];
	 A[3:0]=4'b0001;
	 A[7:4]=4'b1100;
	 end
	 R2:begin 
	 led=resultado[15:8];
	 A[3:0]=4'b0010;
	 A[7:4]=4'b1100;
	 end
	 R3:begin
	 led=resultado[23:16];
	 A[3:0]=4'b0011;
	 A[7:4]=4'b1100;
	 end
	 R4:begin
	 led=resultado[31:24];
	 A[3:0]=4'b0100;
	 A[7:4]=4'b1100;
	 end
	 endcase
 end

//always_comb begin
//if(momento==R1 || momento==R2 || momento==R3 || momento==R4)begin
//resultado[31]=TotalDataA[31]+TotalDataB[31];
//resultado[30:23]=(TotalDataA[30:23]+TotalDataB[30:23]);
//resultado[22:0]={1'b1,TotalDataA[22:0]}*{1'b1,TotalDataB[22:0]};
//end else
//resultado=0;
//end
endmodule

