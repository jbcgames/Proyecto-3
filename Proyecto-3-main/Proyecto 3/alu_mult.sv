module alu_mult (dataA, dataB, Resultado);
	input logic [31:0] dataA, dataB;
	output logic [31:0] Resultado;
	logic [9:0]exponent;
	logic [46:0]mantisas;
	logic d;
	assign exponent=dataA[30:23]+dataB[30:23]-127+d;
	assign Resultado[30:23]=exponent[7:0];
	assign Resultado[31]=dataA[31]^dataB[31];
	assign {d,mantisas}={1'b1,dataA[22:0]}*{1'b1,dataB[22:0]};
	assign Resultado[22:0]=mantisas[45:23];
	
	

endmodule
module tb_multiplierunit ();
//	// WRITE HERE YOUR CODE
	logic [31:0] A, B, R;
	alu_mult mio(A, B, R);
	
	assign A = 32'hC405_8ED1;
	assign B = 32'h4640_E47D;

	initial begin
	
	#(20ps);
	$stop;
	end
endmodule