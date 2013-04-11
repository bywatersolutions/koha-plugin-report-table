#!/usr/bin/perl

use Modern::Perl;

use FindBin;                                # locate this script
use lib "$FindBin::Bin/../../../../../";    # use the parent directory

use Koha::Plugin::Com::ByWaterSolutions::ReportTable;

use CGI;

my $cgi = new CGI;

my $coverflow =
  Koha::Plugin::Com::ByWaterSolutions::ReportTable->new( { cgi => $cgi } );
$coverflow->report();
