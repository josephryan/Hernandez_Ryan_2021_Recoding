#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use Storable;
use Statistics::R;
use Cwd;

our $CHANG_TREE = '/00-DATA/Chang_orig_phylobayes.tre';

our $DIR = Cwd::getcwd();

our @SDIRS = qw(02-SEQ_GEN_CHANG/01-DAYHOFF 02-SEQ_GEN_CHANG/02-JTT);


our $R = Statistics::R->new();
our $TOPD = 'topd_v4.6.pl';
our $SS_DATA_LG_FILE = 'ss_data_lg_storable';

MAIN: {
    my $rh_rfd = get_data($DIR); store($rh_rfd,$SS_DATA_LG_FILE);
    my $rh_rfd = retrieve($SS_DATA_LG_FILE);
#comment out the two lines above if you have already run and only want to retrieve the data
    my $rh_med = get_medians($rh_rfd);
    rboxplot($rh_rfd);
    foreach my $sdir (sort keys %{$rh_rfd}){
        foreach my $blsf (sort {$a <=> $b} keys $rh_rfd->{$sdir}){
            my $lg_pval = rttest($rh_rfd->{$sdir}->{$blsf}->{'lg'}, $rh_rfd->{$sdir}->{$blsf}->{'rc'})
            print "LG vs RECODE: BLSF = $blsf, pval = $lg_pval\n";
#prints the p-values from t-tests performed on the RFD values between LG and recoded datasets.
        }
    }
}

