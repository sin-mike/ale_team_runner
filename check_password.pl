#!/usr/bin/perl

use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);

use strict;
use warnings;

if (scalar(@ARGV) < 1) {
  die "USAGE: $0 <passfile>\n";
}
my $pfile = $ARGV[0];
if ( ! -f $pfile ) {
  die "no such file: [$pfile]\n";
}

sub read_pfile {
  my $pfile = shift;
  my $pdict = {};
  open(my $f, "<$pfile") or die "Can't open file: [$pfile]";
  while(<$f>) {
    chomp;
    (my $login, my $pwd) = split /,/, $_;
    next if $login eq '' or $pwd eq '';
    $pdict->{$login} = $pwd;   
  }
  close($f);
  return $pdict;
}

my $pdict = read_pfile($pfile);

my $header = <STDIN>;
chomp $header;
(my $login, my $pwd, my @H) = split /,/, $header;
if (!$pdict->{$login}) {
  die "FAIL: no login: $login\n";
}


my $digest = sha1_hex($login.",".$pwd);

if ($pdict->{$login} ne $digest) {
  die "FAIL: password not match \n"; #[$pdict->{$login} ne $digest]\n";
}

print join(",", @H);
print "\n";

