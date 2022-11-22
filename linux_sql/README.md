# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the GitFlow, the final work will be merged to the main branch after Team Code Team.


# Introduction
This project is made to monitor and record the usage information of servers running linux and store that information in a database. This information is to be used to make decisions about future resource planning.

This project is made using docker container to increase efficiency and reduce memory consumption compared to VMs. psql is used for database purposes and git is used to track project changes. Bash is used to develop the whole project ( git, docker, psql ) and ssh is used to gain secure access to remote server and authentication is done with the help of key.



# Implemenation

- Created a psql docker container from psql Image
- Created a psql instance on servers
- created volume for storing Database
- Create tables using ddl.sql file
- collect and store hardware and usage info into the database

# Usage
### **1. Database and table initialization**

Prior to running the Bash agents, Postgresql instance has to be provisioned from the root folder of the project
```
./linux_sql/scripts/psql_docker.sh start postgres password

psql -h local_host -p 5432 -U postgres -d postgres -f ddl.sql
```
###  2. host_info.sh

This script is only run once per node to insert nodes hardware specs into host_info table.
```dtd
.bash scripts/host_info.sh localhost 5432 host_agent postgres password
```

###  3. host_usage.sh

This script is multiple times using cron to insert nodes hardware memory usage per minute into host_usage table.
```dtd
.bash scripts/host_usage.sh localhost 5432 host_agent postgres password
```

###  4. Crontab setup


```dtd
        # edit crontab jobs
        bash> crontab -e

        #add this to crontab
        * * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log

        #list crontab jobs
        crontab -l

        #validate your result from the psql instance
        psql -h ...
        > SELECT * FROM host_usage;
```

## Architecture
![my image](./assets/my_image.jpg)




## Database Modeling
Describe the schema of each table using markdown table syntax
- `host_info`
``` 
                                          Table "public.host_info"
      Column      |            Type             |                       Modifiers                        
------------------+-----------------------------+--------------------------------------------------------
 id               | bigint                      | not null default nextval('host_info_id_seq'::regclass)
 hostname         | character varying           | not null
 cpu_number       | integer                     | not null
 cpu_architecture | character varying(15)       | not null
 cpu_model        | character varying(50)       | not null
 cpu_mhz          | numeric(7,3)                | not null
 l2_cache         | integer                     | not null
 total_mem        | integer                     | not null
 timestamp        | timestamp without time zone | not null
Indexes:
    "host_info_pkey" PRIMARY KEY, btree (id)
    "host_info_hostname_key" UNIQUE CONSTRAINT, btree (hostname)
Referenced by:
    TABLE "host_usage" CONSTRAINT "host_usage_host_id_fkey" FOREIGN KEY (host_id) REFERENCES host_info(id)
```
- `host_usage`
``` 
                                          Table "public.host_usage"
     Column     |            Type             |                          Modifiers                           
----------------+-----------------------------+--------------------------------------------------------------
 timestamp      | timestamp without time zone | not null
 host_id        | bigint                      | not null default nextval('host_usage_host_id_seq'::regclass)
 memory_free    | integer                     | not null
 cpu_idle       | integer                     | not null
 cpu_kernel     | integer                     | not null
 disk_io        | integer                     | not null
 disk_available | integer                     | not null
Foreign-key constraints:
    "host_usage_host_id_fkey" FOREIGN KEY (host_id) REFERENCES host_info(id)

```
# Test

Bash script was tested by running it multiple times with different arguments to verify different conditions implemented and also verify the results against the desired output

# Improvements
Write at least three things you want to improve
e.g.
- Make the script able to handle more than one linux distributions
- Combine sql and bash agent scripts into one file so we have to run it one time only
- Write the bash agent code so that it takes less memory i.e without use of so many variables
