#!/usr/bin/perl

$|++;

use strict;
use warnings;
use autodie;
use Statistics::R;
use Data::Dumper;
use Storable;
use File::Temp;
use lib qw(../../01-MODULES/);
use CompHet;
use Cwd;

our $VERSION = 0.01;

our $DIR = Cwd::getcwd();

our $R = Statistics::R->new();
our $TOPD = 'topd_v4.6.pl';

our $TREE = $ARGV[0] or die "usage: $0 TREE000X MODEL (e.g. DAYHOFF JTT DAYHOFF.9) [--chang]\n";
our $MOD = $ARGV[1] or die "usage: $0 TREE000X MODEL (e.g. DAYHOFF JTT DAYHOFF.9) [--chang]\n";

our $SS_DATA_FILE = "ss_data.$MOD.storable";

MAIN: {
    my $rh_ssdata = get_ssdata();
    store $rh_ssdata, $SS_DATA_FILE;
#comment out the two lines above if you have already run and only want to retrieve the data
    my $rh_ssdata = retrieve($SS_DATA_FILE);
    rboxplot($rh_ssdata);
    foreach my $infl (sort {$a <=> $b} keys %{$rh_ssdata}) {
        my $pval = rttest($rh_ssdata->{$infl}->{'nonrc'}, $rh_ssdata->{$infl}->{'rc'});
        print "BLSF = $infl, pval = $pval\n";
#prints the branch length scaling factor (BLSF) and p-values for t-tests performed on RFD values between non-recoded and recoded datasets.
    }
}
sub rboxplot {
    my $rh_ssdata = shift;
        my $rcmd = qq~library(ggplot2)\n~;
        $rcmd .= qq~Treatment=c()\nInflation=c()\nRFD=c()\n~;
        foreach my $infl (sort {$a <=> $b} keys %{$rh_ssdata}) {
            my $num_norc = scalar(@{$rh_ssdata->{$infl}->{'nonrc'}});
            my $num_rc   = scalar(@{$rh_ssdata->{$infl}->{'rc'}});
            my $num_sum = $num_norc + $num_rc;
            $rcmd .= qq~Treatment=append(Treatment,rep(c("norecode"), each=$num_norc))\n~;
            $rcmd .= qq~Treatment=append(Treatment,rep(c("recode"),each=$num_rc))\n~;
            $rcmd .= qq~Inflation=append(Inflation,rep(c("$infl"),each=$num_sum))\n~;
            my $recode_vals = join ',', @{$rh_ssdata->{$infl}->{'nonrc'}}, @{$rh_ssdata->{$infl}->{'rc'}};
            $rcmd .= qq~RFD=append(RFD,c($recode_vals))\n~;
            $rcmd .= qq~data=data.frame(Inflation, Treatment , RFD)\n~;
        # the following keeps gplot from reordering the X axis
            $rcmd .= q~data$Branch <- factor(data$Inflation, levels = data$Inflation)~ . "\n";
            $infl =~ s|/|.|;
            $rcmd .= qq~pdf("$MOD.0$infl.pdf",11,8.5)\n~;
            $rcmd .= qq~ggplot(data, aes(x=Inflation, y=RFD, fill=Treatment)) + geom_boxplot() + scale_fill_manual(values=c("#8da0cb", "#fc8d62"))\n~;
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
    my ($ra_rc_trees, $ra_trees) = get_trees ();
    for (my $i = 0; $i < @{$ra_trees}; $i++) {
            $ra_trees->[$i] =~ m/TREE\d+(\.\d)/ or die "unexpected";
            my $infl_bin = $1;
            my $reftree_dat          = JFR::CompHet::get_tree_var($TREE);
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
            push  @{$ssdata{$infl_bin}->{'nonrc'}}, $ss;
            push  @{$ssdata{$infl_bin}->{'rc'}}, $ss_rc;
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
our $NUMSETS  = 10;
    foreach my $line (@{$ra_res}) {
        next unless ($line =~ m/Split Distance \[differents\/possibles\]: [0-9\.]+ \[ (\d+) /);
        return $1;
    }
    die "couldn't find score";
}

sub get_trees {
    my @trees = ();
    my @rctrees = ();
    opendir(my $dh, "$DIR");
    my @ssdirs = grep {!/^\./ && -d "$DIR/$_"} readdir ($dh);
    foreach my $ssd (@ssdirs) {
        opendir(my $dh2, "$DIR/$ssd");
        my @sssd = grep {!/^\./ && -d "$DIR/$ssd/$_"} readdir ($dh2);
        foreach my $sssd (@sssd) {
            if ($sssd =~m/$MOD$/){
                opendir (my $dh3, "$DIR/$ssd/$sssd");
		my @files = grep { !/^\./ && -f "$DIR/$ssd/$sssd/$_"} readdir($dh3);
		foreach my $file (@files){
                    if ($file =~ m/RAxML_bestTree.*PROTGAMMA$MOD\.recode$/){
                        push @rctrees, "$DIR/$ssd/$sssd/$file";
                     }elsif ($file =~ m/RAxML_bestTree.*PROTGAMMA$MOD$/){
                         push @trees, "$DIR/$ssd/$sssd/$file";
                     }
                }
            }
        }
    }        
    return (\@rctrees,\@trees);
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
