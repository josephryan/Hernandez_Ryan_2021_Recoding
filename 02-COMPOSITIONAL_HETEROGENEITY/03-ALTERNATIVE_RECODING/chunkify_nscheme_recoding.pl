#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Data::Dumper;
use Cwd;
use POSIX qw(ceil);
use lib qw(/Hernandez_Ryan_2019_RecodingSim/01-MODULES/);
use Servers;

our $DIR = Cwd::getcwd();
our %RECODE = ( '9' => 
      { 'D' => 0, 'E' => 0, 'H' => 0, 'N' => 0, 'Q' => 0, 'I' => 1,
        'L' => 1, 'M' => 1, 'V' => 1, 'F' => 2, 'Y' => 2, 'A' => 3, 'S' => 3,
        'T' => 3, 'K' => 4, 'R' => 4, 'G' => 5, 'P' => 6, 'C' => 7, 'W' => 8 },
      
      '12' =>  { 'D' => 0, 'E' => 0, 'Q' => 0, 'M' => 1, 'L' => 1, 'I' => 1,
        'V' => 1, 'F' => 2, 'Y' => 2, 'K' => 3, 'H' => 3, 'R' => 3, 'G' => 4,
        'A' => 5, 'P' => 6, 'S' => 7, 'T' => 8, 'N' => 9, 'W' => 'A', 'C' => 'B'      },

      '15' => { 'D' => 0, 'E' => 0, 'Q' => 0, 'M' => 1, 'L' => 1, 'I' => 2,
        'V' => 2, 'F' => 3, 'Y' => 3, 'G' => 4, 'A' => 5, 'P' => 6, 'S' => 7,
        'T' => 8, 'N' => 9, 'K' => 'A', 'H' => 'B', 'R' => 'C', 'W' => 'D',             'C' => 'E' },
      
      '18' => { 'F' => 0, 'Y' => 0, 'M' => 1, 'L' => 1, 'I' => 2, 'V' => 3,
        'G' => 4, 'A' => 5, 'P' => 6, 'S' => 7, 'T' => 8, 'D' => 9, 'E' => 'A',         'Q' => 'B', 'N' => 'C', 'K' => 'D', 'H' => 'E', 'R' => 'F', 'W' => 'G',         'C' => 'H' },
      );

MAIN: {
    my $num_bins = $ARGV[0] or die "usage: $0 NUM_BINS (e.g. 9 12 15 18) OUTDIR\n";
    my $outdir = $ARGV[1] or die "usage $0 NUM_BINS (e.g. 9 12 15 18) OUTDIR\n";
    my $ra_alns = get_alns($DIR);
    my %servers = %JFR::Servers::SERVERS;
    my $total_cores = eval(join '+', values %servers);
    my $cmds_per_script = ceil(scalar(@{$ra_alns}) / $total_cores);
    my $index = 0;
    foreach my $server (keys %servers) {
        for (my $i = 1; $i <= $servers{$server}; $i++) {
            open(my $out, ">", "$outdir/$server.$i.sh");
            for (my $j = 1; $j <= $cmds_per_script; $j++) {
                my $aln = $ra_alns->[$index];
                next if (not defined $aln);
                my $mod = 'PROTGAMMADAYHOFF';
                my @names = split /\./, $aln;
                my $num = '';
                if ($names[0] eq 'ran'){
                    $num = $names[2];
                } else { 
                    $num = $names[0];
                }
                next if ($aln =~ m/recode.PROTGAMMA/); # rerun problem
                mkdir "$DIR/$num.$mod.$num_bins" unless -d ("$DIR/$num.$mod.$num_bins");
                recode($aln,$mod, $num_bins);
                print $out "raxmlHPC -p 420 -m MULTIGAMMA -n $num.$mod.$num_bins.recode -w $DIR/$num.$mod.$num_bins -s $aln.recode.$mod.$num_bins -K GTR\n";
                $index++;
            }
        }
    }
}

sub recode {
    my $aln = shift;
    my $mod = shift;
    my $num_bins = shift;
    my $rh_recode = $RECODE{$num_bins};
    open(my $out, ">", "$aln.recode.$mod.$num_bins");
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
