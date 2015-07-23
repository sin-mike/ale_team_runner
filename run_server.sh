#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# port
# 
[ -z "${ALE_PORT}" ] && ALE_PORT=1567
ALE_DIR=
TEAM_DIR=teams/team_${ALE_PORT}

function authorize() {
  local run_dir="$1"
  
  # read first line
  line=$(${DIR}/check_password.pl ${TEAM_DIR}/pfile.txt 2>&1)
  if [ $? -eq 0 ]; then
    # run ALE here
    if [[ ! "$line" =~ ^[a-z]*$ ]]; then
      echo "BAD rom name: [${line}]"
    elif [ ! -f "${DIR}/roms/${line}.bin" ]; then
      echo "ROM file not exists"  
    else
      echo "${line}" > ${run_dir}/rom.txt

      perl -lpe 'BEGIN{$|=1} $_ = "1,0,0,1" if $.==1;' |\
      ${ALE_DIR}ale \
        -game_controller fifo \
        -run_length_encoding false \
        -max_num_frames 540100 \
        -max_num_frames_per_episode 18000 \
        -display_screen true \
        "${DIR}/roms/${line}.bin" 2>${run_dir}/ale.err
    fi
  else
    echo "FAIL: [${line}]"
  fi
}



function run_ale() {
  local run_dir="$1"

  local pipe=${run_dir}/ale_fifo
  [ -p "${pipe}" ] || {
    rm -f "$pipe"
    mkfifo "$pipe" 
  }

  local in_file=${run_dir}/in_file
  local out_file=${run_dir}/out_file

  nc -l "${ALE_PORT}" < "${pipe}" |\
  tee "$in_file" |\
  authorize ${run_dir} |\
  tee "${pipe}" |\
  perl -lpe 'BEGIN{$|=1} s!^\:?\w+\:!:!g' |\
  gzip > "${out_file}.gz"
  
  #  -display_screen true \

  rm "${pipe}"
}

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

function count_scores_bkp() {
  local run_dir="$1"
  [ -f ${run_dir}/out_file.gz ] || return
  cat ${run_dir}/out_file.gz | zcat |\
  grep -oE '\:[0-9]*,[0-9]*\:$' |\
  tee ${run_dir}/episode_info |\
  ${DIR}/calc_scores.pl > ${run_dir}/scores.txt

  [ "{$VERBOSE}" == 1 ] && { echo -n "${run_dir} scores :"; head -n1 ${run_dir}/scores.txt; } 
}


mkdir -p $TEAM_DIR

# get max previous run_id:
run_id=$(
find "$TEAM_DIR" -name 'run_*' |\
grep -oE 'run_[0-9]{5}$' |\
cut -c5- | sort -nr | head -n1 | perl -lpe 's!^0*([1-9])!$1!' \
)
[ -z "$run_id" ] && run_id=0

while true; do
  run_id=$(( run_id + 1 ))
  run_dir=$TEAM_DIR/run_$(printf "%05d" ${run_id})
  mkdir -p "${run_dir}"
  
  echo "run_id: ${run_id}"
  run_ale "${run_dir}"

  count_scores "${run_dir}"
done

