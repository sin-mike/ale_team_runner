#!/usr/bin/env python

import sys
import re
import os

# Echo client program
import socket

HOST = 'localhost'    # The remote host
PORT = 1567              # The same port as used by the server

sys.stdin = os.fdopen(sys.stdin.fileno(), 'r', 0)

if __name__=="__main__":
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((HOST, PORT))
  
  head = s.recv(1024)
  print "IN:", head
  s.send("0,0,0,1\n")
  print "send"
  
  for line in sys.stdin:
    print "line:", line
    sys.stdout.flush()
    
    data = s.recv(1024)
    print "IN:", data 
    sys.stdout.flush()
  
    key = 0
    m = re.search('\d+', line)
    if m: 
      key = int(m.group(0))
    
    s.send("%d,18\n"%key)
 
  s.close()

  
