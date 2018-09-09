<?php

$input = fopen("rom.verilog", "r");
$output = fopen("saida.txt", "w+");

$index = 0;
if ($input) {
    while (!feof($input)) {
        //$hex = bin2hex(fread ($input , 4 ));
		$lido = fread ($input , 1 );
		echo $lido;

		
		fprintf($index.' => "'.$bin.'"');
        //print $hex."\n";
    }
    fclose($input);
	fclose($output);
	
	echo 'done.'; 

}

?>