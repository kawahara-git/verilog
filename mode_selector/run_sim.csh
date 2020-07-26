#! /bin/csh

foreach i (`ls ./testcase/`)
    #Verilog Compile
    csh vsim.csh $i
    #Python SIM run
    #csh python_sim.csh
    #diff
    #diff -s testcase/$i/testcase.csv python/${i}.csv |& tee log/${i}.log
end
