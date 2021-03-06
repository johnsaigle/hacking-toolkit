#!/usr/bin/env perl
# Script to auto-generate boilerplate for perl scripts.
# Usage: perl perl-frontmatter.pl > some-new-script.pl
use warnings;
use strict;

while (<DATA>) {
    print $_;
}

__DATA__
#!/usr/bin/env perl
use warnings;
use strict;
use v5.34; # You may need to update this over time or change for the OS

# Parse an argument from the command line
# my $arg = shift;
# die "Supply a <value>\n" if not defined $arg or length $arg == 0;
