#!/usr/bin/env bash


psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5



if [[ $# -ne  5 ]]; then
  echo 'please provide proper commands'
  exit 1
fi


#parse hardware specification
hostname=$(hostname -f)
lscpu_out=`lscpu`
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";
timestamp=$( vmstat -t | awk 'NR==3 {print $18 " " $19}' | xargs)
memory_free=$( cat /proc/meminfo | egrep "^MemFree:" | awk '{print $2}' | xargs | sed 's/...$//')
cpu_idle=$( vmstat | awk 'NR==3 {print $15}' | xargs)
cpu_kernel=$( vmstat | awk 'NR==3 {print $14}' | xargs)
disk_io=$( vmstat -d | awk 'NR==3 {print $10}' | xargs)
disk_available=$( df | egrep "/$" | awk '{print $4}' | xargs)

export PGPASSWORD=$psql_password

insert_stmt="INSERT INTO host_usage(timestamp,
                                    host_id,
                                    memory_free,
                                    cpu_idle,
                                    cpu_kernel,
                                    disk_io,
                                    disk_available)

                            VALUES('$timestamp',
                                    $host_id,
                                   '$memory_free',
                                   '$cpu_idle',
                                   '$cpu_kernel',
                                   '$disk_io',
                                   '$disk_available')"
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
