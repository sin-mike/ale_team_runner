#!/bin/bash

# read: login passwd rom_name
# check: sha1(login+passwd+salt) == passwd_from_file
function authorize() {
  # read first line
  line=$(./check_password.pl pfile.txt 2>&1)
  if [ $? -eq 0 ]; then
    # run ALE here
    ls .
  else
    echo "FAIL: [${line}]"
  fi
}

[ -p my_fifo ] || mkfifo my_fifo
nc -l 3333 < my_fifo |\
authorize > my_fifo

