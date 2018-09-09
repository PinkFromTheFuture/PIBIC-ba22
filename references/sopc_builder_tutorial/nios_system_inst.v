  //Example instantiation for system 'nios_system'
  nios_system nios_system_inst
  (
      .clk_0                   (clk_0),
      .in_port_to_the_Switches (in_port_to_the_Switches),
      .out_port_from_the_LEDs  (out_port_from_the_LEDs),
      .reset_n                 (reset_n)
    );

