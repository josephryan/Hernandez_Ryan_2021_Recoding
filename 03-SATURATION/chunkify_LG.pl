#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Data::Dumper;
use POSIX qw(ceil);
use Cwd;
use lib qw(/../01-MODULES/);
use Servers;

# this script generate shell scripts to be launched on your servers or operating systems.

our $VERSION = 0.02;

our $DIR = Cwd::getcwd();
our @SUBDIRS = qw(02-SEQ_GEN_CHANG);
our @SUBSUBDIRS = qw(01-DAYHOFF 02-JTT);
our $OUTDIR = 'LG_scripts';
our %SUBSET = (1 => 1, 5 => 1, 10 => 1, 15 => 1, 20 => 1); # set to () if no sub

MAIN: {
    my $ra_alns = get_alns($DIR,\@SUBDIRS,\@SUBSUBDIRS);
    my %servers = %JFR::Servers::SERVERS;
    my $total_cores = eval(join '+', values %servers);
    my $cmds_per_script = ceil(scalar(@{$ra_alns}) / $total_cores);
    my $index = 0;
    foreach my $server (keys %servers) {
        for (my $i = 1; $i <= $servers{$server}; $i++) {
            open(my $out, ">", "$OUTDIR/$server.$i.sh");
            for (my $j = 1; $j <= $cmds_per_script; $j++) {
                my $aln = $ra_alns->[$index];
                my $mod = '';
                if ($aln =~ m/DAYHOFF/) {
                    $mod = 'PROTGAMMALG';
                } elsif ($aln =~ m/JTT/) {
                    $mod = 'PROTGAMMALG';
                } else {
                    die "couldn't figure model: $aln";
                }
                $aln =~ m/^(.*)\/(\d+)\.phy$/ or die "unexpected regex:$aln";
                my $dir = $1;
                my $num = $2;
                mkdir "$dir/$num.$mod" unless -d ("$dir/$num.$mod");
                print $out "raxmlHPC -p 420 -m $mod -n $num.$mod -w $dir/$num.$mod -s $aln\n";
                $index++;
            }
        }
    }
}

sub get_alns {
    my $dir = shift;
    my $ra_sub = shift;
    my $ra_subsub = shift;
    my @alns = ();
    foreach my $sd (@{$ra_sub}) {
        foreach my $ssd (@{$ra_subsub}) { 
            opendir(my $dh, "$dir/$sd/$ssd");
            my @sssdirs = grep { !/^\./ && -d "$dir/$sd/$ssd/$_" } readdir($dh);
            foreach my $sssd (@sssdirs) {
                $sssd =~ m/^.*\.(\d+)$/;
                next unless ($SUBSET{$1} || !%SUBSET);
                opendir(my $dh, "$dir/$sd/$ssd/$sssd");
                my @files = grep { !/^\./ && !/recode/ && -f "$dir/$sd/$ssd/$sssd/$_" } readdir($dh);
                foreach my $phy (@files) {
                    push @alns, "$dir/$sd/$ssd/$sssd/$phy";
                }
            }
        }
    }
    return \@alns;
}
