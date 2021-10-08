Part I
------------------------------------------------------------------------------------------------------------------------------------------
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
  
4 docker run -d -p 8000:80 -p 9393:9393 --name CsvServer -v ${PWD}/gencsv.sh:/csvserver/gencsv.sh -v ${PWD}/inputFile:/csvserver/inputdata infracloudio/csvserver:latest

5 netstat -ano | grep LISTEN -> port listening to 9300

6 docker run -d -p 8000:80 -p 9393:9300 --name CsvServer -e CSVSERVER_BORDER='Orange' -v ${PWD}/gencsv.sh:/csvserver/gencsv.sh -v ${PWD}/inputFile:/csvserver/inputdata infracloudio/csvserver:latest

Part II
------------------------------------------------------------------------------------------------------------------------------------------
1 Created Docker-compose.yaml file using image part I image ( infracloudio/csvserver:latest ) with port 9393:9300 enableing in yaml file 

	version: "3.3"
	services:
	  CsvServer:
		environment:
		  - CSVSERVER_BORDER=Orange
		ports:
		  - "9393:9300"
		volumes:
		  - ./inputFile:/csvserver/inputdata
		image: "infracloudio/csvserver:latest"


Part III
------------------------------------------------------------------------------------------------------------------------------------------
1 Creating Prometheus Server @localhost:9090 
	version: "3.3"
	services:
	  CsvServer:
		environment:
		  - CSVSERVER_BORDER=Orange
		ports:
		  - "9393:9300"
		volumes:
		  - ./inputFile:/csvserver/inputdata
		image: "infracloudio/csvserver:latest"

	  Prometheus:
		ports:
		  - "9090:9090"
		volumes:
		  - ./prometheus.yml:/etc/prometheus/prometheus.yml
		image: "prom/prometheus:v2.22.0"

2 Configure Prometheus to collect data from csvserver @localhost:9393/metrics
  adding below configs prometheus.yml file 
	
	scrape_configs:
	  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
	  - job_name: 'prometheus'

		# metrics_path defaults to '/metrics'
		# scheme defaults to 'http'.

		static_configs:
		- targets: ['localhost:9090']
		
		#- targets: ['3.87.190.119:9393']
		- targets: ['localhost:9393']
		  labels:
			group: 'CsvServer'