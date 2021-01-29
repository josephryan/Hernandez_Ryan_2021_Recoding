#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

our $VERSION = 0.03;

MAIN: {
    my $rh_opts  = process_options();
    my $ra_files = get_files($rh_opts->{'dir'},$rh_opts) if ($rh_opts->{'dir'});
    $ra_files = [$rh_opts->{'alignment'}] unless ($rh_opts->{'dir'});
    my $subdir = (split '/', $rh_opts->{'dir'})[-1];
    print "$subdir\n";
    foreach my $file (@{$ra_files}) {
        my $rh_data  = get_data($rh_opts,$file);
        my $rh_means = get_means($rh_data);
        my $rh_comp  = get_composition($rh_data);
        my $rcfv     = get_rcfv($rh_comp,$rh_means);
	#print "$file; RCFV: $rcfv\n";
	print "$rcfv\n";
    }
}

sub get_files {
    my $dir = shift;
    my $rh_o = shift;
    opendir DIR, $dir or die "cannot opendir $dir:$!";
    my @tmp = ();
    if ($rh_o->{'pattern'}) {
        @tmp = grep { !/^\./ && /$rh_o->{'pattern'}/ } readdir DIR;
    } else {
        @tmp = grep { !/^\./ } readdir DIR;
    }
    my @files = ();
    foreach my $fi (@tmp) {
        push @files, "$dir/$fi";
    }
    return \@files;
}

sub get_data {
    my $rh_o = shift;
    my $file = shift;
    my $rh_data = {};
    if ($rh_o->{'fasta'}) {
        $rh_data = get_fasta_data($file);
    } elsif ($rh_o->{'phylip'}) {
        $rh_data = get_phylip_data($file);
    } else {
        die "unexpected";
    }
    return $rh_data;
}

sub get_phylip_data {
    my $file = shift;
    my %data = ();
    open IN, $file or die "cannot open $file:$!";
    my $header = <IN>;
    $header =~ s/\s+//g;
    die "first line of phylip file is expected to contain only numbers" unless ($header =~ m/^\d+$/);
    while (my $line = <IN>) {
        chomp $line;
        my @phy = split /\s+/, $line;
        die "expecting phylip sequence lines to consist of a label (w/o spaces) followed by whitespace followed by sequence" unless (scalar(@phy) == 2);
        $phy[1] =~ s/[\?NnXx-]/N/g;
        my @fields = split /|/, $phy[1];
        $data{$phy[0]} = \@fields;
    }
    return \%data;
}

sub usage {
    print "usage: $0 {--dir=DIRECTORY or --alignment=FILE} {--fasta or --phylip} [--pattern=PATTERN]\n";
    exit;
}

sub process_options {
    my $rh_o = {};
    my $opt_results = Getopt::Long::GetOptions(
                              "version" => \$rh_o->{'version'},
                                 "help" => \$rh_o->{'help'},
                                "dir=s" => \$rh_o->{'dir'},
                          "alignment=s" => \$rh_o->{'alignment'},
                            "pattern=s" => \$rh_o->{'pattern'},
                                "fasta" => \$rh_o->{'fasta'},
                               "phylip" => \$rh_o->{'phylip'},
                            );
    die "$VERSION\n" if ($rh_o->{'version'});
    pod2usage({-exitval => 0, -verbose => 2}) if $rh_o->{'help'};
    unless (($rh_o->{'alignment'} || $rh_o->{'dir'}) && ($rh_o->{'fasta'} || $rh_o->{'phylip'})) {
        print "missing --alignment or --dir\n" unless ($rh_o->{'alignment'} || $rh_o->{'dir'});
        print "--fasta or --phylip is required\n" unless ($rh_o->{'fasta'} || $rh_o->{'phylip'});
        usage();
    }
    return $rh_o;
}

sub get_rcfv {
    my $rh_c = shift;
    my $rh_m = shift;
    my $rcfv = 0;
    my $n    = scalar(keys(%{$rh_c}));
    
    foreach my $id (keys %{$rh_c}) {
        foreach my $aa_nt (keys %{$rh_m}) {
            # set percent to 0 if $aa_nt is not in a particular sequence
            my $percent = $rh_c->{$id}->{$aa_nt} || 0; 
            $rcfv += absolute($rh_m->{$aa_nt} - $percent) / $n;
        }
    }
    return $rcfv;
}

sub absolute {
    my $val = shift;
    $val *= -1 if ($val < 0);
    return $val;
}


sub get_composition {
    my $rh_d = shift;
    my %counts = ();
    my %totals = ();
    my %composition = ();
    foreach my $id (keys %{$rh_d}) {
        foreach my $aa_nt (@{$rh_d->{$id}}) {
            next if ($aa_nt eq 'N');
            $counts{$id}->{$aa_nt}++;
            $totals{$id}++;
        }
    }
    foreach my $id (keys %counts) {
        foreach my $aa_nt (keys %{$counts{$id}}) {
            $composition{$id}->{$aa_nt} = $counts{$id}->{$aa_nt} / $totals{$id};
        }
    }
    return \%composition;
}

sub get_fasta_data {
    my $file = shift;
    my %data = ();
    my $fp = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        $rec->{'seq'} =~ s/[\?NnXx-]/N/g;
        my @fields = split /|/, $rec->{'seq'};   
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        $data{$id} = \@fields;
    }
    return \%data;
}

sub get_means {
    my $rh_d   = shift;
    my %counts = ();
    my %means  = ();
    my $total = 0;
    foreach my $id (keys %{$rh_d}) {
        foreach my $aa_nt (@{$rh_d->{$id}}) {
            next if ($aa_nt eq 'N');
            $counts{$aa_nt}++;
            $total++;
        }
    }
    foreach my $aa_nt (keys %counts) {
        $means{$aa_nt} = $counts{$aa_nt} / $total;
    }
    return \%means;
}

__END__

=head1 NAME

B<rcfv.pl> - Calculate RCFV for a set of aligned sequences

=head1 AUTHOR

Joseph F. Ryan <joseph.ryan@whitney.ufl.edu>

=head1 SYNOPSIS

rcfv.pl {--dir=DIRECTORY or --alignment=FILE} {--fasta or --phylip} [--pattern=PATTERN]

=head1 DESCRIPTION

This program generates an Relative Composition Frequency Variabilily (RCFV) value for a particular alignment or directory of alignments. RCFV is the absolute deviation from the mean for each amino-acid or nucleotide and taxon and sums these up over all taxa and amino-acids/nucleotides. The higher the RCFV value is, the higher is the degree of compositional heterogeneity. This is a streamlined version of the BaCoCa program, which generates many more measures. This version offers the following advantages if all you want is an RCFV for a given alignment: (1) ease of install, (2) simple one-line output, (3) no problems if certain taxa do not have all bases or amino acids.  If you are interested in generating RCFV for a subset of taxa (e.g. a clade) simply make a version of your alignment(s) with just those taxa.

=head1 BUGS

Please report them to <joseph.ryan@whitney.ufl.edu>

=head1 OPTIONS

=over 2

=item B<--dir>

A directory of FASTA or phylip alignments (no other files should be in dir)

=item B<--alignment>

A FASTA or phylip formatted alignment

=item B<--fasta>

Alignment is in FASTA format

=item B<--phylip>

Alignment is in PHYLIP format (only simple 1 line per taxa is accepted)

=item B<--pattern>

when using --dir, only files with this pattern are returned

=item B<--version>

Print Version and exit

=item B<--help>

Print this help

=back

=head1 COPYRIGHT

Copyright (C) 2020,2021 Joseph F. Ryan

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut
