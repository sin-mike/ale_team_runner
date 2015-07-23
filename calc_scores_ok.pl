#!/usr/bin/perl

use strict;
use warnings;

my $reward = 0;
my $cnt = 0;
my $min_cnt = 40;

while(<STDIN>) {
  chomp;
  (my $a, my $b, my $t, my $r) = split /,/;
  $reward += $r;
  $cnt += 1;
  if ($t > 0 or $a == 44 or $a == 45) {
    if ($cnt > $min_cnt) {
      print join(",", $reward, $cnt), "\n";
    }
    $reward = 0;
    $cnt = 0;
  }
}

if ($cnt > $min_cnt) {
  print join(";", $reward, $cnt), "\n";
}
