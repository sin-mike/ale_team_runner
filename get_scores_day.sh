start_date=$1
end_date=$2
find . -newermt "2015-07-21 12:00:00" ! -newermt "2015-07-22 12:00:00" -exec cp -r {} ../teams_2015-07-22/ \;
