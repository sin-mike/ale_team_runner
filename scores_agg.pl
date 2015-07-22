#!/usr/bin/perl -l

# agragate team score per game_type


use List::Util qw/sum max/;

use strict;
use warnings;

my $max_items = 30;
my $s = {};
while(<STDIN>) {
  chomp;
  (my $team, my $run, my $rom, my $epoch, my $dt, my $score) = split /;/;
  
  my $key = "${team};${rom}"; 
  $s->{$key} = [] if not exists $s->{$key};
  push @{$s->{$key}}, $score;
  shift @{$s->{$key}} if scalar(@{$s->{$key}}) > $max_items;
}

for my $key (sort keys %$s) {
  my $sum = sum @{$s->{$key}};
  my $cnt = scalar @{$s->{$key}};
  my $avg = $sum / ($cnt+0.0);
  my $max = max @{$s->{$key}};
  print join(";", $key, $sum, $avg, $cnt);
}

