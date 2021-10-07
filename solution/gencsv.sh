#!/bin/bash

num=10
echo"" >inputFile


function random_num(){
	RANDOM=$$
	for i in `seq $num`
	do
		echo "$i"","" $RANDOM" >>inputFile
		
	done
	
	chmod 777 inputFile
}

random_num 
