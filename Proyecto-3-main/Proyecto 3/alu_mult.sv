module alu_mult (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	localparam int SIGN_WIDTH = 1;
   localparam int EXP_WIDTH = 8;
   localparam int MANT_WIDTH = 23;
   localparam int BIAS = 127;
   localparam logic [EXP_WIDTH-1:0] EXP_MAX = '1;
   localparam logic [EXP_WIDTH-1:0] EXP_MIN = '0;
   localparam logic [MANT_WIDTH:0] MANT_MASK = '1;
	
	//variables para almacenar los campos de los operandos y el resultado
	logic [SIGN_WIDTH-1:0] sign_a, sign_b, sign_r;
   logic [EXP_WIDTH-1:0] exp_a, exp_b, exp_r;
   logic [MANT_WIDTH:0] mant_a, mant_b, mant_r;
	
	// Variables para almacenar los casos especiales
    logic zero_a, zero_b, zero_r;
    logic inf_a, inf_b, inf_r;
    logic nan_a, nan_b, nan_r;
	
	// Separar los campos de los operandos
    assign sign_a = dataA[31];
    assign exp_a = dataA[30:23];
    assign mant_a = dataA[22:0];
	 
	 assign sing_b = dataB[31];
	 assign exp_b = dataB[30:23];
	 assign mant_b = dataB[22:0];
	 
	  // Verificar si los operandos son casos especiales
    assign zero_a = (exp_a == EXP_MIN) && (mant_a == '0);
    assign zero_b = (exp_b == EXP_MIN) && (mant_b == '0);

    assign inf_a = (exp_a == EXP_MAX) && (mant_a == '0);
    assign inf_b = (exp_b == EXP_MAX) && (mant_b == '0);

    assign nan_a = (exp_a == EXP_MAX) && (mant_a != '0);
    assign nan_b = (exp_b == EXP_MAX) && (mant_b != '0);
	
	// Process: sign XORer
	// WRITE HERE YOUR CODE
	assign sign_r = sign_a ^ sign_b;
	
	// Process: exponent adder
	// WRITE HERE YOUR CODE
	always_comb begin
        exp_r = exp_a + exp_b - BIAS; // Sumar los exponentes sin sesgo
        if (exp_r > EXP_MAX) begin // Si el exponente es mayor que el máximo permitido
            exp_r = EXP_MAX; // Asignar el máximo valor al exponente
        end else if (exp_r < EXP_MIN) begin // Si el exponente es menor que el mínimo permitido
            exp_r = EXP_MIN; // Asignar el mínimo valor al exponente
        end
    end
	
	// Process: mantissa multiplier
	// WRITE HERE YOUR CODE
	
	always_comb begin
        mant_r = (mant_a | MANT_MASK[23:0]) * (mant_b | MANT_MASK[23:0]); // Multiplicar las mantisas con un bit implícito de 1
        if (mant_r[MANT_WIDTH]) begin // Si el bit más significativo de la mantisa es 1
            mant_r = mant_r >> 1; // Desplazar la mantisa un bit a la derecha
            exp_r = exp_r + 1; // Incrementar el exponente en 1
        end
        else 
			mant_r = mant_r[MANT_WIDTH:0]; // Conservar solo los bits de la mantisa
    end
	
	assign zero_r = zero_a || zero_b; // Si alguno de los operandos es cero, el resultado es cero
   assign inf_r = (inf_a && !nan_b) || (!nan_a && inf_b) || (exp_r == EXP_MAX); // Si alguno de los operandos es infinito y el otro no es NaN, o si el exponente es el máximo, el resultado es infinito
   assign nan_r = nan_a || nan_b || (inf_a && inf_b && sign_a != sign_b); // Si alguno de los operandos es NaN, o si ambos son infinitos de signo opuesto, el resultado es NaN

    // Asignar los bits del resultado según el caso especial
    always_comb begin
        if (zero_r) begin // Si el resultado es cero
            dataR	= {sign_r, EXP_MIN, '0}; // Asignar el bit de signo, el exponente mínimo y la mantisa cero
        end else if (inf_r) begin // Si el resultado es infinito
            dataR = {sign_r, EXP_MAX, '0}; // Asignar el bit de signo, el exponente máximo y la mantisa cero
        end else if (nan_r) begin // Si el resultado es NaN
            dataR = {sign_r, EXP_MAX, MANT_MASK}; // Asignar el bit de signo, el exponente máximo y la mantisa máxima
        end else begin // Si el resultado es normal
            dataR = {sign_r, exp_r, mant_r}; // Asignar los campos calculados
        end
    end
	// Process: operand validator and result normalizer and assembler
	// WRITE HERE YOUR CODE
endmodule
module tb_multiplierunit ();
//	// WRITE HERE YOUR CODE

	logic [31:0] dataA, dataB, dataR;
	
	dataA = 32'hC190_0000;
	dataB = 32'h4118_0000;
	multiplierunit multi (dataA, dataB, dataR);
	
endmodule