#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function count_scores() {
  local run_dir="$1"
  [ -f ${run_dir}/out_file.gz ] || return
  cat ${run_dir}/out_file.gz | zcat |\
  grep -oE '\:[0-9]*,[0-9]*\:$' |\
  tee ${run_dir}/episode_info |\
  ${DIR}/calc_scores.pl > ${run_dir}/scores.old.txt
 
  cat ${run_dir}/episode_info |\
  perl -lne 'm!^\:(\d+)\,(\d+)\:$!; print "$1,$2"' \
  > ${run_dir}/episode_info.txt

  tail -n+2 ${run_dir}/in_file |\
  paste -d',' - ${run_dir}/episode_info.txt |\
  tail -n+2 |\
  tee ${run_dir}/scores.raw |\
  ${DIR}/calc_scores_ok.pl > ${run_dir}/scores.txt

  [ "{$VERBOSE}" == 1 ] && { echo "${run_dir} scores :"; cat ${run_dir}/scores.txt; } 
}

for run_dir in $(find ${DIR}/teams -name "run_*"); do
  [ -f ${run_dir}/episode_info ] || continue
  echo "$run_dir"

  count_scores "$run_dir"
  head "$run_dir"/scores.txt  
done


