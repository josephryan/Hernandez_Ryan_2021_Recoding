#!/usr/bin/perl

# score is the sum of intra-bin substitution scores (based on a matrix)
# the goal is to maximizes this score

$|++;
use strict;
use warnings;
use Data::Dumper;

our $DIR      = 'matrices';

MAIN: {
    my $code = $ARGV[0] or die "usage: $0 'CODE OF 20AAS IN BLOCKS LIKE THIS'\n";
    my $ra_code = get_code_mat($code);

    my $matrix = "$DIR/DAYHOFF";
    my $rh_dmat = get_mat($matrix);    
    my $sc = 0;
    foreach my $ra_c (@{$ra_code}) {
        $sc += score($rh_dmat,$ra_c);
    }         
print "\$sc = $sc\n";
}         

sub get_code_mat {
    my $code = shift;
    chomp $code;
    my @mat = ();
    my @chunks = split /\s+/, $code;
    foreach my $ch (@chunks) {
        my @subchunk = split //, $ch;
        push @mat, \@subchunk;
    }
    return \@mat;
}

sub score {
    my $rh_m = shift;
    my $ra_t = shift;
    my $score = 0;
    my %seen = ();
    foreach my $idx (@{$ra_t}) {
        foreach my $idy (@{$ra_t}) {
            next if ($idx eq $idy);
            next if ($seen{$idx}->{$idy});
            $seen{$idy}->{$idx} = 1;
            $score += $rh_m->{$idx}->{$idy};
        }
    }
    return $score;
}

sub get_mat {
    my $file = shift;
    my %mat  = ();
    my @aa   = ();

    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        next if ($line =~ m/^\s*$/); # skip blanks
        next if ($line =~ m/^\s*#/); # skip comments
        next if ($line =~ m/^B/);
        next if ($line =~ m/^X/);
        next if ($line =~ m/^Z/);
        next if ($line =~ m/^\*/);
        next if ($line =~ m/^\*/);
        if ($line =~ m/^\s+\w\s+\w/) {
            $line =~ s/^\s+//;
            die "unexpected" if (@aa);
            @aa = split /\s+/, $line;
            pop @aa if ($aa[-1] eq '*');
        } elsif ($line =~ m/^\w/) {
            my @scores = split /\s+/, $line;
            my $aaa = shift @scores;
            for (my $i = 0; $i < @aa; $i++) {
                $mat{$aaa}->{$aa[$i]} = $scores[$i];
            }
        } else {
            die "unexpected line: $line\n";
        }
    }
    return \%mat;
}
