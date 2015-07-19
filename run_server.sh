#!/bin/bash

# port
# 

ALE_DIR=../Arcade-Learning-Environment

function run_ale() {
  local pipe=ale_fifo
  [ -p "${pipe}" ] || {
    rm -f "$pipe"
    mkfifo "$pipe" 
  }

  local in_file=in_file
  local out_file=out_file

  nc -l 1567 < ale_fifo |\
  tee "$in_file" |\
  ${ALE_DIR}/ale \
    -game_controller fifo \
    -run_length_encoding false \
    ../DeepMind-Atari-Deep-Q-Learner/roms/breakout.bin |\
  tee "$out_file" \
  > ale_fifo

  #  -display_screen true \
}

while true; do
  run_ale
done
