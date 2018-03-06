#!/usr/bin/perl

# AUTHOR: Joseph Ryan <joseph.ryan@whitney.ufl.edu>
# DATE:   Mon Mar  5 11:30:15 EST 2018

# script will run seq-gen commands with increasing branch length scaling factor
# and will then calculate instances of saturation that occur between nodes
# it uses the simple bifurcating test.tre as input
# despite being an underestimate of saturation, it shows the effect of scaling 
#    factor on saturation levels

use strict;
use warnings;
use autodie;
use Data::Dumper;

our @CMDS = (
'seq-gen -MPAM -z 420 -n 1 -s1.0 -a1.0 -or -wa -l 1000 test.tre 2> /dev/null',
'seq-gen -MPAM -z 420 -n 1 -s2.0 -a1.0 -or -wa -l 1000 test.tre 2> /dev/null',
'seq-gen -MPAM -z 420 -n 1 -s3.0 -a1.0 -or -wa -l 1000 test.tre 2> /dev/null',
'seq-gen -MPAM -z 420 -n 1 -s4.0 -a1.0 -or -wa -l 1000 test.tre 2> /dev/null',
'seq-gen -MPAM -z 420 -n 1 -s5.0 -a1.0 -or -wa -l 1000 test.tre 2> /dev/null'
);
our @FILES = qw(test.1.phy test.2.phy test.3.phy test.4.phy test.5.phy);

MAIN: {
    for (my $i = 0; $i < @CMDS; $i++) {
        my $diag = system "$CMDS[$i] > $FILES[$i]";
        die "system failed: $?" unless ($diag == 0);
        my $file = $FILES[$i];
        my %seqs = ();
        open (my $fh, '<', $file);
        while (my $line = <$fh>) {
            next if ($line =~ m/^\s/);
            chomp $line;
            my @rec = split /\t/, $line;
            my @aas = split '', $rec[1];
            $seqs{$rec[0]} = \@aas;
        }
        my $sat = count_sat(\%seqs,7,8,'A');
        $sat += count_sat(\%seqs,7,8,'B');
        $sat += count_sat(\%seqs,7,9,10,'C');
        $sat += count_sat(\%seqs,7,9,10,'D');
        $sat += count_sat(\%seqs,7,9,11,'E');
        $sat += count_sat(\%seqs,7,9,11,'F');
        print "$file: $sat\n";
    }
}

sub count_sat {
    my $rh_seqs = shift;
    my @nodes = @_;
    my $sat = 0;
#    @last = ('A', 'V', 'P'...  # EXAMPLE
#    @seen = ({'W' => 3}, {'V' => 2, 'I' => 1}, ... #EXAMPLE
    for (my $i = 0; $i < @{$rh_seqs->{$nodes[0]}}; $i++) {
        my @last = ();
        my @seen = ();
        foreach my $node (@nodes) {
            $sat++ if ($seen[$i]->{$rh_seqs->{$node}->[$i]} &&
                       $last[$i] ne $rh_seqs->{$node}->[$i]);
            $seen[$i]->{$rh_seqs->{$node}->[$i]} = 1;
            $last[$i] = $rh_seqs->{$node}->[$i];
        }
    } 
    return $sat;
}
