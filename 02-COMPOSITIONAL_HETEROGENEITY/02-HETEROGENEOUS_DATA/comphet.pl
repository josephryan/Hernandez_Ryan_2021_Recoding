#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw(shuffle);
use lib qw(/Hernandez_Ryan_2019_RecodingSim/01-MODULES/);
use CompHet;
use Cwd;

our $VERSION = 0.10;

our $DIR = Cwd::getcwd();
our $REPS = 1000; # number of replicates for each dataset 
our @POSSIBLES = (1..1000000000);
our $NUM_INFL = 1; # number of datasets for each replicate 
                   # each set increments inflation parameter by $INFL
MAIN: {
    my $tree = $ARGV[0] or die "usage $0 TREE000X INFL LENGTH PAIRINGS NULL\n";
    my $infl = $ARGV[1] or die "usage $0 TREE000X INFL LENGTH PAIRINGS NULL\n";
    my $length = $ARGV[2] or die "usage $0 TREE000x INFL LENGTH PAIRINGS NULL\n";
    my $pair = $ARGV[3] or die "usage $0 TREE000x INFL LENGTH PAIRINGS NULL\n"; 
    my $null = $ARGV[4] or die "usage $0 TREE000x INFL LENGTH PAIRINGS NULL\n";
    my $tree_var = JFR::CompHet::get_tree_var($tree);
    my @shuf = shuffle(@POSSIBLES);
    run_simulations($tree_var, $infl, $length, $pair, \@shuf);
    my $rh_seqs = get_seqs($DIR, $infl); 
    my $rh_freqs = get_freqs($rh_seqs); 
    my $rh_test_comphets = get_comphets($rh_freqs); 
    foreach my $infl (keys %{$rh_test_comphets}){
        print "comp-het index = $rh_test_comphets->{$infl}\n";
    }
    my $rh_pvals = get_pvals($rh_test_comphets, $null);
    foreach my $i (keys %{$rh_pvals}){
        print "p-value = $rh_pvals->{$i}\n";
    }
}

sub get_pvals {
    my $rh_tch = shift;
    my $null =shift;
    my @comphets = ();
    my %pvals  = ();
    open (my $fh, "<", $null) or die "cannot open file $null:$!";
    while (my $line = <$fh>){
        chomp $line;
        push @comphets, $line;
        my $total_rsets = @comphets;
        foreach my $k (keys %{$rh_tch}) {
            my $test_stat = $rh_tch->{$k};
            my $gte_count = 0;
                foreach my $ch (@comphets) {
                    $gte_count++ if ($ch >= $test_stat);
                }
                if ($gte_count) {
                    $pvals{$k} = $gte_count / $total_rsets;
                } else {
                    my $min_pval = 1 / $total_rsets;
                    $pvals{$k} = "<$min_pval";
                    $pvals{$k} = $gte_count / $total_rsets;
                }
        }
    }
    return \%pvals;
}

sub get_comphets {
    my $rh_freqs = shift;
    my %comphets = ();
    foreach my $k (keys %{$rh_freqs}) {
        $comphets{$k} = JFR::CompHet::get_indiv_comphet($rh_freqs->{$k});
    }
    return \%comphets;
}

sub get_freqs {
    my $rh_seqs = shift;
    my %freqs   = ();
    foreach my $par (keys %{$rh_seqs}) {
        $freqs{$par} = JFR::CompHet::get_indiv_freqs($rh_seqs->{$par});
    }
    return \%freqs;
}

sub run_simulations{
    my $tree = shift;
    my $infl = shift;
    my $length = shift;
    my $pair = shift;
    my $ra_shuf = shift;
    foreach (my $f=$infl;  $f <= ($infl * $NUM_INFL); $f += $infl){
        for (my $i=0; $i < $REPS; $i++){
            my ($ra_first10, $ra_last10) = get_chang_freqs($pair);
            my $rh_f = get_start_freqs($f, $ra_first10, $ra_last10);
            my $seed = shift @{$ra_shuf};
            write_and_run_pycode ($tree, $length, $seed, $f, $rh_f->{$f});
            unlink("$seed.$f.nex");
        }
    }
}

