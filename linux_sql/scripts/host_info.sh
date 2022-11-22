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

cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "Model name:"  | xargs | awk '{ print substr( $0, 12 ) }')
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz:"  | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "^L2 cache:"  | awk '{print $3}' | xargs | sed 's/[K].*//')
total_mem=$( cat /proc/meminfo | egrep "^MemTotal:" | awk '{print $2}' | xargs)
timestamp=$( vmstat -t | awk 'NR==3 {print $18 " " $19}' | xargs)


export PGPASSWORD=$psql_password

insert_stmt="INSERT INTO host_info(
                                      hostname,
                                      cpu_number,
                                      cpu_architecture,
                                      cpu_model,
                                      cpu_mhz,
                                      L2_cache,
                                      total_mem,
                                      timestamp)
                                VALUES(

                                       '$hostname',
                                       '$cpu_number',
                                       '$cpu_architecture',
                                       '$cpu_model',
                                       '$cpu_mhz',
                                       '$l2_cache',
                                       '$total_mem',
                                       '$timestamp')"



psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
