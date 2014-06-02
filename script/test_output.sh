#!/usr/bin/perl 
use warnings;
use strict;

my $start = time;

for (1..500000){
print "$_\n";
}

my $end = time;

my $diff = $end - $start;
print "$diff\n";
