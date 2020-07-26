module binder(input xrst, clk, data, count);
    // bind [BIND_TARGET] [ASSERTION_NAME] [INSTANCE_NAME_OF_ASSERTION]
  bind testbench sva_property u_sva_property(
        // .PORT_OF_ASSERTION(PORT_OF_TARGET)
        .xrst(xrst),
        .clk(clk),
        .data(data),
        .count(count)
    );
endmodule
