#!/usr/bin/perl

$|++;

use strict;
use warnings;
use autodie;
use Statistics::R;
use Data::Dumper;
use Storable;
use File::Temp;
use Cwd;

our $VERSION = 0.04;

our $CHANG_TREE = '/Hernandez_Ryan_2019_RecodingSim/03-SATURATION/00-DATA/Chang_orig_phylobayes.tre';
our $FEUDA_TREE = '/Hernandez_Ryan_2019_RecodingSim/03-SATURATION/00-DATA/CHANG_DAYHOFF_CAT_GTR.tre';
our $DIR  = Cwd::getcwd();

our @SDIRS = qw(02-SEQ_GEN_CHANG/01-DAYHOFF 02-SEQ_GEN_CHANG/02-JTT 03-SEQ_GEN_FEUDA/01-DAYHOFF 03-SEQ_GEN_FEUDA/02-JTT);

our $R = Statistics::R->new();
our $TOPD = 'topd_v4.6.pl';
our $SS_DATA_FILE = "ss_data.$VERSION.storable";

MAIN: {
    my $rh_ssdata = get_ssdata();
    store ($rh_ssdata, $SS_DATA_FILE);
    my $rh_ssdata = retrieve($SS_DATA_FILE);
    rboxplot($rh_ssdata);
    foreach my $sdir (sort keys %{$rh_ssdata}) {
        foreach my $blsf (sort {$a <=> $b} keys %{$rh_ssdata->{$sdir}->{'rc'}}) {
            my $pval = rttest($rh_ssdata->{$sdir}->{'nonrc'}->{$blsf},$rh_ssdata->{$sdir}->{'rc'}->{$blsf});
            print "directory = $sdir, BLSF = $blsf, pval = $pval\n";
#prints the directory, branch length scaling factor (BLSF), and p-values for t-tests performed on RFD values between non-recoded and recoded datasets.
        }
    }
}
sub rboxplot {
    my $rh_ssdata = shift;
    foreach my $sdir (sort keys %{$rh_ssdata}) {
        my $rcmd = qq~library(ggplot2)\n~;
        $rcmd .= qq~treatment=c()\nvariety=c()\nnote=c()\n~;
        foreach my $blsf (sort {$a <=> $b} keys %{$rh_ssdata->{$sdir}->{'rc'}}) {
            my $num_norc = scalar(@{$rh_ssdata->{$sdir}->{'nonrc'}->{$blsf}});
            my $num_rc   = scalar(@{$rh_ssdata->{$sdir}->{'rc'}->{$blsf}});
            my $num_sum = $num_norc + $num_rc;
            $rcmd .= qq~treatment=append(treatment,rep(c("norecode"),each=$num_norc))\n~;
            $rcmd .= qq~treatment=append(treatment,rep(c("recode"),each=$num_rc))\n~;
            $rcmd .= qq~variety=append(variety,rep(c("$blsf"),each=$num_sum))\n~;
            my $recode_vals = join ',', @{$rh_ssdata->{$sdir}->{'nonrc'}->{$blsf}},@{$rh_ssdata->{$sdir}->{'rc'}->{$blsf}};
            $rcmd .= qq~note=append(note,c($recode_vals))\n~;
        }
        $rcmd .= qq~data=data.frame(variety, treatment ,  note)\n~;
        $rcmd .= q~data$V1 <- factor(data$variety, levels = data$variety)~ . "\n";
        $sdir =~ s|/|.|;
        $rcmd .= qq~pdf("$sdir.pdf",11,8.5)\n~;
        $rcmd .= qq~ggplot(data, aes(x=variety, y=note, fill=treatment)) + geom_boxplot()\n~;
my $R = Statistics::R->new() ;
$rcmd .= "options(max.print=99999999)\n";
$R->run($rcmd);
my $ra_out = $R->get('data');
    print_variety($ra_out,$sdir);
    }
}

sub print_variety {
    my $ra_out = shift;
    my $sdir   = shift;
    shift @{$ra_out};
    shift @{$ra_out};
    shift @{$ra_out};
    shift @{$ra_out};
    my $count = 0;
    my %blarg = ();
    foreach my $val (@{$ra_out}) {
        $count++;
        next if ($blarg{"$sdir:$val"} && $count == 2);
        print "$sdir: $val\n" if ($count == 2);
        $blarg{"$sdir:$val"}++ if ($count == 2);
        $count = 0 if ($count == 5);
    }
}

