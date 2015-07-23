#!/usr/bin/perl

use strict;
use warnings;

my $reward = 0;
while(<STDIN>) {
  chomp;
  if (!m!^\:(\d+)\,(\d+)\:$!) { next; }
  $reward += $2;
  last if $1;
}
while(<STDIN>){}
print "$reward\n"
