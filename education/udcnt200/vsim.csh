#! /bin/csh

#choose testcase
set TestName = $1
cp ./testcase/$TestName/testcase.inc ./testcase.inc

#verilog compile
iverilog -o udcnt200.out tb_top.sv udcnt200.sv
./udcnt200.out

#after process
rm ./testcase.inc
mv ./testcase.csv ./testcase/$TestName/testcase.csv