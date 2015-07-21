#!/usr/bin/perl -l

# agragate team score per game_type


use List::Util qw/sum/;

use strict;
use warnings;

my $max_items = 30;
my $s = {};
while(<STDIN>) {
  chomp;
  (my $run, my $rom, my $score) = split / /;
  
  $s->{$rom} = [] if not exists $s->{$rom};
  next if scalar(@{$s->{$rom}}) >= $max_items;
  push @{$s->{$rom}}, $score;
}

for my $rom (sort keys %$s) {
  my $sum = sum @{$s->{$rom}};
  my $cnt = scalar @{$s->{$rom}};
  my $avg = $sum / ($cnt+0.0);
  print "$rom $sum $avg $cnt";
}

