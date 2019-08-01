#!/usr/bin/perl

use strict;
use warnings;
use autodie;

MAIN: {
    my $file = $ARGV[0] or die "usage: $0 FILE OUTDIR";
    my $dir  = $ARGV[1] or die "usage: $0 FILE OUTDIR";
    die "$dir exists" if (-d $dir);
    mkdir $dir;
    my $count = 1;
    open IN, $file;
    while (my $line = <IN>) {
        if ($line =~ m/^\s*\d+\s+\d+\s*$/) {
            open OUT, ">$dir/$count.phy";
            print OUT $line;
        } else {
            print OUT $line;
        }
        $count++;
    }
}

