#!/bin/bash
cd ..
while [ 1 == 1 ]
do
	rails runner script/run_tests.rb 
	sleep 1
done
