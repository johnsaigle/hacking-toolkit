#!/usr/bin/env perl
=begin comment
This script can be used to get just the path portion of a URL, e.g.:
Input: 'https://www.site.com/file'
Output: '/file'

Input can be piped to this script, so you can `cat` a file containing
URLs to this script in order to do bulk extraction
=end comment

=cut
use warnings;
use strict;
use v5.34; # You may need to update this over time or change for the OS

use URI::URL;

print "Parsing\n";
while (<>) {
    my $uri = url($_);
    say $uri->path;
}
