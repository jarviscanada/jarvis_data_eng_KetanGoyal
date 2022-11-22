#! /bin/sh

# write a script to start|stop|create a psql container

cmd=$1
db_username=$2
db_password=$3
total_comments=$#

export PGPASSWORD=$db_password
export PGUSERNAME=$db_username


sudo systemctl status docker || sudo systemctl start docker

docker container inspect jrvs-psql
container_status=$?

 		   if [ $total_comments -ne 3 ]; then
    				echo 'username and password not given'
   			 exit 1
  			fi

create()


				{


				docker pull postgres
				docker volume create pgdata
				docker run --name jrvs-psql -e POSTGRES_PASSWORD=$PGPASSWORD POSTGRES_USERNAME=$PGUSERNAME -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine

				docker container ls -a -f name=jrvs-psql

				docker ps -f name=jrvs-psql

				docker container stop jrvs-psql

				docker container start jrvs-psql

				return $?

				}



case $cmd in
			create)

			if [ $container_status -eq 0 ]; then
					echo 'Container already exists'
					exit 1


			else

				create

			fi;;


			start)

				if [ $container_status -ne 0 ]; then create

				else

				docker container start jrvs-psql
        echo "container started"
				fi;;


			stop)

				docker container stop jrvs-psql
          echo "container stopped"
						return 0;;




esac























