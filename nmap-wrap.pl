#!/usr/bin/env perl
# Runs nmap against common web ports. Uses nmap's -iL parameter only.

use warnings;
use strict;
use v5.30;

my $file = shift;

die "Supply an input file\n" if not defined $file or length $file == 0;

if (! -e $file) {
    die "File does not exist: $file\n";
}

my $ports = qq/80,443,3000,4080,4443,5000,8000,8080,8443,9000/;
my $date = qx/date +%Y-%m-%d/;
say qx/nmap -p $ports -sC -sV --open -iL $file -oN "nmap_$date"/