sub write_and_run_pycode {
    my $tree = shift;
    my $length = shift;
    my $seed = shift;
    my $f = shift;
    my $rh_f = shift;
    my $file = "seed$seed.$f.py";
    my $taxa = $tree;
    $taxa =~ s/\s//g;
    $taxa =~ s/^\(+//g;
    $taxa =~ s/:[0-9\.]+//g;
    my @taxa = split/[,)(;]/, $taxa;
    foreach my $t (@taxa){
        $t = "'$t'" if ($t);
    }
    my $str = join ",", @taxa;
    $str =~ s/,+/,/g;
    my ($root, $node1, $node2) = JFR::CompHet::get_nodes($tree);
    my $xstr = join ',', @JFR::CompHet::CHANG_FREQ;
    my $ystr = join ',', @{$rh_f};
    my $chang_r = join ',', @JFR::CompHet::CHANG_RATE;
    mkdir 'p4_scripts' unless -d 'scripts';
    open OUT, ">p4_scripts/$file" or die "cannot open $file:$!";
    print OUT  qq~func.reseedCRandomizer($seed)
read("$tree")
t = var.trees[0]
a = func.newEmptyAlignment(dataType='protein', taxNames=[$str], length=$length)
t.data = Data([a])
x = t.newComp(free=1, spec='specified', symbol='A', val=[$xstr])
y = t.newComp(free=1, spec='specified', symbol='B', val=[$ystr])
t.setModelThing(x, node=$root, clade=1)
t.setModelThing(y, node=$node1, clade=1)
t.setModelThing(y, node=$node2, clade=1)
t.newRMatrix(free=1, spec='specified', val=[$chang_r])
t.setNGammaCat(nGammaCat=4)
t.newGdasrv(free=1, val=0.5)
t.setPInvar(free=0, val=0.0)
t.draw(model=1)
t.simulate(calculatePatterns=True, resetSequences=True, resetNexusSetsConstantMask=True)
t.data.writeNexus(fName="$seed.$f.nex", writeDataBlock=1, interleave=0, flat=1, append=0)
read("$seed.$f.nex")
a=var.alignments[0]
a.writePhylip(fName="$seed.$f.phy", interleave=False,whitespaceSeparatesNames=True, flat=True)
~;

    close OUT;
    system "p4 p4_scripts/$file > /dev/null 2> /dev/null";
}

sub get_chang_freqs{
    my $pair = shift;
    my @first10 = ();
    my @last10 = ();
    if ($pair =~ m/random/i){
        my @freqs = shuffle(@JFR::CompHet::CHANG_FREQ); 
        @first10 = @freqs[0..9];
        @last10 = @freqs[10..19];
    }elsif ($pair =~ m/alphabetical/i){
        @first10 = @JFR::CompHet::CHANG_FREQ[0..9];
        @last10 = @JFR::CompHet::CHANG_FREQ[10..19];
    }  
    return (\@first10, \@last10);
}

sub get_start_freqs{
    my $f = shift;
    my $first10 = shift;
    my $last10 = shift;
    my %rh_f = ();
        for (my $i = 0; $i < @{$first10}; $i++){
          if (@{$first10}[$i] >= @{$last10}[$i]){
                # round so p4 doesn't croak w >3 digits after decimal point
                my $val = sprintf("%.3f",(@{$last10}[$i]*$f));
                $rh_f{$f}->[$i]    = @{$first10}[$i] - $val;
                $rh_f{$f}->[$i+10] = @{$last10}[$i] + $val;
            } else {
                my $val = sprintf("%.3f",(@{$first10}[$i]*$f));
                $rh_f{$f}->[$i]    = @{$first10}[$i] + $val;
                $rh_f{$f}->[$i+10] = @{$last10}[$i] - $val;
            }
        }    
    return \%rh_f;
}

sub get_seqs {
    my $dir = shift;
    my $infl = shift;
    my %seqs = ();
    opendir(my $dh, "$dir");
    my @files = grep { !/^\./ && -f "$dir/$_" } readdir($dh);
    foreach my $file (@files){
        foreach (my $f = $infl; $f <= ($infl*$NUM_INFL); $f += $infl){
            if ($file =~m/\d+.$f.phy$/){
               open (my $fh, "<", "$dir/$file") or die "cannot open file $dir/$file:$!";
                while (my $line = <$fh>){
                    if ($line=~m/^[ABCD]/){
                        chomp $line;
                        my @f = split /\s+/, $line;
                        $seqs{$f}->{$f[0]} .= $f[1];
                    }
                }
            }
        }
    }
    return \%seqs;
} 

