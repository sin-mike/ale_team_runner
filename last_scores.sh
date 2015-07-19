#!/bin/bash

team_dir="$1"
[ -z "${team_dir}" ] && { echo "USAGE: $0 <team_dir> [<max_scores>]">&2; exit 1; }
[ -d "${team_dir}" ] || { echo "no such dir: [${team_dir}]">&2; exit 1; }
max_games="$2"
[ -z "${max_games}" ] && max_games=30

find $team_dir -name scores.txt |\
xargs -I{} cat {} |\
tail -n"${max_games}" |\
perl -lne 'BEGIN{$s=0} $s+=$_; END {print $s}' 


