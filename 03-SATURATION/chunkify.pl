
use strict;
use warnings;
use autodie;
use Data::Dumper;
use POSIX qw(ceil);
use Cwd;
use lib qw(../01-MODULES/);
use Servers;
 
# this script generate shell scripts to be launched on your servers or operating systems.

our $VERSION = 0.02;

our $DIR = Cwd::getcwd();
our @SUBDIRS = qw(02-SEQ_GEN_CHANG 03-SEQ_GEN_FEUDA);
our @SUBSUBDIRS = qw(01-DAYHOFF 02-JTT);
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
                    $mod = 'PROTGAMMADAYHOFF';
                } elsif ($aln =~ m/JTT/) {
                    $mod = 'PROTGAMMAJTT';
                } else {
                    die "couldn't figure model: $aln";
                }
                next if ($aln =~ m/recode.PROTGAMMA/); # rerun problem
                $aln =~ m/^(.*)\/(\d+)\.phy$/ or die "unexpected regex:$aln";
                my $dir = $1;
                my $num = $2;
                mkdir "$dir/$num.$mod" unless -d ("$dir/$num.$mod");
                print $out "raxmlHPC -p 420 -m $mod -n $num.$mod -w $dir/$num.$mod -s $aln\n";
                recode($aln,$mod);
                print $out "raxmlHPC -p 420 -m MULTIGAMMA -n $num.phy.$mod.recode -w $dir/$num.$mod -s $aln.recode.$mod -K GTR\n";
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
            $recoded .= $rh_recode->{uc($aa)};
        }
        print $out "$fields[0]  $recoded\n";
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
                opendir(my $dh, "$dir/$sd/$ssd/$sssd");
                my @files = grep { !/^\./ && -f "$dir/$sd/$ssd/$sssd/$_" } readdir($dh);
                foreach my $phy (@files) {
                    push @alns, "$dir/$sd/$ssd/$sssd/$phy";
                }
            }
        }
    }
    return \@alns;
}
