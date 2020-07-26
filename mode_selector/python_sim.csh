#! /bin/csh

#choose testcase
set TestName = $1

#python run
cd python
python create_expected_value.py $TestName
