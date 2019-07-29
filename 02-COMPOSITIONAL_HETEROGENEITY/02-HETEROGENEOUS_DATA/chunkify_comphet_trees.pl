#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Data::Dumper;
use Cwd;
use POSIX qw(ceil);
use lib (/Hernandez_Ryan_2019_RecodingSim/01-MODULES/);
use Servers;

our $VERSION = 0.02;

our $DIR = Cwd::getcwd();
our $OUTDIR = 'scripts';
our %RECODE = ( 'PROTGAMMADAYHOFF' => 
      { 'A' => 0, 'S' => 0, 'T' => 0, 'G' => 0, 'P' => 0, 'D' => 1,
        'N' => 1, 'E' => 1, 'Q' => 1, 'R' => 2, 'K' => 2, 'H' => 2, 'M' => 3,
        'V' => 3, 'I' => 3, 'L' => 3, 'F' => 4, 'Y' => 4, 'W' => 4, 'C' => 5 },

      'PROTGAMMAJTT' =>
      { 'A' => 0, 'P' => 0, 'S' => 0, 'T' => 0, 'D' => 1, 'E' => 1, 'N' =>1,
        'G' => 1, 'Q' => 2, 'K' => 2, 'R' => 2, 'M' => 3, 'I' => 3, 'V' => 3,
        'L' => 3, 'W' => 4, 'C' => 4, 'F' => 5, 'Y' => 5, 'H' => 5 }
      );

MAIN: {
    my $ra_alns = get_alns($DIR);
    my %servers = %JFR::Servers::SERVERS;
    my $total_cores = eval(join '+', values %servers);
    my $cmds_per_script = ceil(scalar(@{$ra_alns}) / $total_cores);
    my $index = 0;
    foreach my $server (keys %servers) {
        for (my $i = 1; $i <= $servers{$server}; $i++) {
            open(my $out, ">", "$OUTDIR/$server.$i.sh");
            for (my $j = 1; $j <= $cmds_per_script; $j++) {
                my $aln = $ra_alns->[$index];
                next if (not defined $aln);
                my @names = split /\./, $aln;
                my $num = '';
                if ($names[0] eq 'ran'){
                    $num = $names[2];
                } else { 
                    $num = $names[0];
                }
                next if ($aln =~ m/recode.PROTGAMMA/); # rerun problem
                foreach my $mod (keys %RECODE){
                    mkdir "$DIR/$num.$mod" unless -d ("$DIR/$num.$mod");
                    print $out "raxmlHPC -p 420 -m $mod -n $num.$mod -w $DIR/$num.$mod -s $aln\n";
                    recode($aln,$mod);
                    print $out "raxmlHPC -p 420 -m MULTIGAMMA -n $num.$mod.recode -w $DIR/$num.$mod -s $aln.recode.$mod -K GTR\n";
                }
            $index++;
            }
        }
    }
}

sub recode {
    my $aln = shift;
    my $mod = shift;
    my $rh_recode = $RECODE{$mod};
    open(my $out, ">", "$aln.recode.$mod");
    open(my $fh, "<", $aln);
    my $head = <$fh>;
    print $out $head;
    while (my $line = <$fh>) {
        chomp $line;
        my @fields = split /\s+/, $line;
        my @aas = split /|/, $fields[1];
        my $recoded = '';
        foreach my $aa (@aas) {
            if ($aa eq '-'){
                $recoded .= '-';
            } else {
            $recoded .= $rh_recode->{uc($aa)};           
            }
        }
        print $out "$fields[0]  $recoded\n";

    }
}

sub get_alns {
    my $dir = shift;
    my @alns = ();
    opendir(my $dh, "$dir");
    my @files = grep { !/^\./ && -f "$dir/$_" } readdir($dh);
    foreach my $phy (@files) {
        if ($phy =~m/\d+.phy/){
            push @alns, "$phy";
        }
    }
    return \@alns;
}
