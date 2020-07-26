#! /bin/csh

echo "diff result" > log/diff.log

foreach i (`ls ./testcase/`)
    #Verilog Compile
    csh vsim.csh $i
    #Python SIM run
    csh python_sim.csh $i
    #diff
    diff -s testcase/$i/testcase.csv python/${i}.csv |& tee -a log/diff.log
end
