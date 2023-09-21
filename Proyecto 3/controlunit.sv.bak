// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready, boton);
	input logic  clk, reset, boton;
	output logic  loaddata;
	input logic inputdata_ready;
	logic senal;
	pulse Pulso(clk, reset, boton, senal);
	typedef enum logic [3:0] {A1, A2, A3, A4, B1, B2, B3, B4, R1, R2, R3, R4} State;
	State momento;

	always_ff @(posedge pulse, posedge senal)begin
	if(reset)
	momento<=A1;
	else if(momento==A1)
	momento<=A2;
	else if(momento==A2)
	momento<=A3;
	else if(momento==A3)
	momento<=A4;
	else if(momento==A4)
	momento<=B1;
	else if(momento==B1)
	momento<=B2;
	else if(momento==B2)
	momento<=B3;
	else if(momento==B3)
	momento<=B4;
	else if(momento==B4)
	momento<=R1;
	else if(momento==R1)
	momento<=R2;
	else if(momento==R2)
	momento<=R3;
	else if(momento==R3)
	momento<=R4;
	else if(momento==R4)
	momento<=R1;
	end
	
	// Process (Combinational): update nextState
	// WRITE HERE YOUR CODE

	// Process (Combinational): update outputs 
	// WRITE HERE YOUR CODE
endmodule

