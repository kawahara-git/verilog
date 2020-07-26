#! /bin/csh

#choose testcase
set TestName = $1
cp ./testcase/$TestName/testcase.inc ./testcase.inc

#verilog compile
iverilog -o tb_top.sv mode_selector.sv
./mode_selector.out

#after process
rm ./testcase.inc
mv ./testcase.csv ./testcase/$TestName/testcase.csv
