#!/bin/bash

if [ $# > 0 ]; then
  
	num=$1
  
else

      	num=10 

fi

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
