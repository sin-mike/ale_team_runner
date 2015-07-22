#!/bin/bash


for id in $(seq 15); do
  pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c6)
  team_dir=$(printf teams/team_17%03d ${id})
  [ -f $team_dir/pfile.txt ] && continue
  echo "team_${id},${pass}" | ./make_pfile.pl > $team_dir/pfile.txt 
  echo "team_${id},${pass}" >> pfile.txt
done 
