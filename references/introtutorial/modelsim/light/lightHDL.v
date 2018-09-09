
module t;
  reg ain;
  reg bin;
  
  wire cout;
  
  initial
  begin
    ain = 0;
    bin = 0;
  end
  
  always
  begin
    # 20 ain = 1;
      # 20 ain = ~ain;
  end
  
  always
  begin
    # 40 bin = 1;
      # 20 bin = ~bin;
  end
    
  light m(
    .SW( {ain, bin} ),
    .LEDG( cout )
    );
    
endmodule
