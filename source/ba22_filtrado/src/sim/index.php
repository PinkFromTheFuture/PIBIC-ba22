<?php
//nome do arquivo de entrada:
$input = file_get_contents("rom.verilog");
if ($input === false) die("Unable to read data file $filename!");


$output_inicio = "--------------------------------------------------------------
-- ROM_ba22 - Template
-- Author: Renato Sampaio
-- Date: 21/02/2013
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

entity ROM_ba22 is
generic(
	ADDR_WIDTH : integer := 14
);
port(	clk   : in std_logic;
		addr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		data_out: out std_logic_vector(31 downto 0)
);
end ROM_ba22;

--------------------------------------------------------------

architecture Behav of ROM_ba22 is

    type ROM_Array is array (0 to (2**ADDR_WIDTH)-1 ) 
	of std_logic_vector(31 downto 0);

    constant dados: ROM_Array := (
";

$output_final = "	);       

begin
    process(clk, addr)
    begin
	if( clk'event and clk = '1' ) then
		data_out <= dados(conv_integer(addr));
    end if;
    end process;
end Behav;

--------------------------------------------------------------";


//################################################################################

$array = preg_split("/[\s,]+/", $input);

$output = fopen("ROM_ba22.vhd", "w+");

$index = 0;

$iterator;

$array_len = count($array);


fwrite ($output ,$output_inicio); //gravo no arquivo o inicio dele

//agora gravo o meio: (os dados)

$iterator = 0;
while ( $iterator<$array_len-1 ) {
	if(substr($array[$iterator], 0, 1) == '@'){ //ve se tem um arroba
		// echo "\nantes: $array[$iterator]";
		$array[$iterator] = ltrim ($array[$iterator],'@'); //tira o arroba
		// echo "\ndepois: $array[$iterator]";
		$array[$iterator] = base_convert($array[$iterator], 16, 10);
		// echo "\nbase convertida: $array[$iterator]";
		// $index = $array[$iterator];
		// echo "\npor fim: $index ";
		$index = $array[$iterator]/4;
		// echo "\no certo seria, dividir isso por 4, ficando: $index";
		$iterator++;
	}else{
		$jump = 1; //se juntei 1, 2, 3 ou 4 words tenho que pular elas depois. comeco com 1
	
		//formo as qwords:
		if(substr(@$array[$iterator+1], 0, 1) != '@'){
			$array[$iterator] = $array[$iterator] . $array[$iterator+1];
			$jump++; 
		}
		if(substr(@$array[$iterator+2], 0, 1) != '@'){
			$array[$iterator] = $array[$iterator] . @$array[$iterator+2];
			$jump++;
		}
		if(substr(@$array[$iterator+3], 0, 1) != '@'){
			$array[$iterator] = $array[$iterator] . @$array[$iterator+3];
			$jump++;
		}
		
		
		$array[$iterator] = base_convert($array[$iterator], 16, 2); //converte de base hexa pra base binaria
		
		//completo em 0 antes pra ficar bonitinho com os 32 bits
		$len = strlen($array[$iterator]);
		if( $len != 32 ){
			for($len;$len<32;$len++){
				$array[$iterator] = '0'.$array[$iterator];
			}
		}

		
		//echo "$index => \"$array[$iterator]\"<br />";
		fwrite ($output ,"\t\t$index => \"$array[$iterator]\",\n");
		
		$index++;
		$iterator=$iterator+$jump;	
	}
}

//echo "OTHERS => \"00000000000000000000000000000000\"<br />";
fwrite ($output ,"\t\tOTHERS => \"00000000000000000000000000000000\"\n");


fwrite ($output ,$output_final); //gravo no arquivo o final dele


echo 'done.'; 

?>