#!/usr/bin/perl

use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);

use strict;
use warnings;

while(<STDIN>) {
  chomp;
  if ($_ eq "") { next; }
  (my $login, my $pwd) = split /,/, $_;
  my $digest = sha1_hex($login.",".$pwd);
  print join(",", $login, $digest), "\n";
}
