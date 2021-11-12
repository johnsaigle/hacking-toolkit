#!/usr/bin/env perl
# Extracts paths and URLs from a robots.txt file. 
# To use, just supply the full path to the URL containing the
# robots file.
#
# Lines matching wildcards ( '*' character) will be ignored.

use warnings;
use strict;
use v5.30; # You may need to update this over time or change for the OS

require LWP::UserAgent;

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

my $url = shift;
die "Supply a <value>\n" if not defined $url or length $url == 0;
my $ua = LWP::UserAgent->new;

my $request = HTTP::Request->new('GET', $url);

my $res = $ua->request($request);
my @lines = split "\n", $res->content;
for my $line (@lines) {
    if ($line =~ /allow/i) {
        # Split on spaces, e.g. "Disallow: /search"
        my @parts = split ' ', $line;
        say $parts[1] unless $parts[1] =~ /\*/;
    }
}