sub rttest{
    my $ra_nr = shift;
    my $ra_rc = shift;
    my $x_csv = join ',', @{$ra_nr};
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

sub rboxplot{
    my $rh_rfd = shift;
    foreach my $sdir (sort keys %{$rh_rfd}){
        if ($sdir =~ m/\/0[12]-(\w+)/){
            my $path = $1;
            my $rcmd = qq~library(ggplot2)\n~;
            $rcmd .= qq~Model=c()\nBranch=c()\nRFD=c()\n~;
            foreach my $blsf (sort {$a <=> $b} keys $rh_rfd->{$sdir}){
                my @nrc_meds = ();
                my @lg_meds = ();
                my @rc_meds = ();
                push @nrc_meds, median($rh_rfd->{$sdir}->{$blsf}->{'nonrc'});
                push @lg_meds, median($rh_rfd->{$sdir}->{$blsf}->{'lg'});
                push @rc_meds, median($rh_rfd->{$sdir}->{$blsf}->{'rc'});
                my $num_nrc = scalar(@{$rh_rfd->{$sdir}->{$blsf}->{'nonrc'}});
                my $num_lg = scalar(@{$rh_rfd->{$sdir}->{$blsf}->{'lg'}});
                my $num_rc = scalar(@{$rh_rfd->{$sdir}->{$blsf}->{'rc'}});
                my $num_sum = $num_nrc + $num_lg + $num_rc;
                if ($sdir =~ m/DAYHOFF$/){
                    $rcmd .= qq~Model=append(Model,rep(c("Dayhoff"), each=$num_nrc))\n~;
                } elsif ($sdir =~ m/JTT$/){
                    $rcmd .= qq~Model=append(Model,rep(c("JTT"), each=$num_nrc))\n~;
                }    
                $rcmd .= qq~Model=append(Model,rep(c("LG"),each=$num_lg))\n~;
                $rcmd .= qq~Model=append(Model,rep(c("Recoding"),each=$num_rc))\n~;
                $rcmd .= qq~Branch=append(Branch,rep(c("$blsf"),each=$num_sum))\n~;
                my $rfd_vals = join ',', @{$rh_rfd->{$sdir}->{$blsf}->{'nonrc'}}, @{$rh_rfd->{$sdir}->{$blsf}->{'lg'}}, @{$rh_rfd->{$sdir}->{$blsf}->{'rc'}};
                $rcmd .= qq~RFD=append(RFD,c($rfd_vals))\n~;

                $rcmd .= qq~data=data.frame(Branch, Model, RFD)\n~;
                $rcmd .= q~data$Branch <- factor(data$Branch, levels = data$Branch)~ . "\n";
                $blsf =~ s|/|.|;
                $rcmd .= qq~pdf("$path.$blsf.pdf",11,8.5)\n~;
                $rcmd .= qq~ggplot(data, aes(x=Branch, y=RFD, fill=Model)) + geom_boxplot() + scale_fill_manual(values=c("#66c2a5", "#8da0cb", "#fc8d62"))\n~;
                my $R = Statistics::R->new() ;
                $rcmd .= "options(max.print=99999999)\n";
                $R->run($rcmd);
                my $ra_out = $R->get('data');    
            }
        }
    }
}

sub get_medians {
    my $rh_rfd = shift;
    my %med    = ();
    foreach my $bin (keys %{$rh_rfd}) {
        my $median = median($rh_rfd->{$bin});
        $med{$bin} = $median;
    }
    return \%med;
}

sub get_data {
    my %data = ();
    foreach my $sdir (@SDIRS){
        my ($ra_trees, $ra_rc_trees, $ra_lg_trees) = get_trees ("$DIR/$sdir");
        print Dumper $ra_lg_trees;
        for (my $i = 0; $i< @{$ra_trees}; $i++) {
            $ra_trees->[$i] =~ m/\w+\.\w+\.(\d+)\/(\d+)/ or die "unexpected: $ra_trees->[$i]";
            my $brlen_bin = $1;
            my $reftree = $CHANG_TREE;
            my $reftree_dat          = get_file_contents($reftree);
            my $tree_dat             = get_file_contents($ra_trees->[$i]);
            my $rc_tree_dat          = get_file_contents($ra_rc_trees->[$i]);
            my $lg_tree_dat          = get_file_contents($ra_lg_trees->[$i]);
            my ($fh, $filename)      = File::Temp::tempfile(TMPDIR => 1);
            my ($fhrc, $rc_filename) = File::Temp::tempfile(TMPDIR => 1);
            my ($fhlg, $lg_filename) = File::Temp::tempfile(TMPDIR => 1);
            print $fh "$reftree_dat\n$tree_dat";
            print $fhrc "$reftree_dat\n$rc_tree_dat";
            print $fhlg "$reftree_dat\n$lg_tree_dat";
            my @topdout = `perl $TOPD -m split -f $filename -r no`;
            my @topdout_rc = `perl $TOPD -m split -f $rc_filename -r no`;
            my @topdout_lg = `perl $TOPD -m split -f $lg_filename -r no`;
            my $ss = get_splitscore(\@topdout);
            my $ss_rc = get_splitscore(\@topdout_rc);
            my $ss_lg = get_splitscore(\@topdout_lg);
            push @{$data{$sdir}->{$brlen_bin}->{'nonrc'}}, $ss;
            push @{$data{$sdir}->{$brlen_bin}->{'rc'}}, $ss_rc;
            push @{$data{$sdir}->{$brlen_bin}->{'lg'}}, $ss_lg;
            print ".";
        }
    }
   return \%data;
}

sub get_file_contents{
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

sub get_trees{
    my $dir = shift;
    my @trees = ();
    my @rc_trees = ();
    my @lg_trees = ();
    opendir(my $dh, $dir);
    my @ssdirs = grep {!/^\./ && -d "$dir/$_"} readdir ($dh);
    foreach my $ssd (@ssdirs) {
        if ($ssd =~m/(Chang\.\w{3}\.(1|5|10|15|20)$)/){
            opendir(my $dh2, "$dir/$ssd");
            my @sssdirs = grep {!/^\./ && -d "$dir/$ssd/$_"} readdir ($dh2);
            foreach my $sssd (@sssdirs){
                if ($sssd =~m/(PROTGAMMALG)$/){
                    push @lg_trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd";
                } else {
                    push @trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd";
                    push @rc_trees, "$dir/$ssd/$sssd/RAxML_bestTree.$sssd.recode";
                }
            }
        }
    }
    return (\@trees,\@rc_trees, \@lg_trees);
}

sub median {
    my $ra_data = shift;
    my @vals = sort {$a <=> $b} @{$ra_data};
    my $len = @vals;
    if ($len % 2) {
        return $vals[int($len/2)];
    } else {
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}

