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

our $VERSION = 0.02;

our $CHANG_TREE = '/../00-DATA/Chang_orig_phylobayes.tre';
our $DIR  = Cwd::getcwd();

our $R = Statistics::R->new();
our $TOPD = 'topd_v4.6.pl';
our $SS_DATA_FILE = 'ss_data.estimate.storable';

MAIN: {
    my $rh_ssdata = get_ssdata();
    store $rh_ssdata, $SS_DATA_FILE;
    my $rh_ssdata = retrieve($SS_DATA_FILE);
    rboxplot($rh_ssdata);
    foreach my $blsf (sort {$a <=> $b} keys %{$rh_ssdata}) {
        my $pval = rttest($rh_ssdata->{$blsf}->{'nonrc'}, $rh_ssdata->{$blsf}->{'rc'});
        print "BLSF = $blsf, pval = $pval\n";
#prints the branch length scaling factor (BLSF) and p-values for t-tests performed on RFD values between non-recoded and recoded datasets.
    }
}
sub rboxplot {
    my $rh_ssdata = shift;
        my $rcmd = qq~library(ggplot2)\n~;
        $rcmd .= qq~Treatment=c()\nBranch=c()\nRFD=c()\n~;
        foreach my $blsf (sort {$a <=> $b} keys %{$rh_ssdata}) {
my @nrc_meds = ();
my @rc_meds = ();
push @nrc_meds, median($rh_ssdata->{$blsf}->{'nonrc'});
push @rc_meds, median($rh_ssdata->{$blsf}->{'rc'});
            my $num_norc = scalar(@{$rh_ssdata->{$blsf}->{'nonrc'}});
            my $num_rc   = scalar(@{$rh_ssdata->{$blsf}->{'rc'}});
            my $num_sum = $num_norc + $num_rc;
            $rcmd .= qq~Treatment=append(Treatment,rep(c("norecode"), each=$num_norc))\n~;
            $rcmd .= qq~Treatment=append(Treatment,rep(c("recode"),each=$num_rc))\n~;
            $rcmd .= qq~Branch=append(Branch,rep(c("$blsf"),each=$num_sum))\n~;
            my $recode_vals = join ',', @{$rh_ssdata->{$blsf}->{'nonrc'}}, @{$rh_ssdata->{$blsf}->{'rc'}};
            $rcmd .= qq~RFD=append(RFD,c($recode_vals))\n~;
for (my $i = 0; $i < @nrc_meds; $i++) {
        }
        $rcmd .= qq~data=data.frame(Branch, Treatment , RFD)\n~;
        # the following keeps gplot from reordering the X axis
        $rcmd .= q~data$Branch <- factor(data$Branch, levels = data$Branch)~ . "\n";
        $blsf =~ s|/|.|;
        $rcmd .= qq~pdf("$blsf.pdf",11,8.5)\n~;
        $rcmd .= qq~ggplot(data, aes(x=Branch, y=RFD, fill=Treatment)) + geom_boxplot() + scale_fill_manual(values=c("#8da0cb", "#fc8d62"))\n~;
my $R = Statistics::R->new() ;
$rcmd .= "options(max.print=99999999)\n";
$R->run($rcmd);
my $ra_out = $R->get('data');
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
    my ($ra_trees,$ra_rc_trees) = get_trees ("$DIR");
    for (my $i = 0; $i < @{$ra_trees}; $i++) {
            $ra_trees->[$i] =~ m/Chang\.mismatch\.|(\d+\.\d+)/ or die "unexpected";
            my $brlen_bin = $1;
            my $reftree = $CHANG_TREE;
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
            push  @{$ssdata{$brlen_bin}->{'nonrc'}}, $ss;
            push  @{$ssdata{$brlen_bin}->{'rc'}}, $ss_rc;
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
        die "missing: $dir/$ssd/$sssd/RAxML_bestTree.$sssd" unless (-e "$dir/$ssd/$sssd/RAxML_bestTree.$sssd");
             die "missing: $dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode" unless (-e "$dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode");
             push @trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd";
             push @rc_trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode";
}
        }
    }
    print "\n";
    return(\@trees,\@rc_trees);
}


sub median {
    my $ra_array = shift;
    my @vals = sort {$a <=> $b} @{$ra_array};
    my $len = @vals;
    if($len%2) #odd?
    {
        return $vals[int($len/2)];
    }
    else #even
    {
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}
