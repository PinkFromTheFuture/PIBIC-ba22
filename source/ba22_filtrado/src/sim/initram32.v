module initram32(
	  input clk_load,
	  input start_load,
	  input KEY,
	  input [31:0] data_out_rom,
	  output reg [13:0] addr_rom, //aqui é variavel, o default é 14 bits.
	  output reg [31:0] addr_ram,  //fixo pq a ram tem sempre 32 bits
	  output [31:0] data_in_ram,
	  output reg [3:0] byte_en,  // 4bit  //out
	  output reg load_done
	);
	
	reg    [1:0] state;

	parameter s0 		= 2'b00; 
	parameter s1 		= 2'b01;
	parameter s_done 	= 2'b10;

	assign data_in_ram = (!load_done) ? data_out_rom : 0;
	
		
	always @(posedge clk_load)
	begin
		if(KEY == 0) begin
			load_done <= 0;
		end	
		if(KEY == 1) begin
			if (start_load) begin
				addr_rom <= 0;
				addr_ram <= 0;
				byte_en <= 4'b1111; //estamos copiando de 4 em 4, 
				state <= s0; 		//então usa-se as 4 partes do 
				load_done <= 0;		//enderecamento da ram
			end 
			else begin
				case (state)
					s0:	begin 
						addr_ram <= 0;
						addr_ram[13:0] <= {addr_rom, 2'b00}; //concatena
						addr_rom <= addr_rom + 1; 	//com o shift para 
						state <= s1;				//passar de 4 em 4.
					end
					s1:	begin 
						addr_ram <= 0;
						addr_ram[13:0] <= {addr_rom, 2'b00};
						addr_rom <= addr_rom + 1;
						if ( addr_rom >= (2**12)-1 ) begin
							state <= s_done;
						end									
					end
					s_done:	begin 
						load_done <= 1;
						state <= s_done;
						byte_en <= 0;
						addr_ram <= 0;
					end
					default:
						state <= s0;
				endcase	
			end //end else
		end
	end //end always
endmodule 	
