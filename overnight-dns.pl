#!/usr/bin/env/perl
use warnings;
use strict;

my $wordlist = '/usr/share/wordlists/seclists/bitquark-subdomains-top100000.txt';
if (! -e $wordlist) {
    die "Wordlist does not exist: $wordlist\n";
}

while (<>) {
	chomp;
	`gobuster dns -w $wordlist -i --domain $_ -o $_.gobuster.txt`;
}
