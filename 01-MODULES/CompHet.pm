package JFR::CompHet;

use strict;
$JFR::CompHet::AUTHOR  = 'Joseph Ryan';
$JFR::CompHet::VERSION = '1.07';

our $TREE000C = '(Acanthoeca_like_sp_10tr:0.241422,Stephanoeca_diplocostata:0.129387,((Salpingoeca_sp_atcc50818:0.354872,Monosiga_brevicollis_mx1:0.288754):0.184688,(Monosiga_ovata:0.37129,(((Ministeria_vibrans_atcc50519:0.579873,Capsaspora_owczarzaki_atcc30864:0.387197):0.071893,(Sphaeroforma_arctica_jp610:0.420388,Amoebidium_parasiticum_JAP72:0.21263):0.301429):0.090813,((Euplokamis_dunlapae:0.103096,(Vallicula_multiformis:0.11255,(Pleurobrachia_pileus:0.109756,(Mnemiopsis_leidyi:0.055345,Beroe_moroz:0.079461):0.026066):0.03234):0.044636):0.524453,(((((Sycon_coactum:0.055842,Sycon_ciliatum:0.047872):0.183183,Leucetta_chagosensis:0.136928):0.206819,((Oscarella_carmela:0.079065,Oscarella_sp_sn2011:0.093695):0.139681,Corticium_candelabrum:0.177515):0.136164):0.019658,((Euplectella_aspergillum:0.109352,Aphrocallistes_vastus:0.105561):0.603459,((Ircinia_fasciculata:0.261436,Chondrilla_nucula:0.298612):0.025314,(Ephydatia_muelleri:0.245096,(Petrosia_ficiformis:0.113941,Amphimedon_queenslandica:0.163019):0.108861):0.05383):0.048185):0.059975):0.020568,(Trichoplax_adhaerens:0.400088,((((Ixodes_scapularis:0.234903,(Strigamia_maritima:0.198918,((Pediculus_humanus_corporis:0.179199,Nasonia_vitripennis:0.162398):0.084954,Daphnia_pulex:0.21413):0.063396):0.014776):0.080523,((Octopus_vulgaris:0.233368,(Ilyanassa_obsoleta:0.206702,Crassostrea_gigas:0.153597):0.016695):0.040493,(Helobdella_robusta:0.276491,Capitella_teleta:0.187986):0.053595):0.043322):0.034707,((Saccoglossus_kowalevskii:0.165227,(Strongylocentrotus_purpuratus:0.168054,Patiria_miniata:0.135705):0.079578):0.043683,(Branchiostoma_floridae:0.197496,((Petromyzon_marinus:0.131691,(Latimeria_menadoensis:0.051757,Homo_sapiens:0.061051):0.057095):0.093457,(Ciona_intestinalis:0.181071,Botryllus_schlosseri:0.177162):0.203497):0.034725):0.018767):0.010276):0.060934,(((Polypodium_hydriforme:0.382371,(((Sphaeromyxa_zaharoni:0.566892,(Thelohanellus_kitauei:0.420027,Myxobolus_cerebralis:0.267713):0.412065):0.337792,(Kudoa_iwatai:0.291117,Enteromyxum_leei:0.385026):0.670472):0.311962,(Tetracapsuloides_bryosalmonae:0.190798,Buddenbrockia_plumatellae:0.154641):0.990015):0.502903):0.177381,((Craspedacusta_sowerbyi:0.14547,((Hydra_magnipapillata:0.103682,Ectopleura_larynx:0.100824):0.047863,((Nanomia_bijuga:0.149331,Hydractinia_polyclina:0.080322):0.012486,Clytia_hemisphaerica:0.133135):0.014148):0.054369):0.090563,(Tripedalia_cystophora:0.156917,(Cyanea_capillata:0.085254,(Stomolophus_meleagris:0.069638,Aurelia_aurita:0.063396):0.032611):0.08053):0.018991):0.03463):0.089885,((Gorgonia_ventalina:0.022775,Eunicella_cavolinii:0.024936):0.191724,(((Nematostella_vectensis:0.051253,Edwardsiella_lineata:0.051788):0.037372,((Urticina_eques:0.038036,Bolocera_tuediae:0.048381):0.02719,(Hormathia_digitata:0.053691,Aiptasia_pallida:0.046024):0.021567):0.048745):0.05722,((Pocillopora_damicornis:0.046085,Montastraea_faveolata:0.028255):0.011322,(Porites_australiensis:0.035129,Acropora_cervicornis:0.084061):0.008577):0.076243):0.04942):0.038314):0.045462):0.013371):0.015511):0.029048):0.200868):0.189239):0.051057):0.346489);';
our $TREE0008 = '((((A1:0.10,(A2:0.05,A3:0.05):0.05):0.075,(A4:0.10,A5:0.10):0.075):0.008577,((B1:0.10,(B2:0.05,B3:0.05):0.05):0.075,(B4:0.10,B5:0.10):0.075):0.008577):0.008577,(((C1:0.10,(C2:0.05,C3:0.05):0.05):0.075,(C4:0.10,C5:0.10):0.075):0.008577,((D1:0.10,(D2:0.05,D3:0.05):0.05):0.075,(D4:0.10,D5:0.10):0.075):0.008577):0.008577);';
# this is tree 0.008
our $TREE0004 = '((((A1:0.10,(A2:0.05,A3:0.05):0.05):0.075,(A4:0.10,A5:0.10):0.075):0.008577,((B1:0.10,(B2:0.05,B3:0.05):0.05):0.075,(B4:0.10,B5:0.10):0.075):0.008577):0.004289,(((C1:0.10,(C2:0.05,C3:0.05):0.05):0.075,(C4:0.10,C5:0.10):0.075):0.008577,((D1:0.10,(D2:0.05,D3:0.05):0.05):0.075,(D4:0.10,D5:0.10):0.075):0.008577):0.004289);';
# this is tree 0.004
our $TREE0002 = '((((A1:0.10,(A2:0.05,A3:0.05):0.05):0.075,(A4:0.10,A5:0.10):0.075):0.008577,((B1:0.10,(B2:0.05,B3:0.05):0.05):0.075,(B4:0.10,B5:0.10):0.075):0.008577):0.002145,(((C1:0.10,(C2:0.05,C3:0.05):0.05):0.075,(C4:0.10,C5:0.10):0.075):0.008577,((D1:0.10,(D2:0.05,D3:0.05):0.05):0.075,(D4:0.10,D5:0.10):0.075):0.008577):0.002145);';
# this is tree 0.002
our $TREE0001 = '((((A1:0.10,(A2:0.05,A3:0.05):0.05):0.075,(A4:0.10,A5:0.10):0.075):0.008577,((B1:0.10,(B2:0.05,B3:0.05):0.05):0.075,(B4:0.10,B5:0.10):0.075):0.008577):0.001073,(((C1:0.10,(C2:0.05,C3:0.05):0.05):0.075,(C4:0.10,C5:0.10):0.075):0.008577,((D1:0.10,(D2:0.05,D3:0.05):0.05):0.075,(D4:0.10,D5:0.10):0.075):0.008577):0.001073);';
# this is tree 0.001
our @CHANG_FREQ = (0.074, 0.063, 0.038, 0.055, 0.017, 0.036, 0.063, 0.067, 0.022, 0.068, 0.090, 0.080, 0.027, 0.037, 0.040, 0.055, 0.053, 0.007, 0.030, 0.078);
our @CHANG_RATE = (0.529, 1.603, 1.206, 13.742, 5.462, 4.044, 8.303, 1.524, 0.302, 0.712, 1.745, 2.295, 0.552, 7.485, 38.223, 9.140, 0.086, 0.524, 7.752, 1.907, 0.070, 2.160, 7.081, 0.249, 0.660, 8.442, 0.257, 0.811, 23.992, 1.214, 0.164, 0.676, 2.415, 1.648, 0.759, 0.409, 0.405, 18.285, 3.238, 9.495, 1.903, 6.141, 25.212, 0.714, 0.428, 7.341, 1.980, 0.560, 0.709, 27.305, 11.127, 0.087, 1.922, 0.576, 0.232, 1.638, 32.342, 2.242, 2.323, 0.039, 0.072, 0.607, 0.140, 0.066, 0.776, 4.120, 1.083, 0.039, 0.323, 0.147, 0.621, 0.005, 1.951, 2.450, 1.685, 2.290, 0.212, 2.652, 4.588, 0.470, 19.255, 8.014, 1.420, 4.846, 12.316, 16.825, 1.150, 23.246, 0.301, 3.560, 12.160, 9.039, 0.176, 3.587, 8.455, 6.877, 0.414, 0.665, 1.400, 1.046, 1.052, 0.140, 0.296, 2.989, 0.520, 0.099, 1.257, 2.574, 2.150, 0.086, 0.202, 1.110, 0.815, 0.003, 0.055, 0.683, 0.220, 0.125, 0.402, 9.044, 0.339, 0.259, 0.086, 0.166, 0.421, 2.171, 3.168, 1.542, 5.523, 2.149, 5.036, 2.300, 2.633, 29.982, 0.574, 18.584, 0.389, 19.041, 3.329, 0.135, 0.182, 4.497, 0.146, 0.635, 56.106, 0.539, 37.356, 8.806, 0.645, 0.603, 1.366, 1.441, 1.135, 6.672, 2.235, 0.089, 1.113, 2.954, 4.182, 0.118, 0.172, 0.642, 5.850, 0.448, 2.121, 8.880, 2.632, 1.545, 7.715, 0.183, 1.373, 0.434, 11.285, 67.356, 1.697, 5.623, 2.298, 0.045, 0.184, 0.923, 40.833, 0.624, 1.259, 0.471, 0.234, 0.557, 9.628, 13.968, 0.264, 1.000);

