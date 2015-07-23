user="ubuntu"
folder="/"
cd /usr/share/nginx/html
sudo mkdir scores
cd scores

for i in {1..15}
do
  cd /usr/share/nginx/html/scores
  n=${i}
  if [[ "$n" -le "9" ]] 
  then
     n="0${i}"
  fi
  echo $n;
  pwd
  sudo ln -s "/home/${user}${folder}/ale_team_runner/teams/team_170${n}" "team${i}"
#  ls -al ./
  pwd
  cd "team${i}"
  sudo htpasswd -c .htpasswd team${i}

  cd /usr/share/nginx/html/scores

  echo "location /scores/team${i} {
    autoindex on;
    auth_basic \"Restricted\";
    auth_basic_user_file /usr/share/nginx/html/scores/team${i}/.htpasswd;
  }
  " >> ~/nginx_conf_str

done
