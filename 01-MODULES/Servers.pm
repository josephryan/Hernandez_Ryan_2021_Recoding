package JFR::Servers;

use strict;
$JFR::Servers::AUTHOR = 'Joseph Ryan';
$JFR::Servers::VERSION = '1.00';

#our %SERVERS = (server1 => 45, server2 => 45, server3 => 45, server4 => 45);
our %SERVERS = ('myserver' => 32);
#number indicates number of CPUs available for each server.
# default is one server (myserver) with 32 CPUs. This number should be adjusted.
# if running on multiple servers, commented out %SERVERS includes several
# servers. Adjust names and numbers of corresponding CPUs

1;

__END__

=head1 NAME

JFR::Servers - Perl extension for generating individual shell scripts.

=head1 SYNOPSIS

  use JFR::Servers;

=head1 DESCRIPTION

used to generate individual shell scripts for all compositional heterogeneity and saturation analyses

=head1 AUTHOR

Joseph Ryan <joseph.ryan@whitney.ufl.edu>

=head1 SEE ALSO

=cut 
