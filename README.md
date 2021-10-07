Part I

1 docker run -d -p 8000:80 -p 9393:9393 --name infracloudio_d infracloudio/csvserver:latest
  2021/10/07 10:35:11 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory

2 error resloved after inputdata file and mounting the same to container 
  docker run -d -p 8000:80 -p 9393:9393 --name infracloudio_d -v ${PWD}/inputdata:/csvserver/inputdata infracloudio/csvserver:latest
  
3 excuted gencsv.sh 
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
	-----------------------------------------------------
  generated inputFile 
	0, 234
	1, 21758
	2, 4137
	3, 2689
	4, 18344
	5, 30755
	6, 24091
	7, 18636
	8, 28138
	9, 20128
	10, 27613
  
4 docker run -d -p 8000:80 -p 9393:9393 --name infracloudio_d -v ${PWD}/inputdata:/csvserver/inputdata -v ${PWD}/gencsv.sh:/csvserver/gencsv.sh -v ${PWD}/inputFile:/csvserver/inputFile infracloudio/csvserver:latest

5 netstat -ano | grep LISTEN -> port listening to 9300

6 docker run -d -p 8000:80 -p 9393:9300 --name infracloudio_d -e CSVSERVER_BORDER='Orange' -v ${PWD}/inputdata:/csvserver/inputdata -v ${PWD}/gencsv.sh:/csvserver/gencsv.sh -v ${PWD}/inputFile:/csvserver/inputFile infracloudio/csvserver:latest