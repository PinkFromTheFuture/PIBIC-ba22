//testBench.v

`include "synth/common/wrappers/ba22_top_qmen.v"
//`include bench.v;

module testBench;
	
	ba22_top_qmem top( /*clock */, /*reset */);
	bench b ( /*clock */, /*reset */ );
	
endmodule