sub rttest {
    my $ra_nonrc = shift;
    my $ra_rc = shift;
    my $x_csv = join ',', @{$ra_nonrc};
    my $y_csv = join ',', @{$ra_rc};
    my $rcode = 'x <- c(' . $x_csv . ')' . "\n";
    $rcode .=   'y <- c(' . $y_csv . ')' . "\n";
    $rcode .= qq~out <- t.test(y,x,alternative="greater")~;
    my $R = Statistics::R->new() ;
    $R->run($rcode);
    my $ra_out = $R->get('out');
    die "unexpected" unless ($ra_out->[14] eq 'p-value');
    return $ra_out->[16];
}

sub get_ssdata {
    my %ssdata = ();
    foreach my $sdir (@SDIRS) {
        my ($ra_trees,$ra_rc_trees) = get_trees("$DIR/$sdir");
        for (my $i = 0; $i < @{$ra_trees}; $i++) {
            $ra_trees->[$i] =~ m/RAxML_bestTree\.(\d+)\./ or die "unexpected";
            $ra_trees->[$i] =~ m|$sdir/[^/0-9]+\.([0-9\.]+)/| or die "unexpected";
            my $brlen_bin = $1;
            my $reftree = $CHANG_TREE;
            $reftree = $FEUDA_TREE if ($sdir =~ m/FEUDA/);
            my $reftree_dat          = get_file_contents($reftree);
            my $tree_dat             = get_file_contents($ra_trees->[$i]);
            my $rc_tree_dat          = get_file_contents($ra_rc_trees->[$i]);
            my ($fh, $filename)      = File::Temp::tempfile(TMPDIR => 1);
            my ($fhrc, $rc_filename) = File::Temp::tempfile(TMPDIR => 1);
            print $fh "$reftree_dat\n$tree_dat";
            print $fhrc "$reftree_dat\n$rc_tree_dat";
            my @topdout = `perl $TOPD -m split -f $filename -r no`;
            my @topdout_rc = `perl $TOPD -m split -f $rc_filename -r no`;
            my $ss = get_splitscore(\@topdout);
            my $ss_rc = get_splitscore(\@topdout_rc);
            push @{$ssdata{$sdir}->{'nonrc'}->{$brlen_bin}}, $ss;
            push @{$ssdata{$sdir}->{'rc'}->{$brlen_bin}}, $ss_rc;
        }
    }
    return \%ssdata;
}

sub get_file_contents {
    my $file = shift;
    open(my $fh, "<", $file);
    my $contents = '';
    while (my $line = <$fh>) {
        $contents .= $line;
    } 
    return $contents;
}

sub get_splitscore {
    my $ra_res = shift;
    foreach my $line (@{$ra_res}) {
        next unless ($line =~ m/Split Distance \[differents\/possibles\]: [0-9\.]+ \[ (\d+) /);
        return $1;
    }
    die "couldn't find score";
}

sub get_trees {
    my $dir = shift;
    my @trees = ();
    my @rc_trees = ();
    opendir(my $dh, $dir);
    my @ssdirs = grep {!/^\./ && -d "$dir/$_"} readdir ($dh);
    foreach my $ssd (@ssdirs) {
        opendir(my $dh2, "$dir/$ssd");
        my @sssdirs = grep {!/^\./ && -d "$dir/$ssd/$_"} readdir ($dh2);
        foreach my $sssd (@sssdirs) {
            print ".";
            next if ($sssd =~m/(PROTGAMMALG)$/);
            next if ($sssd =~m/scripts/);
            die "missing: $dir/$ssd/$sssd/RAxML_bestTree.$sssd" unless (-e "$dir/$ssd/$sssd/RAxML_bestTree.$sssd");
            die "missing: $dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode" unless (-e "$dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode");
            push @trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd";
            push @rc_trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode";
        }
    }
    return(\@trees,\@rc_trees);
}
