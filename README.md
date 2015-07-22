## Updated FIFO with authorization
Detailed descriptopn of FIFO protocaol available at https://github.com/mgbellemare/Arcade-Learning-Environment/blob/master/doc/manual/manual.pdf
See links in project repo: https://github.com/mgbellemare/Arcade-Learning-Environment
 
In order to play different games on single ALE server we accept rom name and authentification info in first line

A client should write to socket first line with format: printf("%s,%s,%s", login, password, rom_name)
Rom name whould go without dir name, slashes dots or extensions. forexample: test,test_pass,gopher

Logins and paswords should be mailed each team 

## To check a remote server one could communicate it thowgh netcat:

```
$ nc localhost 1567
> test,test12,gopher
< 210-160
> 0,0,0,1
< :0,0:
...
```

## Run server on local machine
install dependencies
```
sudo perl -MCPAN -e 'notest install Digest::SHA1'
```

```
mkdir -p teams/team_1567
echo "test,test12" | ./make_pfile.pl > teams/team_1567/pfile.txt

./run_server.sh
```

## Run python client with local server (host/port encoded in ./py_kb_test.py 
./py_kb_test.py test test12 breakout

## run simple console client using FIFO protocol 
```
mkfifo client_fifo
nc localhost 1567 < client_fifo |tee simple_in | ./simple | tee simple_out > client_fifo
```


## Calsulate team scores:
```
bash  scores.sh
cat teams/scores.all.txt
 
```
