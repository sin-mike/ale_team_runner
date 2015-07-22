#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

id=16;
#for id in $(seq 15); do
  port=$( printf "17%03d" $id)
  echo $port
  export ALE_PORT=${port}
  ${DIR}/run_server_test.sh 
#done
wait
