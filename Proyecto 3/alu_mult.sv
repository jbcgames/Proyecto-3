module alu_mult (dataA, dataB, Resultado, esp);
	input logic [31:0] dataA, dataB;
	output logic [31:0] Resultado;
	output logic [1:0] esp;
	logic [9:0]exponent;
	logic [46:0]mantisas;
	logic d;
	always_comb begin
	esp=0;
	mantisas=0;
	d=0;
	exponent=0;
	Resultado=0;
	
	//Excepciones
	if(dataA[30:23]==8'b0000_0000 || dataA[30:23]==8'b1111_1111 || 
		dataB[30:23]==8'b0000_0000 || dataB[30:23]==8'b1111_1111)begin
		
		//Indicacion de algun NaN
		if((dataA[30:23]==8'b1111_1111 && dataA[22:0]!=23'b000_0000_0000_0000_0000_0000) ||
			(dataB[30:23]==8'b1111_1111 && dataB[22:0]!=23'b000_0000_0000_0000_0000_0000))
			esp=2'b01;
			
		//Indicaciones con finitos
		if((dataA[30:23]!=8'b0000_0000 && dataA[30:23]!=8'b1111_1111)|| 
			(dataB[30:23]!=8'b0000_0000 && dataB[30:23]!=8'b1111_1111))begin
			
			//Si finito por 0
			if((dataA[30:23]==8'b0000_0000 && (dataB[30:23]!=8'b0000_0000 && dataB[30:23]!=8'b1111_1111)) || 
				 dataB[30:23]==8'b0000_0000 && (dataA[30:23]!=8'b0000_0000 && dataA[30:23]!=8'b1111_1111))
			Resultado=0;
			
			//Si finito por infinito
			else if((dataA[30:23]==8'b1111_1111 && (dataB[30:23]!=8'b0000_0000 && dataB[30:23]!=8'b1111_1111)) || 
						dataB[30:23]==8'b1111_1111 && (dataA[30:23]!=8'b0000_0000 && dataA[30:23]!=8'b1111_1111))
						esp=2'b11;
			end
		//Si infinito por infinito	
		if((dataA[30:23]==8'b1111_1111 && dataA[22:0]==23'b000_0000_0000_0000_0000_0000) ||
			(dataB[30:23]==8'b1111_1111 && dataB[22:0]==23'b000_0000_0000_0000_0000_0000))
			esp=2'b11;	
		end
		

		// Definicion de la multiplicacion
		else begin
			exponent=dataA[30:23]+dataB[30:23]-127+d;
			Resultado[30:23]=exponent[7:0];
			Resultado[31]=dataA[31]^dataB[31];
			{d,mantisas}={1'b1,dataA[22:0]}*{1'b1,dataB[22:0]};
			Resultado[22:0]=mantisas[45:23];
			esp=2'b00;
	end
	end
	

endmodule

//Testbench del Alu
module tb_multiplierunit ();

	logic [31:0] A, B, R;
	logic [1:0]E;
	alu_mult mio(A, B, R, E);
	
	assign A = 32'hC405_8ED1;
	assign B = 32'h4640_E47D;

	initial begin
	
	#(20ps);
	$stop;
	end
endmodule

// Codigo Residual

//			if((dataA==32'b0_0000_0000_000_0000_0000_0000_0000_0000 && 
//				dataB[30:0]==31'b1111_1111_000_0000_0000_0000_0000_0000)||
//				(dataB==32'b0_0000_0000_000_0000_0000_0000_0000_0000 && 
//				dataA[30:0]==31'b1111_1111_000_0000_0000_0000_0000_0000))
//				esp=2'b01;
//				end 
//				else if(dataA==32'b0_0000_0000_000_0000_0000_0000_0000_0000 && )
//				else if(dataA[30:23]==8'b1111_1111 && dataB[30:23]==8'b1111_1111)
//				esp=2'b01;
//				else if()