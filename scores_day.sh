#find ./teams -newermt "2015-07-21 12:00:00" ! -newermt "2015-07-22 12:00:00"| awk '{split($0,a,"/"); print a[1]"/"a[2]"/"a[3]"/"a[4]}'
#find ./teams -newermt "2015-07-21 12:00:00" ! -newermt "2015-07-22 12:00:00"| awk '{split($0,a,"/"); print a[1]"/"a[2]"/"a[3]"/"a[4]}
start_date=$1
end_date=$2

cp_dir=teams_${end_date}/
mkdir $cd_dir
for run_name in $(find ./teams -newermt "$start_date 12:00:00" ! -newermt "$end_date 12:00:00"| awk '{split($0,a,"/"); print a[1]"/"a[2]"/"a[3]"/"a[4]}'|uniq); do
  dr=${cp_dir}$(dirname $run_name)
  mkdir -p $dr
  cp -r $run_name $dr
 done
