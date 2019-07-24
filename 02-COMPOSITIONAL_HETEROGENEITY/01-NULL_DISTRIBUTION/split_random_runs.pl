#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(ceil);
use lib qw(/Hernandez_Ryan_2019_RecodingSim/01-MODULES/);
use Servers;

our $VERSION = 0.02;

our $SETS = 10000;
our $OUTDIR = 'scripts';

MAIN: {
    my $tree = $ARGV[0] or die "usage: $0 TREE000X\n";
    my %servers = %JFR::Servers::SERVERS;
    my $total_cores = eval(join '+', values %servers);
    my $cmds_per_script = ceil(scalar($SETS/$total_cores));
    my $seed = 1;
    foreach my $server (keys %servers) {
        for (my $i = 1; $i <= $servers{$server}; $i++) {
            open (my $out, ">", "$OUTDIR/$server.$i.sh");
            for (my $j = 1; $j <= $cmds_per_script; $j++) {
                next if ($seed >= 10000000);
                print $out "perl get_random_comphets.pl $tree $seed $i\n";
                $seed += 1000;
            }
        }
    } 
}
