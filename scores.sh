#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/teams_2015-07-22"
echo $DIR
function score_for_run() {
  local run_dir="$1"
  local team_dir=$(dirname ${run_dir})
  local team=$(basename ${team_dir})

  #echo "$run_dir" 1>&2
  local scores=$(cat ${run_dir}/scores.txt 2>/dev/null)
  local rom=$(cat ${run_dir}/rom.txt 2>/dev/null)
  local run=$(basename ${run_dir})
  
  if [ ! -z "$scores" -a ! -z "$rom" ]; then
    local epoch=$(stat -c %Y ${run_dir}/scores.txt) 
    local date_time=$(stat -c %y ${run_dir}/scores.txt) 

    #echo "$run $rom $scores" 1>&2
    echo "${team};${run};${rom};${epoch};${date_time};${scores}"
  fi
}

export -f score_for_run

function score_for_team() {
  local team_dir="$1"
  [ -e ${team_dir}/scores.txt ] && mv ${team_dir}/scores.txt{,.bkp}

  echo -ne "" > ${team_dir}/scores.txt
  find "${team_dir}" -name "run_?????" |\
  xargs -I{} bash -c 'score_for_run {} >> '${team_dir}'/scores.txt'
  #xargs -I{} bash -c 'echo {}'

  ## TODO: calc last-30
  cat ${team_dir}/scores.txt | ${DIR}/scores_agg.pl > ${team_dir}/scores.agg.txt
}

[ -f ${DIR}/teams/scores.agg.all.txt ] && mv ${DIR}/teams/scores.agg.all.txt ${DIR}/teams/scores.agg.all.txt.bkp
[ -f ${DIR}/teams/scores.all.txt ] && mv ${DIR}/teams/scores.all.txt ${DIR}/teams/scores.all.txt.bkp
for team_dir in $(find ${DIR}/teams -name "team_*"); do
  
  echo "$team_dir"
  score_for_team $team_dir
  
  team_name=$(basename ${team_dir})
  cat ${team_dir}/scores.agg.txt >> ${DIR}/teams/scores.agg.all.txt
  cat ${team_dir}/scores.txt >> ${DIR}/teams/scores.all.txt
done


