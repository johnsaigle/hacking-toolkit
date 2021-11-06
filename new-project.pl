#!/usr/bin/env perl
# Create a new directory for a bug bounty or CTF target in a directory called
# 'bb' under the user's home directory.
use warnings;
use strict;
use v5.32;

# Each of these directories will be created under the main one
my @dirs = <nmap gobuster>;
my @files = <notes.md scope.txt>;

my $name = shift;
die "Supply a name for the target" if not defined $name or length $name == 0;
my $path = "~/bb/$name"; # OS cmd injection. Don't deploy online or run with root.
foreach (@dirs) {
	`mkdir -p $path/$_`;
}
foreach (@files) {
	`touch $path/$_`;
}
