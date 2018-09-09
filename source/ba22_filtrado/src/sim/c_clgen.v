module c_clgen (
		input clk, //esse clock vem da placa (em uma simulação a gente faz um modulo superior
		input KEY, //esse reset seria um botão na placa
		input load_done, //isso é uma possibilidade, colocar o load_done como entrada para dar o reset de saida
		output clk_o, //clock do ambar
		//output wb_clk_o, //não é necessário. parece que esse é do wishbone e o de cima é do ahb
		output reg pm_clk_o, //power management clock used to run the Tick Timer, PIC and a few PMU-related registers
		output reg rst_o //ACHO QUE TENHO QUE VER NO WAVE PRA QUE SERVE ESSE SINAL... EU FIZ UM WIRE PRA ELE MAS NÃO SEI SE TÁ CERTO
		`ifdef BA22_PM_IMPLEMENTED //de fato está implementado (ao menos instanciado)
			,
			input pm_stalled_i,				//apararentemente não faz nada com isso no clgen original...
			output reg pm_stall_o			//porque power management foi instanciado mas não implementado.. (ele recebe 0 no reset)
		`endif		
	);
	
	reg    [5:0] contador_load_done; 
	reg    [1:0] contador = 2'b00;
	
	parameter count0 = 2'b00; 
	parameter count1 = 2'b01; 
	parameter count2 = 2'b10; 
	parameter count3 = 2'b11; 
	
	
	assign clk_o = (!load_done) ? 0 : clk;

	always @(posedge clk)
	begin	
		if ( KEY == 0 ) begin
			contador_load_done 	= 6'b000000;
			contador 			= 2'b00;
			pm_clk_o 			= 1;
			rst_o 				= 0;
			`ifdef BA22_PM_IMPLEMENTED
				pm_stall_o 		= 1'b0;
			`endif
		end
		else begin
			if(contador == 2'b01) begin
				pm_clk_o <= ~pm_clk_o;
				contador = 2'b00;
			end
			else begin
				contador <= contador +1;
			end
			if ( load_done == 1 ) begin // tem que ter um delay de 60 para ativar o reset:
				contador_load_done = contador_load_done + 1; //o certo seria coloca rum enable aqui para desabilitar e economziar energia.
				if ( contador_load_done == 59) begin
					rst_o = 1;
				end			
			end	
		end			
	end //end always	
endmodule