sub get_nodes{
    my $ANALYSIS = shift;
    my $root = ();
    my $node1 = ();
    my $node2 = ();
    if ($ANALYSIS eq 'CHANG'){
        $root = 't.reRoot(9)';
        $node1 = 7;
        $node2 = 28;
    }elsif ($ANALYSIS eq 'XXYY'){
        $root = 't.root';
	$node1 = 20;
	$node2 = 20;
#both are $node1 and $node2 are 20 because both needed to be specified with the way this script has been written.
    }else{
        $root = 't.root';
        $node1 = 2;
        $node2 = 21;         
    }
    return ($root, $node1, $node2);
}

sub get_tree_var {
    my $tree000x = shift;
    $tree000x =~ m/^TREE000[1248C]/ or die "arg ($tree000x) must be TREE0001 TREE0002 TREE0004 TREE0008 TREE000C";
    return $TREE0001 if ($tree000x eq 'TREE0001');
    return $TREE0002 if ($tree000x eq 'TREE0002');
    return $TREE0004 if ($tree000x eq 'TREE0004');
    return $TREE0008 if ($tree000x eq 'TREE0008');
    return $TREE000C if ($tree000x eq 'TREE000C');
    die "unexpected:$tree000x";
}

sub get_indiv_freqs {
    my $rh_s  = shift;
    my %freqs = ();
    for my $l ('A','B','C','D') {
        $freqs{$l} = get_freq_from_seq($rh_s->{"${l}1"},
                  $rh_s->{"${l}2"}, $rh_s->{"${l}3"},
                  $rh_s->{"${l}4"}, $rh_s->{"${l}5"});
    }
    return \%freqs;
}

