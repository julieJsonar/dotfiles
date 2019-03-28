#!/usr/bin/perl

use strict;

sub usage()
{
    print STDERR
	"\n" .
	"  Usage: craddr <filename> <executable>\n" .
	"\n" .
	"\tTypically <executable> will be 'init'\n" .
	"\n";
    exit;
}


my $verbose = 0;

my $file = shift;
if ( $file eq "-v" ) {
    $verbose = 1;
    $file = shift;
}
if ( ! -f $file ) {
    usage();
}


my $exe = shift;
if ( ! -f $file ) {
    usage();
}

sub main()
{
    my $IFH;
    my %lines;
    my @splitexe = split(/\//, $exe);
    my $exename = $splitexe[$#splitexe];
    my $addr2line = `which addr2line`;
    chomp $addr2line;

    print "Using: ".$addr2line."\n";

    open ($IFH, $file) || die "$?";

    while (my $l = <$IFH>) {
	chomp($l);
	if ($l =~ /<([0-9]+)> +\[(0x[0-9A-Fa-f]+)\].*([^ \t]*)/) {
            my $line_number = 0;
	    my $pid = $1;
	    my $addr = $2;
	    if ($lines{$addr} eq "") {
		my $addrline = `$addr2line -f -e $exe $addr`;
		chomp $addrline;
		if (!($addrline =~ /^\?/)) {
		    my ($function, $line) = split(/\n/, $addrline);
		    $lines{$addr} = $function." - ".$line;
		}
	    }
	    if (!($lines{$addr} eq "")) {
		if ($verbose) {
		    print $l."\n";
		}
		print $line_number.": ".$lines{$addr}."\n";
	    } else {
		print $l." (-)\n";
	    }
	} elsif ($l =~ /([0-9]+):.*<([0-9]+)> +[0-9A-Fa-f]+: ([0-9A-Fa-f]+) ([0-9A-Fa-f]+) ([0-9A-Fa-f]+) ([0-9A-Fa-f]+)/) {
	    my $line_number = $1;
	    my $pid = $2;
	    my %addr;
	    $addr{0} = $3;
	    $addr{1} = $4;
	    $addr{2} = $5;
	    $addr{3} = $6;
	    my $i;

	    if ($verbose) {
		print $l."\n";
	    }
	    for ($i = 0; $i < 4; $i++) {
		if ($lines{$addr{$i}} eq "") {
		    my $addrline = `$addr2line -f -e $exe $addr{$i}`;
		    chomp $addrline;
		    if (!($addrline =~ /^\?/)) {
			my ($function, $line) = split(/\n/, $addrline);
			$lines{$addr{$i}} = $function." - ".$line;
		    }
		}
		if (!($lines{$addr{$i}} eq "")) {
		    print $line_number.": ".$addr{$i}.": ".$lines{$addr{$i}}."\n";
		}
	    }
	} else {
	    print $l."\n";
	}
    }
    close ($IFH);
}

main();
