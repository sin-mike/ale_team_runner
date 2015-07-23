#!/usr/bin/env python
"""
Sample Python/Pygame Programs
Simpson College Computer Science
http://programarcadegames.com/
http://simpson.edu/computer-science/
"""

import sys
import os
import re 
import pygame
import codecs

import logging


# Define some colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
 
 
def draw_stick_figure(screen, x, y):
    # Head
    pygame.draw.ellipse(screen, BLACK, [1 + x, y, 10, 10], 0)
 
    # Legs
    pygame.draw.line(screen, BLACK, [5 + x, 17 + y], [10 + x, 27 + y], 2)
    pygame.draw.line(screen, BLACK, [5 + x, 17 + y], [x, 27 + y], 2)
 
    # Body
    pygame.draw.line(screen, RED, [5 + x, 17 + y], [5 + x, 7 + y], 2)
 
    # Arms
    pygame.draw.line(screen, RED, [5 + x, 7 + y], [9 + x, 17 + y], 2)
    pygame.draw.line(screen, RED, [5 + x, 7 + y], [1 + x, 17 + y], 2)

import random

scale = 2
def rand_colors():
  return [[random.randrange(256),random.randrange(256),random.randrange(256)] for i in  range(256)]
colors = rand_colors()
 
def show_ale_screen(screen, data, w, h):
  byte_str = codecs.decode(data, 'hex_codec') 
  for i in range(len(byte_str)):
    ch = byte_str[i]
    id = ord(ch)
    x = i % w
    y = i / w
    rect = pygame.Rect((x*scale,y*scale), (scale, scale)) 
    #pygame.draw.rect(screen, colors[id], Rect, width=0)
    screen.fill(colors[id], rect)

import socket

#HOST = '93.175.18.243'    # The remote host
#PORT = 17015

HOST = 'localhost'    # The remote host
PORT = 1567              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

  
login = 'test'
pwd = 'test12'
rom = 'gopher'
if len(sys.argv) > 3:
  login = sys.argv[1]
  pwd = sys.argv[2]
  rom = sys.argv[3]

line = "%s,%s,%s\n"%(login, pwd, rom)
logging.warning('>>>>'+line)
s.send(line)

head = s.recv(1024)
m = re.match(r'(\d{3})\-(\d{3})', head)
if not m:
  sys.stderr.write("bad FIFO header: [%s]"%head)
  sys.exit(1)

width = int(m.group(1))
height = int(m.group(2))

print "IN:", head
s.send("1,0,0,1\n")
 
 
# Setup
pygame.init()
 
# Set the width and height of the screen [width,height]
size = [width * scale, height * scale]
screen = pygame.display.set_mode(size)
 
pygame.display.set_caption("My Game")
 
# Loop until the user clicks the close button.
done = False
 
# Used to manage how fast the screen updates
clock = pygame.time.Clock()
 
# Hide the mouse cursor
pygame.mouse.set_visible(0)
pause = False
 
ssz = width*height
# -------- Main Program Loop -----------
screen_str = ''
episode_str =''

class sock_lines:
  def __init__(self, s):
    self.s = s
    self.buff = ''

  def get_line(self):
    pos = self.buff.find('\n')
    while pos == -1:
      data = self.s.recv(ssz*2+10)
      pos = data.find('\n')
      if pos != -1 :
        pos += len(self.buff)
      self.buff = self.buff + data
    out = self.buff[:pos+1]
    self.buff = self.buff[pos+1:]
    return out
      
sl  = sock_lines(s)
currentstep = 0;
while not done:
    if not pause:
      currentstep = currentstep+1
      #data = s.recv(ssz*2+10)
      data = sl.get_line()
      (screen_str, episode_str, delme) = data.split(":", 2)
    
      show_ale_screen(screen, screen_str, width, height)
    else:
      show_ale_screen(screen, screen_str, width, height)
      rect = pygame.Rect((int(width*scale*0.4), int(height*scale*0.2)), (int(width*scale*0.2), int(height*scale*0.2)))
      screen.fill([255,0,0], rect)
    #print "IN:", data 
    #sys.stdout.flush()
  
    action = 0
    # ALL EVENT PROCESSING SHOULD GO BELOW THIS COMMENT
    terminal, reward = episode_str.split(',', 1)
    logging.warning('frame '+ str(currentstep) + ' reward: '+ reward + ' terminal: '+ terminal + ' delme' + delme)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
            # User pressed down on a key
 
        elif event.type == pygame.KEYDOWN:
            # Figure out if it was an arrow key. If so
            # adjust speed.
            if event.key == pygame.K_LEFT:
                action = 4
            elif event.key == pygame.K_RIGHT:
                action = 3
            elif event.key == pygame.K_UP:
                action = 2
            elif event.key == pygame.K_DOWN:
                action = 5
            elif event.key == pygame.K_SPACE:
                pause = not pause
            elif event.key == pygame.K_BACKSPACE:
                action = 45 #reset
            elif event.key == pygame.K_ESCAPE:
                done = True
            elif event.key == pygame.K_c:
                colors = rand_colors()

        # User let up on a key
        elif event.type == pygame.KEYUP:
            # If it is an arrow key, reset vector back to zero
            if event.key == pygame.K_LEFT:
                action = 0
            elif event.key == pygame.K_RIGHT:
                action = 0
            elif event.key == pygame.K_UP:
                action = 0
            elif event.key == pygame.K_DOWN:
                action = 0
    
    if not pause:
      keys=pygame.key.get_pressed()
      if keys[pygame.K_a]:
        action = 4
      elif keys[pygame.K_d]:
        action = 3
      elif keys[pygame.K_w]:
        action = 2
      elif keys[pygame.K_s]:
        action = 5
      elif keys[pygame.K_j]:
        action = 12
      elif keys[pygame.K_l]:
        action = 11
      elif keys[pygame.K_i]:
        action = 10
      elif keys[pygame.K_k]:
        action = 13

    # ALL EVENT PROCESSING SHOULD GO ABOVE THIS COMMENT
 
    # ALL GAME LOGIC SHOULD GO BELOW THIS COMMENT
 
    # ALL GAME LOGIC SHOULD GO ABOVE THIS COMMENT
 
    # ALL CODE TO DRAW SHOULD GO BELOW THIS COMMENT
 
    #screen.fill(WHITE)
 
 
    # ALL CODE TO DRAW SHOULD GO ABOVE THIS COMMENT
 
    # Go ahead and update the screen with what we've drawn.
    if not pause:
      s.send("%d,18\n"%action)
    
    pygame.display.flip()
 
    # Limit to 20 frames per second
    clock.tick(30)

 
# Close the window and quit.
# If you forget this line, the program will 'hang'
# on exit if running from IDLE.
pygame.quit()
