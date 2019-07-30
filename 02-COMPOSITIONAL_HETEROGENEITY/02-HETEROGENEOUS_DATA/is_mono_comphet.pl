#!usr/bin/perl

use strict;
use warnings;
use Cwd;
use Data::Dumper;

our $VERSION = 0.02;

our $DIR = Cwd::getcwd();

MAIN: {
    my $mod = $ARGV[0] or die "usage: $0 MODEL (e.g. DAYHOFF JTT DAYHOFF.9)\n";
    my ($ra_rc_trees, $ra_trees) = get_trees($mod);
    my $tree = @{$ra_rc_trees}[0];
    my $ra_taxa = get_taxa_from_tree($tree);
    my ($csvab, $ra_ab, $csvcd, $ra_cd) = get_clades($ra_taxa);
    my $rc_non_mono = mono_test($ra_rc_trees, $csvab, $ra_ab, $csvcd, $ra_cd);
    my $total_rc = scalar (@{$ra_rc_trees});
    my $count1 = 0;
    foreach my $rc_key (keys %{$rc_non_mono}){
        print "RECODED: INCORRECTLY RESOLVED TREE: $rc_key\n";
        $count1++
    }
    print "RECODED: PROPORTION INCORRECT: $count1/$total_rc\n";
    exit if (scalar(@{$ra_trees}) == 0);
    my $norc_non_mono = mono_test($ra_trees, $csvab, $ra_ab, $csvcd, $ra_cd);
    my $total_norc = scalar(@{$ra_trees});
    my $count2 = 0;
    foreach my $key (keys %{$norc_non_mono}){
        print "NON-RECODED: INCORRECTLY RESOLVED TREE: $key\n";
        $count2++
    }
    print "NON-RECODED: PROPORTION INCORRECT: $count2/$total_norc\n";
}

sub mono_test{
    my $tre = shift;
    my $csvab = shift;
    my $ab = shift;
    my $csvcd = shift;
    my $cd = shift;
    my %non_mono;
    my $rootab = $cd->[0];
    my $rootcd = $ab->[0];
    foreach my $t (@{$tre}){
        my @file = split/\//, $t;
        foreach my $file (@file){
            if ($file=~m/^RAxML_bestTree/){
                my $outab = `parapruner_is_mono.py -t $t -l $csvab -r $rootab`;
                my $hitab = is_false($outab);
                if ($hitab){
                    $non_mono{$file} = 1;
                }
                my $outcd = `parapruner_is_mono.py -t $t -l $csvcd -r $rootcd`;
                my $hitcd = is_false($outcd);
                if ($hitcd){
                    $non_mono{$file} = 1;
                }
            }
        }
    }
    return \%non_mono;
}

sub is_false{
    my $out = shift;
    if ($out =~ m/^\(False/) {
        return 1;
    } else {
        return 0;
    }
}

sub get_clades{
    my $taxa = shift;
    my $csvab = '';
    my $csvcd = '';
    my @ab = ();
    my @cd = ();
    foreach my $taxon (@{$taxa}){
        if ($taxon =~ m/^A|B/){
            push @ab, $taxon;
            $csvab .= $taxon . ',';
        } elsif ($taxon =~ m/^C|D/){
            push @cd, $taxon;
            $csvcd .= $taxon . ',';
        }  
    } 
    chop ($csvab, $csvcd);
    return ($csvab, \@ab, $csvcd, \@cd);
}

sub get_taxa_from_tree{
    my $tre = shift;
    open (my $fh, "<", $tre) or die "cannot open $tre:$!";
    my $tr = '';
    while (my $line = <$fh>){
        chomp $line;
        $tr .= $line;
        $tr =~ s/\s+//g;
        $tr =~ s/:[0-9\.]+/ /g;
        $tr =~ s/[,\(\)]+/ /g;
        $tr =~ s/;$//;
        my @taxa = split /\s+/, $tr;
        return \@taxa;
    }
}

sub get_trees{
    my $mod = shift;
    my @trees = ();
    my @rctrees = ();
    opendir (my $dh, "$DIR");
    my @sdirs = grep {!/^\./ && -d "$DIR/$_"} readdir ($dh);
    foreach my $sdir (@sdirs){
        if ($sdir =~m/$mod$/){
            opendir(my $dh2, "$DIR/$sdir");
            my @files = grep { !/^\./ && -f "$DIR/$sdir/$_"} readdir($dh2);
            foreach my $file (@files){
                if ($file=~m/RAxML_bestTree\.\d+\.PROTGAMMA$mod\.recode$/){
                    push @rctrees, "$DIR/$sdir/$file";
                } elsif ($file=~m/RAxML_bestTree\.\d+\.PROTGAMMA$mod$/){
                    push @trees, "$DIR/$sdir/$file";
                } 
            }
        } 
    }
    return (\@rctrees,\@trees);
}
