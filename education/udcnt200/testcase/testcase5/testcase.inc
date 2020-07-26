integer        file;

initial begin
    file=$fopen("testcase.csv","w");
    CLK = 1'b1;
    XRST = 1'b0;
    UPX = 1'b0;
    COUNT_EN = 1'b1;
    # (`CLK_100M/2);
    XRST = 1'b1;
    
    # 1000000;
    COUNT_EN = 1'b0;
    # 1000000;
    COUNT_EN = 1'b1;
    # 1000000;

    $fclose(file);
    $finish();
end

always @(posedge CLK) begin
    $fdisplay(file,"%02x",Q);
end