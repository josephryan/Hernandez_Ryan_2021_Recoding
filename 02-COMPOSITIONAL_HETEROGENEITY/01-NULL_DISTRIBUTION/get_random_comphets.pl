#!/usr/bin/perl

use strict;
use warnings;
use lib qw(/../../01-MODULES/);
use CompHet;
use Cwd;
use Data::Dumper;
use File::Copy;

our $VERSION = 0.03;

our $DIR = Cwd::getcwd();
our $REPS = 1000;

MAIN: {
    my $tree = $ARGV[0] or die "usage: $0 TREE000X SEED SCRIPTNUM\n";
    my $seed = $ARGV[1] or die "usage: $0 TREE000X SEED SCRIPTNUM\n";
    my $script_num = $ARGV[2] or die "usage: $0 TREE000X SEED SCRIPTNUM\n";
    my $tree_var = JFR::CompHet::get_tree_var($tree);
    my $set = $seed;
    mkdir $set; 
    for (1..$REPS){
       run_noncomphet_simulation($seed, $set, $script_num, $tree_var);
       move("ran.$set.$seed.phy", $set);
       unlink("ran.$set.$seed.nex");
       $seed++;       
    }
    my $rh_seqs = get_random_seqs($set);
    my $rh_freqs = JFR::CompHet::get_indiv_freqs($rh_seqs);
    my $comphet = JFR::CompHet::get_indiv_comphet($rh_freqs);
    my $out = "$script_num.out";
    open (my $fh, '>>', $out) or die "cannot open file $out:$!";
    print $fh "$comphet\n";
    close $fh;
}

sub get_random_seqs {
    my $dir = shift;
    my %seqs = ();
    opendir(my $dh, "$dir");
    my @files = grep { !/^\./ && -f "$dir/$_" } readdir($dh);
    foreach my $fi (@files) {         
        if ($fi =~m/^ran.$dir.\d+.phy/){
            open (my $fh, "<", "$dir/$fi") or die "cannot open file $dir/$fi:$!";
            while (my $line = <$fh>){
                if ($line=~m/^[ABCD]/){
                    chomp $line;
                    my @f = split /\s+/, $line;
                    $seqs{$f[0]} .= $f[1];
                }
            }
       }
    }
    return \%seqs;
}

sub run_noncomphet_simulation {
    my $seed = shift;
    my $set = shift;
    my $i = shift;
    my $tre = shift;
    my $chang_f = join ',', @JFR::CompHet::CHANG_FREQ;
    my $chang_r = join ',', @JFR::CompHet::CHANG_RATE;
    open OUT, ">p4.$i" or die "cannot open p4.$i:$!";
    print OUT  qq~func.reseedCRandomizer($seed)
read("$tre")
t = var.trees[0]
a = func.newEmptyAlignment(dataType='protein', taxNames=['A1', 'A2', 'A3', 'A4', 'A5', 'B1', 'B2', 'B3', 'B4', 'B5', 'C1', 'C2', 'C3', 'C4', 'C5', 'D1', 'D2', 'D3', 'D4', 'D5'], length=1000)
t.data = Data([a])
t.newComp(free=1, spec='specified', val=[$chang_f])
t.newRMatrix(free=1, spec='specified', val=[$chang_r])
t.setNGammaCat(nGammaCat=4)
t.newGdasrv(free=1, val=0.5)
t.setPInvar(free=0, val=0.0)
t.draw(model=1)
t.simulate(calculatePatterns=True, resetSequences=True, resetNexusSetsConstantMask=True)
t.data.writeNexus(fName="ran.$set.$seed.nex", writeDataBlock=1, interleave=0, flat=1, append=0)
read("ran.$set.$seed.nex")
a=var.alignments[0]
a.writePhylip(fName="ran.$set.$seed.phy", interleave=False,whitespaceSeparatesNames=True, flat=True)
~;
    close OUT;
    system "p4 p4.$i > /dev/null 2> /dev/null";
}

