module pulse(clk, rst, boton, a);
//Indicacion de entradas
input logic clk, rst, boton;

//Indicacion de Salidas
output logic a;

//Indicacion de Señales
logic reset;

//Inversion del reset
always_comb begin
	reset=~rst;
end

//Creacion del indicador de pulso
always_ff @(posedge clk, posedge reset)begin
	if (reset)begin

		a<=0;
		end else if(~boton && a==0)begin

		a<=1;
		end else if(~boton && a==1)begin

	end else a<=0;
end

endmodule