sub get_freq_from_seq {
    my @seqs     = @_;
    my %aa_freq  = ();
    my %aa_count = ();
    my $count    = 0;
    foreach my $seq (@seqs) {
        my @aas = split /|/, $seq;
        foreach my $aa (@aas) {
            $count++;
            $aa_count{uc($aa)}++;
        }
    }
    foreach my $aa (keys %aa_count) {
        $aa_freq{$aa} = $aa_count{$aa} / $count;
    }
    return \%aa_freq;
}

sub get_indiv_comphet {
    my $rh_i_freqs = shift;
    my $ac = get_sub_index($rh_i_freqs->{'A'},$rh_i_freqs->{'C'});
    my $bd = get_sub_index($rh_i_freqs->{'B'},$rh_i_freqs->{'D'});

    my $ab = get_sub_index($rh_i_freqs->{'A'},$rh_i_freqs->{'B'});
    my $ad = get_sub_index($rh_i_freqs->{'A'},$rh_i_freqs->{'D'});
    my $bc = get_sub_index($rh_i_freqs->{'B'},$rh_i_freqs->{'C'});
    my $cd = get_sub_index($rh_i_freqs->{'C'},$rh_i_freqs->{'D'});

    my $comphet = ((($ab + $ad + $bc + $cd) / 4) - (($ac + $bd) / 2));

    return $comphet;
}

sub get_sub_index {
    my $rh_1 = shift;
    my $rh_2 = shift;
    my $subindex = 0;
    foreach my $aa (keys %{$rh_1}) {
        my $diff = $rh_1->{$aa} - $rh_2->{$aa};
        $diff *= -1 if ($diff < 0);
        $subindex += $diff;
    }
    return $subindex;
}

1;

__END__

=head1 NAME

JFR::CompHet - Perl extension for generating compositionally heterogeneous datasets 

=head1 SYNOPSIS

  use JFR::CompHet;

=head1 DESCRIPTION

subroutines used to generate compositionally heterogeneous datasets

=head1 AUTHOR

Joseph Ryan <joseph.ryan@whitney.ufl.edu>

=head1 SEE ALSO

=cut
